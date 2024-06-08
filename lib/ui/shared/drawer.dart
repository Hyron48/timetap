import 'package:flutter/material.dart';
import 'package:timetap/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/utils/routes.dart';

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.home_outlined,
                  color: black,
                ),
                title: Text(
                  AppLocalizations.of(context)?.menuHome ?? 'Not Found',
                ),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed('/'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.list,
                  color: black,
                ),
                title: Text(
                  AppLocalizations.of(context)?.menuHistory ?? 'Not Found',
                ),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed(Routes.tagHistoryRoute),
              )
            ],
          )));
}
