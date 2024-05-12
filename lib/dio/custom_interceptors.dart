import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:timetap/utils/enum.dart';
import '../models/interfaces/i_secure_storage.dart';
import '../models/login_model.dart';
import '../utils/flavor_config.dart';

const Map<ContentType, String> contentTypeMap = {
	ContentType.applicationJson: "application/json; charset=utf-8",
	ContentType.multipart: "multipart/form-data",
};

class CustomInterceptor extends DefaultInterceptor {
	ISecureStorage secureStorageService = ISecureStorage();

	final String? _contentType;

	CustomInterceptor({
		ContentType? contentType
	}) : _contentType = contentTypeMap[contentType ?? ContentType.applicationJson];

	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

		LoginModel loginModel = await secureStorageService.readLoginModel();

		if (loginModel.isNotEmpty) {
			options.headers = {
				"Content-type": _contentType,
				"Authorization": "Bearer ${loginModel.accessToken}",
				"Accept-Language": 'ita'
			};
		}
		return super.onRequest(options, handler);
	}
}

class DefaultInterceptor extends Interceptor {
	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
		if (kDebugMode) print('REQUEST[${options.method}] =>  ${DateTime.now()} PATH: ${options.path} | DATA => ${options.data} | JWT => ${options.headers}');
		return super.onRequest(options, handler);
	}

	@override
	void onResponse(Response response, ResponseInterceptorHandler handler) {
		if (kDebugMode) print('RESPONSE[${response.statusCode}] =>  ${DateTime.now()} PATH: ${response.requestOptions.path} | DATA => ${response.data}');
		super.onResponse(response, handler);
		return;
	}

	@override
	void onError(DioError err, ErrorInterceptorHandler handler) async {
		if (kDebugMode) print('ERROR[${err.response?.statusCode}] => ${DateTime.now()}  PATH: ${err.requestOptions.path} | SEND_DATA => ${err.requestOptions.data} | RECEIVED_DATA => ${err.response?.data}');
		return super.onError(err, handler);
	}
}

class CheckConnectionInterceptor extends Interceptor {
	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
		try {
			final result = await InternetAddress.lookup(FlavorConfig.instance.values.appUrl);
			if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
				return super.onRequest(options, handler);
			}
		} on SocketException catch (ex) {
			RequestOptions requestOptions = RequestOptions(path: options.path);
			DioError customError = DioError(requestOptions: requestOptions, error: ex.message);
			handler.reject(customError);
		}
	}
}