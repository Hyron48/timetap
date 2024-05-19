import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui';

import '../../models/interfaces/i_secure_storage.dart';
import '../../models/auth/login_model.dart';

ISecureStorage getSecureStorage() => WebSecureStorageService();

class WebSecureStorageService implements ISecureStorage {
  final String _loginData = 'loginData';
  final String _selectedLocate = 'selected_locale';

  html.Storage webStorage = html.window.localStorage;

  @override
  Future<LoginModel> readLoginModel() async {
    return webStorage[_loginData] == null
        ? LoginModel.empty
        : LoginModel.fromJson(jsonDecode(webStorage[_loginData]!));
  }

  @override
  Future<bool> saveLoginModel({required LoginModel loginModel}) async {
    webStorage[_loginData] = jsonEncode(loginModel);
    return true;
  }

  @override
  Future<bool> deleteLoginModel() async {
    webStorage.remove(_loginData);
    return true;
  }

  @override
  Future<Locale?> getUserLocale() async {
    String? userLocale = webStorage[_selectedLocate];
    return userLocale == null ? null : Locale(userLocale);
  }

  @override
  Future<bool> setDefaultLanguage({required Locale locale}) async {
    String? languageCode = webStorage[_selectedLocate];
    if (languageCode == null) {
      return saveUserLocale(locale: locale.languageCode);
    }
    return true;
  }

  @override
  Future<bool> saveUserLocale({String? locale}) async {
    webStorage[_selectedLocate] = locale ?? 'en';
    return true;
  }

  @override
  Future<String> getLanguage() async {
    String? languageCode = webStorage[_selectedLocate];
    switch (languageCode) {
      case 'en':
        return 'eng';
      case 'it':
        return 'ita';
      case 'de':
        return 'deu';
      case 'fr':
        return 'fra';
      case 'ru':
        return 'rus';
      default:
        return 'ita';
    }
  }
}
