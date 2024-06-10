import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/utils/routes.dart';

import '../../utils/constants.dart';
import 'generic_info_row.dart';
import 'language_dropdown.dart';

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
    child: Container(
      width: MediaQuery.of(context).size.width / 1.5, // Restringe il drawer
      child: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 75.0, 0, 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/logo_only_text.svg',
                          width: MediaQuery.of(context).size.width / 35,
                          height: MediaQuery.of(context).size.height / 35,
                        ),
                        Spacer(),
                        LanguageDropdown(),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      AppLocalizations.of(context)?.email ?? 'Not Found',
                      style: TextStyle(color: darkGrey, fontSize: 13),
                    ),
                    Text(
                      context.read<AuthBloc>().getUserEmail(),
                      style: TextStyle(color: black, fontSize: 16),
                    ),
                    const SizedBox(height: 24.0),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.home_outlined,
                        color: bluePrimary,
                      ),
                      title: Text(
                        AppLocalizations.of(context)?.menuHome ?? 'Not Found',
                        style: TextStyle(fontWeight: lightFontWeight),
                      ),
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(Routes.initialRoute),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.list,
                        color: bluePrimary,
                      ),
                      title: Text(
                        AppLocalizations.of(context)?.menuHistory ?? 'Not Found',
                        style: TextStyle(fontWeight: lightFontWeight),
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
              child:  OutlinedButton(
                onPressed: () => logout(context),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: bluePrimary),
                    backgroundColor: white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                child: Text(
                  AppLocalizations.of(context)?.menuLogout ??
                      'Not Found',
                  style: TextStyle(color: bluePrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
