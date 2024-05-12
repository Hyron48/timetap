import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../bloc/auth/auth_bloc.dart';
import '../dio/dio_config.dart';
import '../models/interfaces/i_secure_storage.dart';
import '../models/login_model.dart';
import '../utils/custom_exception.dart';
import '../utils/flavor_config.dart';

class AuthRepository {
  static final Dio _dio = DioConfig().dio;
  static late LoginModel _loginModel;
  static final StreamController<AuthState> authStateStreamController =
      StreamController<AuthState>();
  final ISecureStorage secureStorage = ISecureStorage();

  LoginModel get currentLoginModel => _loginModel;

  AuthRepository();

  Future<void> login(
      {required String email,
      required String password,
      required bool rememberMeSwitch}) async {
    Uri uri = Uri.https(FlavorConfig.instance.values.appUrl,
        "${FlavorConfig.instance.values.apiVersion}/login");

    try {
      Response<Map<String, dynamic>> response = await _dio.postUri(
        uri,
        data: {
          'login': email,
          'password': password,
        },
      );

      _loginModel = LoginModel.fromJson(response.data!);

      _loginModel = _loginModel.copyWith(
        email: email,
        password: password,
        rememberMeSwitch: rememberMeSwitch,
        isLogged: true,
      );

      authStateStreamController.add(AuthState.authenticated(_loginModel));

      // await _saveAuthInfoOnSecureStorage(loginModel: _loginModel);
    } on SocketException catch (ex) {
      throw CustomException(
        statusCode: 0,
        message: ex.toString(),
      );
    } on DioException catch (ex) {}
  }

  Future<void> loadCurrentLoginModel() async {
    try {
      _loginModel = await ISecureStorage().readLoginModel();
    } on PlatformException {
      _loginModel = LoginModel.empty;
    }
  }

  Stream<AuthState> get authStateStream {
    return authStateStreamController.stream;
  }
}
