import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:timetap/models/tag-stamp/tag_stamp_model.dart';
import 'package:timetap/repository/tag_stamp/tag_stamp_repository.dart';
import '../../repository/local_auth/local_auth_repository.dart';
import '../../utils/custom_exception.dart';

part 'tag_stamp_events.dart';

part 'tag_stamp_state.dart';

class TagStampBloc extends Bloc<TagStampEvent, TagStampState> {
  final TagStampRepository _tagStampRepository;
  final toleranceMeter = 10;
  bool _isCancelled = false;

  TagStampBloc({
    required TagStampRepository tagStampRepository,
  })  : _tagStampRepository = tagStampRepository,
        super(ClockInInitialState()) {
    on<ExecClockIn>(_execClockIn);
    on<CancelClockIn>(_cancelClockIn);
  }

  Future<void> _execClockIn(
    ExecClockIn event,
    Emitter<TagStampState> emit,
  ) async {
    _isCancelled = false;

    bool isNfcAvailable = await NfcManager.instance.isAvailable();
    bool isGeolocatorAvailable = await _manageGeolocatorPermission();
    if (!isNfcAvailable || !isGeolocatorAvailable) {
      emit(NoSensorActiveState());
      return;
    }
    emit(ClockingInState());
    Completer<void> completer = Completer<void>();
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      if (_isCancelled) {
        emit(ClockInErrorState());
        completer.complete();
        return;
      }
      emit(ReadNfcState());
      emit(await _onDiscoveredTag(tag)
          ? ClockInSuccessState()
          : ClockInErrorState());
      completer.complete();
    });
    await completer.future;
  }

  void _cancelClockIn(CancelClockIn event, Emitter<TagStampState> emit) {
    _isCancelled = true;
    NfcManager.instance.stopSession();
    emit(ClockInCancelledState());
  }

  Future<bool> _onDiscoveredTag(NfcTag tag) async {
    if (_isCancelled) return false;

    final ndef = Ndef.from(tag);
    if (ndef == null) {
      return false;
    }
    final record = ndef.cachedMessage?.records.firstOrNull;
    if ((record != null) &&
        record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
      if (String.fromCharCodes(record.type) == 'U') {
        var payload = record.payload;
        var uri = String.fromCharCodes(payload.sublist(1));
        TagStampModel tagStampInfo = _getNfcTagInfo(uri);

        if (await _biometricAuthentication()) {
          return await _sendClockInToDB(tagStampInfo);
        }
      }
    }

    if (record == null) {
      print('No cached NDEF message found');
      return false;
    }
    return false;
  }

  TagStampModel _getNfcTagInfo(String uri) {
    TagStampModel tagStampInfo = TagStampModel.empty;
    if (uri.startsWith('geo:')) {
      var geoParts = uri.substring(4).split('?');
      if (geoParts.length > 1 && geoParts[1].startsWith('q=')) {
        var query = geoParts[1].substring(2);
        var queryParts = query.split('(');
        tagStampInfo = tagStampInfo.copyWith(coordinates: [
          double.parse(queryParts.first.split(',').first),
          double.parse(queryParts.first.split(',').last),
        ]);
        if (queryParts.length > 1) {
          tagStampInfo = tagStampInfo.copyWith(
            positionLabel: queryParts[1].replaceFirst(')', ''),
          );
        }
      }
    }
    return tagStampInfo;
  }

  Future<bool> _biometricAuthentication() async {
    if (_isCancelled) return false;
    return await LocalAuthRepository.authenticate();
  }

  Future<bool> _manageGeolocatorPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<bool> _sendClockInToDB(TagStampModel tagStampInfo) async {
    if (_isCancelled) return false;

    final devicePosition = await Geolocator.getCurrentPosition();
    final distance = Geolocator.distanceBetween(
      tagStampInfo.coordinates.first,
      tagStampInfo.coordinates.last,
      devicePosition.latitude,
      devicePosition.longitude,
    );
    if (distance < toleranceMeter) {
      try {
        await _tagStampRepository.addNewTagStamp(
          coordinates: tagStampInfo.coordinates,
          label: tagStampInfo.positionLabel,
        );
        _isCancelled = true;
        NfcManager.instance.stopSession();
        return true;
      } on CustomException catch (ex) {
        return false;
      }
    } else {
      return false;
    }
  }
}
