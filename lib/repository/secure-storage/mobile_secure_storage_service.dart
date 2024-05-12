import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:winoo/interface/i_secure_storage.dart';
import 'package:winoo/model/login_model.dart';

ISecureStorage getSecureStorage() => MobileSecureStorageService();

class MobileSecureStorageService implements ISecureStorage {
	final String _loginModel = 'loginModel';
	final String _selectedLocate = 'selected_locale';

	FlutterSecureStorage storage = const FlutterSecureStorage();

	@override
	Future<LoginModel> readLoginModel() async {
		try {
			dynamic loginData = await storage.read(key: _loginModel);
			return loginData == null ? LoginModel.empty : LoginModel.fromJson(jsonDecode(loginData));
		} on PlatformException catch (ex) {
			throw PlatformException(code: ex.code, message: ex.message);
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
	Future<bool> saveUserLocale({required String? locale}) async {
		try{
			await storage.write(key: _selectedLocate, value: locale ?? 'en');
			return true;
		} on PlatformException catch (ex) {
			throw PlatformException(code: ex.code, message: ex.message);
		}

	}

  @override
  Future<String> getLanguage() async {
		try{
			String? languageCode = await storage.read(key: _selectedLocate);
			switch (languageCode){
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
		} on PlatformException catch (ex) {
			throw PlatformException(code: ex.code, message: ex.message);
		}
  }
}