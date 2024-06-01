import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/ui/home/home_page.dart';
import '../bloc/login/login_cubit.dart';
import '../bloc/tag_stamp/tag_stamp_bloc.dart';
import '../repository/auth_repository.dart';
import '../repository/tag_stamp/tag_stamp_repository.dart';
import '../ui/auth/login_page.dart';

class Routes {
  static const String initialRoute = '/';
  static const String homeRoute = '/tag_stamp';

  static Route<dynamic> generateRoute(
    RouteSettings settings,
    bool isUserAuthorized,
  ) {
    final tagStampRepository = TagStampRepository();
    Widget page;

    switch (settings.name) {
      case initialRoute:
      default:
        if (isUserAuthorized) {
          page = BlocProvider<TagStampBloc>(
            create: (context) => TagStampBloc(
              tagStampRepository: tagStampRepository,
            ),
            child: HomePage(),
          );
        } else {
          page = BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(context.read<AuthRepository>()),
            child: LoginPage(),
          );
        }
        break;
    }

    // Return a MaterialPageRoute with the selected page
    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings, // Pass the original settings to the route
    );
  }
}
