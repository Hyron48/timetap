import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetap/main.dart';

const String prefSelectedLanguageCode = "language";

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(prefSelectedLanguageCode) ?? 'it';
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : const Locale('it', '');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var locale = await setLocale(selectedLanguageCode);
  TimeTapApp.setLocale(context, locale);
}