import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import '../models/auth/login_model.dart';
import '../models/interfaces/i_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/flavor_config.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
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
    return data;
  }
}
