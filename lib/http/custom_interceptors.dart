import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:timetap/utils/enum.dart';
import '../models/interfaces/i_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/flavor_config.dart';

const Map<ContentType, String> contentTypeMap = {
	ContentType.applicationJson: "application/json",
	ContentType.multipart: "multipart/form-data",
};

class CustomInterceptor {
	ISecureStorage secureStorageService = ISecureStorage();

	final String? _contentType;

	CustomInterceptor({ContentType? contentType}) : _contentType = contentTypeMap[contentType ?? ContentType.applicationJson];

	Future<http.Request> intercept(http.BaseRequest request) async {
		debugPrint('interceptor');
		return request as http.Request;
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