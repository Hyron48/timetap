import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/interfaces/i_secure_storage.dart';
import '../../models/auth/login_model.dart';

ISecureStorage getSecureStorage() => MobileSecureStorageService();

class MobileSecureStorageService implements ISecureStorage {
  final String _loginModel = 'login_model';
  final String _selectedLocate = 'selected_locale';

  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<LoginModel> readLoginModel() async {
    try {
      dynamic loginData = await storage.read(key: _loginModel) ?? '';
      return loginData == null
          ? LoginModel.empty
          : LoginModel.fromJson(jsonDecode(loginData));
    } on PlatformException catch (ex) {
      return LoginModel.empty;
    }
  }

  @override
  Future<bool> saveLoginModel({required LoginModel loginModel}) async {
    try {
      await storage.write(key: _loginModel, value: jsonEncode(loginModel));
      return true;
    } on PlatformException catch (ex) {
      throw PlatformException(code: ex.code, message: ex.message);
    }
  }

  @override
  Future<bool> deleteLoginModel() async {
    try {
      print('before destroy <  ${await storage.read(key: _loginModel)}');
      await storage.delete(key: _loginModel);
      return true;
    } on PlatformException catch (ex) {
      throw PlatformException(code: ex.code, message: ex.message);
    }
  }

  @override
  Future<Locale?> getUserLocale() async {
    try {
      String? userLocale = await storage.read(key: _selectedLocate);
      return userLocale == null ? null : Locale(userLocale);
    } on PlatformException catch (ex) {
      throw PlatformException(code: ex.code, message: ex.message);
    }
  }

  @override
  Future<bool> setDefaultLanguage({required Locale locale}) async {
    try {
      await storage.read(key: _selectedLocate);
      return true;
    } on PlatformException catch (ex) {
      return saveUserLocale(locale: locale.languageCode);
    }
  }

  @override
  Future<bool> saveUserLocale({required String? locale}) async {
    try {
      await storage.write(key: _selectedLocate, value: locale ?? 'it');
      return true;
    } on PlatformException catch (ex) {
      throw PlatformException(code: ex.code, message: ex.message);
    }
  }

  @override
  Future<String> getLanguage() async {
    try {
      String? languageCode = await storage.read(key: _selectedLocate);
      switch (languageCode) {
        case 'en':
          return 'eng';
        case 'it':
          return 'ita';
        default:
          return 'ita';
      }
    } on PlatformException catch (ex) {
      throw PlatformException(code: ex.code, message: ex.message);
    }
  }
}
