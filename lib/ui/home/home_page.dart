import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OK'),
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
