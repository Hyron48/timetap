import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import '../models/auth/login_model.dart';
import '../models/interfaces/i_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/flavor_config.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    ISecureStorage secureStorageService = ISecureStorage();
    if (response.statusCode == 401) {
      final client = http.Client();
      Uri uri =
      Uri.parse('${FlavorConfig.instance.values.appUrl}/refresh-token');

      LoginModel loginModel = await secureStorageService.readLoginModel();

      var response = await client.post(
        uri,
        body: jsonEncode({
          'refreshToken': loginModel.refreshToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final validLoginModel = LoginModel(
          jwt: responseBody['jwt'],
          refreshToken: loginModel.refreshToken,
          userPermissions: loginModel.userPermissions,
          email: loginModel.email,
          password: loginModel.password,
        );

        await secureStorageService.saveLoginModel(loginModel: validLoginModel);
        return true;
      }
    }
    return false;
  }
}

class CustomInterceptor implements InterceptorContract {
  ISecureStorage secureStorageService = ISecureStorage();
  final String contentType;

  CustomInterceptor({this.contentType = 'application/json'});

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers['Content-Type'] = contentType;

    LoginModel loginModel = await secureStorageService.readLoginModel();
    if (loginModel.isNotEmpty) {
      request.headers['Authorization'] = "Bearer ${loginModel.jwt}";
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() {
    return Future.value(true);
  }

  @override
  Future<bool> shouldInterceptResponse() {
    return Future.value(true);
  }
}