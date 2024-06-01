import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import '../models/auth/login_model.dart';
import '../models/interfaces/i_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/flavor_config.dart';

class CustomInterceptor implements InterceptorContract {
  ISecureStorage secureStorageService = ISecureStorage();
  final String contentType;

  CustomInterceptor({this.contentType = 'application/json'});

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers['Content-Type'] = contentType;

    LoginModel loginModel = await secureStorageService.readLoginModel();
    if (loginModel.isNotEmpty) {
      data.headers['Authorization'] = "Bearer ${loginModel.jwt}";
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      final client = http.Client();
      Uri uri =
          Uri.parse('${FlavorConfig.instance.values.appUrl}/refresh-token');

      LoginModel loginModel = await secureStorageService.readLoginModel();

      var response = await client.post(
        uri,
        body: jsonEncode({
          'refreshToken': loginModel.refreshToken,
        }),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        final validLoginModel = LoginModel(
            jwt: responseBody['jwt'],
            refreshToken: loginModel.refreshToken,
            userPermissions: loginModel.userPermissions,
            email: loginModel.email,
            password: loginModel.password);

        await secureStorageService.saveLoginModel(loginModel: validLoginModel);

        final dynamic cloneReq = data.request;
        final newHeaders = Map<String, String>.from(cloneReq.headers);
        newHeaders['Authorization'] = 'Bearer ${validLoginModel.jwt}';

        final clonedRequest = cloneReq.copyWith(headers: newHeaders);

        final newResponse = await client.send(clonedRequest);

        if (newResponse.statusCode == 200) {
          return ResponseData.fromHttpResponse(newResponse as http.Response);
        } else {
          return Future.error(
              'Errore dopo il tentativo di refresh: ${newResponse.statusCode}');
        }
      } else {
        await secureStorageService.deleteLoginModel();
        return Future.error('Errore di refresh token: ${response.statusCode}');
      }
    }
    return data;
  }
}
