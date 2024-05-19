import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> triggerNfcAndGeoLocalization() async {
    print('trigger');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OK'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: triggerNfcAndGeoLocalization,
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
    return Column(
      children: [
        const Text('Home'),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
            },
            child: Text('Logout'))
      ],
    );
  }
}
