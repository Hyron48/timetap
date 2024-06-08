import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/utils/routes.dart';

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({super.key});

  void logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutEvent());
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, BaseAuthState>(
    listener: (BuildContext context, BaseAuthState authState) {
      if (authState is UnauthenticatedAuthState) {
        Navigator.of(context).pushReplacementNamed(Routes.initialRoute);
      }
    },
    child: Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.home_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      AppLocalizations.of(context)?.menuHome ?? 'Not Found',
                    ),
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(Routes.initialRoute),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.list,
                      color: Colors.black,
                    ),
                    title: Text(
                      AppLocalizations.of(context)?.menuHistory ?? 'Not Found',
                    ),
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(Routes.tagHistoryRoute),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50.0),
            child: ElevatedButton(
              onPressed: () => logout(context),
              child: Text(AppLocalizations.of(context)?.menuLogout ?? 'Not Found'),
            ),
          ),
        ],
      ),
    ),
  );
}
