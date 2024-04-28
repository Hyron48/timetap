import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timetap/localization/delegation.dart';
import 'localization/constant.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const TimeTapApp());
}

class TimeTapApp extends StatefulWidget {
  const TimeTapApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<TimeTapState>();
    state?.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => TimeTapState();
}

class TimeTapState extends State<TimeTapApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeTap',
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('it', ''),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: LoginPage(),
    );
  }
}
