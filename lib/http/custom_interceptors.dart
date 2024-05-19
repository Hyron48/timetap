import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:timetap/utils/enum.dart';
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
		return data;
	}

	@override
	Future<ResponseData> interceptResponse({required ResponseData data}) async {
		return data;
	}
}

class DefaultInterceptor {
	Future<http.Response> intercept(http.Response response) async {
		if (kDebugMode) print('RESPONSE[${response.statusCode}] =>  ${DateTime.now()} PATH: ${response.request?.url} | DATA => ${response.body}');
		return response;
	}
}

class CheckConnectionInterceptor {
	Future<http.Request> intercept(http.BaseRequest request) async {
		try {
			final result = await InternetAddress.lookup(FlavorConfig.instance.values.appUrl);
			if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
				return request as http.Request;
			}
		} on SocketException catch (ex) {
			throw http.ClientException(ex.message);
		}
		return request as http.Request;
	}
}