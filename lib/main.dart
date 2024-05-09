import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';
import 'package:timetap/repository/auth_repository.dart';
import 'package:timetap/ui/login_page.dart';
import 'package:timetap/utils/flavor_config.dart';
import 'package:timetap/utils/routes.dart';
import 'bloc/locale_cubit.dart';
import 'models/interfaces/i_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.dev,
    color: Color(0xFF6E6E6E),
    values: const FlavorValues(
      appUrl: '',
      apiVersion: '/api/v1',
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? userLocale;

  @override
  void initState() {
    super.initState();
  }

  Future<void> localization() async {
    userLocale = await ISecureStorage().getUserLocale();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      buildWhen: (currentLocale, newLocale) => newLocale.languageCode != AppLocalizations.of(context)?.localeName,
      builder: (BuildContext contextLocale, Locale locale) {
        localization();
        return BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (AuthState current, AuthState next) => current.authStatus != next.authStatus,
          builder: (BuildContext contextProfile, AuthState authState) {
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.light,
              locale: userLocale ?? locale,
              onGenerateRoute: (RouteSettings settings) => Routes.generateRoute(settings, contextProfile.read<AuthRepository>()),
            );
          },
        );
      },
    );
  }
}
