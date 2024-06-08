import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/bloc/tag_history/tag_history_cubit.dart';
import 'package:timetap/ui/home/home_page.dart';
import 'package:timetap/ui/tag_history/tag_stamp_detail.dart';
import 'package:timetap/ui/tag_history/tag_stamp_history.dart';
import '../bloc/tag_stamp/tag_stamp_bloc.dart';
import '../models/tag-stamp/tag_stamp_model.dart';
import '../repository/tag_stamp/tag_stamp_repository.dart';
import '../ui/auth/login_page.dart';

class Routes {
  static const String initialRoute = '/';
  static const String registerRoute = '/register';
  static const String tagHistoryRoute = '/tap_history';
  static const String tagStampDetailRoute = '/tap_history/detail';

  static Route<dynamic> generateRoute(
    RouteSettings settings,
    bool isUserAuthorized,
  ) {
    final tagStampRepository = TagStampRepository();
    Widget page;

    switch (settings.name) {
      case tagStampDetailRoute:
        final tagStamp = settings.arguments as TagStampModel;
        page = TagStampDetail(tagStamp: tagStamp);
      case tagHistoryRoute:
        page = BlocProvider<TagHistoryCubit>(
          create: (context) => TagHistoryCubit(
            tagStampRepository,
          ),
          child: TagStampHistory(),
        );
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
          page = LoginPage();
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
