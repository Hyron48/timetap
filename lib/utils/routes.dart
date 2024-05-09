import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import '../ui/login_page.dart';

class Routes {
  static const String initialRoute = '/';

  static Route<dynamic> generateRoute(RouteSettings settings, AuthRepository authRepository) {
    Widget page;

    switch (settings.name) {
      case initialRoute:
      default:
        page = LoginPage();
        break;
    }

    // Return a MaterialPageRoute with the selected page
    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings, // Pass the original settings to the route
    );
  }
}
