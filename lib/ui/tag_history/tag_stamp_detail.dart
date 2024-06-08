import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:timetap/models/tag-stamp/address_model.dart';
import 'package:timetap/ui/shared/generic_info_row.dart';
import 'package:timetap/utils/constants.dart';
import '../../models/tag-stamp/tag_stamp_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TagStampDetail extends StatefulWidget {
  final TagStampModel tagStamp;

  const TagStampDetail({
    super.key,
    required this.tagStamp,
  });

  @override
  TagStampDetailState createState() => TagStampDetailState();
}

class TagStampDetailState extends State<TagStampDetail> {
  late AddressModel address;
  bool isLoadedAddress = false;

  @override
  void initState() {
    super.initState();
    _getAddressFromCoordinates();
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      double latitude = widget.tagStamp.coordinates[0];
      double longitude = widget.tagStamp.coordinates[1];

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          var city = place.locality ?? '';
          if (place.postalCode != null) {
            city += ', ${place.postalCode}';
          }
          address = AddressModel(
            street: place.street ?? '',
            city: city,
            county: place.administrativeArea ?? '',
            country: place.country ?? '',
          );
          isLoadedAddress = true;
        });
      } else {
        setState(() {
          isLoadedAddress = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoadedAddress = true;
      });
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime parsedDate = DateTime.parse(dateTimeString);

    DateTime localDate = parsedDate.toLocal();

    DateFormat formatter = DateFormat('dd-MM-yy HH:mm:ss');
    return formatter.format(localDate);
  }

  List<Widget> getTagInfoRows(BuildContext context) {
    if (!isLoadedAddress) {
      return [];
    }

    List<Widget> listToView = [
      GenericInfoRow(
        label: AppLocalizations.of(context)?.tagDetailTimeLabel ?? 'Not Found',
        value: formatDateTime(widget.tagStamp.timeCode.toString()),
      ),
    ];

    if (isLoadedAddress && address.isEmpty) {
      listToView.add(
        GenericInfoRow(
          label: AppLocalizations.of(context)?.tagDetailCoords ?? 'Not Found',
          value: widget.tagStamp.coordinates.toString(),
        ),
      );
    } else {
      listToView.addAll([
        GenericInfoRow(
          label: AppLocalizations.of(context)?.tagDetailAddress ?? 'Not Found',
          value: address.street,
        ),
        GenericInfoRow(
          label: AppLocalizations.of(context)?.tagDetailCity ?? 'Not Found',
          value: address.city,
        ),
        GenericInfoRow(
          label: AppLocalizations.of(context)?.tagDetailCounty ?? 'Not Found',
          value: address.county,
        ),
        GenericInfoRow(
          label: AppLocalizations.of(context)?.tagDetailCountry ?? 'Not Found',
          value: address.country,
        ),
      ]);
    }

    return listToView;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.tagStamp.id,
          child: Text(
            widget.tagStamp.positionLabel,
            style: TextStyle(color: black),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: getTagInfoRows(context),
        ),
      ),
    );
  }
}
