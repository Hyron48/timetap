import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/bloc/auth/auth_bloc.dart';
import 'package:timetap/repository/auth/auth_repository.dart';
import 'package:timetap/repository/tag_stamp/tag_stamp_repository.dart';
import 'package:timetap/utils/constants.dart';
import 'package:timetap/utils/flavor_config.dart';
import 'package:timetap/utils/routes.dart';
import 'bloc/locale_cubit.dart';
import 'bloc/observer.dart';
import 'bloc/tag_stamp/tag_stamp_bloc.dart';
import 'models/interfaces/i_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.dev,
    color: Color(0xFF6E6E6E),
    values: const FlavorValues(
      appUrl: 'https://timetap-be-c63ba43413d7.herokuapp.com',
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final AuthRepository authRepository = AuthRepository();
  await authRepository.loadCurrentLoginModel();

  Bloc.observer = Observer();

  runApp(
    RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              authRepository: authRepository,
            ),
          ),
          BlocProvider<LocaleCubit>(
            create: (_) => LocaleCubit(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      buildWhen: (currentLocale, newLocale) =>
      newLocale.languageCode !=
          AppLocalizations.of(context)?.localeName,
      builder: (BuildContext contextLocale, Locale locale) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: AppBarTheme(
              backgroundColor: backgroundColor,
            ),
            drawerTheme: DrawerThemeData(
              backgroundColor: backgroundColor,
            ),
          ),
          locale: locale,
          onGenerateRoute: (RouteSettings settings) => Routes.generateRoute(
            settings,
            context.read<AuthBloc>().isUserAlreadyLogged(),
          ),
        );
      },
    );
  }
}
