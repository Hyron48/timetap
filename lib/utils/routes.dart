import 'package:flutter/material.dart';
import 'package:timetap/ui/home/home_page.dart';
import '../ui/auth/login_page.dart';

class Routes {
  static const String initialRoute = '/';
  static const String homeRoute = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings, bool isUserAuthorized) {
    Widget page;

    switch (settings.name) {
      case initialRoute:
      default:
        page = isUserAuthorized ? HomePage() : LoginPage();
        break;
    }

    // Return a MaterialPageRoute with the selected page
    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings, // Pass the original settings to the route
    );
  }
}
