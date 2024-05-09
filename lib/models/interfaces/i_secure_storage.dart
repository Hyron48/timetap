import 'package:flutter/material.dart';

import '../login_model.dart';
import 'i_secure_storage_stub.dart';

abstract class ISecureStorage {

	factory ISecureStorage() => getSecureStorage();

	Future<LoginModel> readLoginModel() async => LoginModel.empty;

	Future<bool> saveLoginModel({required LoginModel loginModel}) async => false;

	Future<bool> deleteLoginModel() async => false;

	Future<Locale?> getUserLocale() async => null;

	Future<String>  getLanguage() async => 'ita';

	Future<bool> saveUserLocale({required String? locale}) async => false;
}