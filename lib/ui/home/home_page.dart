import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';
import 'package:timetap/repository/local_auth/local_auth_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> showNfcDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lettura NFC'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Avvicina il telefono all\'NFC.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> triggerNfcAndGeoLocalization(BuildContext context) async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      return;
    }

    showNfcDialog(context);

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        if (ndef == null) {
          print('No NDEF data found on tag');
          return;
        }
        final cachedMessage = ndef.cachedMessage;
        if (cachedMessage == null) {
          print('No cached NDEF message found');
          return;
        }

        for (var record in cachedMessage.records) {
          if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
            if (String.fromCharCodes(record.type) == 'U') {
              var payload = record.payload;
              var uri = String.fromCharCodes(payload.sublist(1));
              if (uri.startsWith('geo:')) {
                var geoParts = uri.substring(4).split('?');
                var coordinates = geoParts[0];
                var description = '';
                if (geoParts.length > 1 && geoParts[1].startsWith('q=')) {
                  var query = geoParts[1].substring(2);
                  var queryParts = query.split('(');
                  coordinates = queryParts[0];
                  if (queryParts.length > 1) {
                    description = queryParts[1].replaceFirst(')', '');
                  }
                }

                print('Coordinates: $coordinates');
                print('Description: $description');

                final authenticated = await LocalAuthRepository.authenticate();

                if (authenticated) {
                  
                }
              }
            }
          }
        }

        NfcManager.instance.stopSession();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => triggerNfcAndGeoLocalization(context),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/add_clock_in.svg',
                width: (MediaQuery.of(context).size.width / 2.4),
                height: (MediaQuery.of(context).size.height / 2.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
