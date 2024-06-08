import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../http/custom_interceptors.dart';
import '../models/interfaces/i_secure_storage.dart';
import '../models/auth/login_model.dart';
import '../utils/custom_exception.dart';
import '../utils/flavor_config.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  static late LoginModel _loginModel;
  final ISecureStorage secureStorage = ISecureStorage();
  late http.Client client;

  LoginModel get currentLoginModel => _loginModel;

  AuthRepository() {
    client = InterceptedClient.build(interceptors: [CustomInterceptor()]);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    Uri uri = Uri.parse('${FlavorConfig.instance.values.appUrl}/login');

    try {
      var response = await client.post(
        uri,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _loginModel = LoginModel.fromJson(responseBody);

      _loginModel = _loginModel.copyWith(
        email: email,
        password: password,
      );

      await saveAuthInfoOnSecureStorage();
    } catch (ex) {
      throw CustomException(
        statusCode: 0,
        message: ex.toString(),
      );
    }
  }

  Future<void> loadCurrentLoginModel() async {
    try {
      _loginModel = await ISecureStorage().readLoginModel();
    } on PlatformException {
      _loginModel = LoginModel.empty;
    }
  }

  Future<void> saveAuthInfoOnSecureStorage() async {
    try {
      await secureStorage.saveLoginModel(loginModel: _loginModel);
    } catch (ex) {
      throw CustomException(
        statusCode: 0,
        message: ex.toString(),
      );
    }
  }

  Future<void> logout() async {
    await secureStorage.deleteLoginModel();
    _loginModel = LoginModel.empty;
  }
}
