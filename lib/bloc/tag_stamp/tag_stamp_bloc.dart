import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:timetap/models/tag-stamp/tag_stamp_model.dart';
import 'package:timetap/repository/tag_stamp/tag_stamp_repository.dart';
import '../../repository/local_auth/local_auth_repository.dart';

part 'tag_stamp_events.dart';
part 'tag_stamp_state.dart';

class TagStampBloc extends Bloc<TagStampEvent, TagStampState> {
  final TagStampRepository _tagStampRepository;
  final toleranceMeter = 10;

  TagStampBloc({
    required TagStampRepository tagStampRepository,
  })  : _tagStampRepository = tagStampRepository,
        super(ClockInInitialState()) {
    on<ExecClockIn>(_execClockIn);
  }

  Future<void> _execClockIn(
    ExecClockIn event,
    Emitter<TagStampState> emit,
  ) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      return;
    }
    emit(const ClockingInState());
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) => _onDiscoveredTag(tag));
  }

  Future<void> _onDiscoveredTag(NfcTag tag) async {
    final ndef = Ndef.from(tag);
    if (ndef == null) {
      print('No NDEF data found on tag');
      return;
    }
    final record = ndef.cachedMessage?.records.firstOrNull;
    if ((record != null) && record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
      if (String.fromCharCodes(record.type) == 'U') {
        var payload = record.payload;
        var uri = String.fromCharCodes(payload.sublist(1));
        TagStampModel tagStampInfo = _getNfcTagInfo(uri);

        if (await _biometricAuthentication()) {
          await _sendClockInToDB(tagStampInfo);
        }
      }
    }

    if (record == null) {
      print('No cached NDEF message found');
      return;
    }
  }

  TagStampModel _getNfcTagInfo(String uri) {
    TagStampModel tagStampInfo = TagStampModel.empty;
    if (uri.startsWith('geo:')) {
      var geoParts = uri.substring(4).split('?');
      if (geoParts.length > 1 && geoParts[1].startsWith('q=')) {
        var query = geoParts[1].substring(2);
        var queryParts = query.split('(');
        tagStampInfo = tagStampInfo.copyWith(
          coordinates: [
            double.parse(queryParts.first.split(',').first),
            double.parse(queryParts.first.split(',').last),
          ]
        );
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
    return await LocalAuthRepository.authenticate();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _sendClockInToDB(TagStampModel tagStampInfo) async {
    final devicePosition = await _determinePosition();
    final distance = Geolocator.distanceBetween(
        tagStampInfo.coordinates.first,
        tagStampInfo.coordinates.last,
        devicePosition.latitude,
        devicePosition.longitude);

    if (distance < toleranceMeter) {
      final allRight = await _tagStampRepository.addNewTagStamp(
        coordinates: tagStampInfo.coordinates,
        label: tagStampInfo.positionLabel,
      );
      print('ok, save > $allRight');
    } else {
      print('no');
    }
  }
}
