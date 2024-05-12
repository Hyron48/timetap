import 'package:flutter/material.dart';

import 'i_secure_storage_stub.dart'
  if (dart.library.io) 'package:timetap/repository/secure-storage/mobile_secure_storage_service.dart'
  if (dart.library.html) 'package:timetap/repository/secure-storage/web_secure_storage_service.dart';
import '../login_model.dart';

abstract class ISecureStorage {
  factory ISecureStorage() => getSecureStorage();

  Future<LoginModel> readLoginModel() async => LoginModel.empty;

  Future<bool> saveLoginModel({required LoginModel loginModel}) async => false;

  Future<bool> deleteLoginModel() async => false;

  Future<Locale?> getUserLocale() async => null;

  Future<String> getLanguage() async => 'ita';

  Future<bool> setDefaultLanguage({required Locale locale}) async => false;

  Future<bool> saveUserLocale({required String? locale}) async => false;
}
