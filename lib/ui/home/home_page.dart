import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:timetap/bloc/tag_stamp/tag_stamp_bloc.dart';
import 'package:timetap/repository/local_auth/local_auth_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timetap/repository/tag_stamp/tag_stamp_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: BlocListener<TagStampBloc, TagStampState>(
        listener: (BuildContext context, TagStampState state) {},
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () =>
                  BlocProvider.of<TagStampBloc>(context).add(ExecClockIn()),
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
      ),
    );
  }
}
