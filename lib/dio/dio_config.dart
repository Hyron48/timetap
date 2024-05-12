import 'package:dio/dio.dart';

import 'custom_interceptors.dart';

class DioConfig {
	static DioConfig? _singletonHttp;
	late Dio _dio;

	get dio => _dio;

	factory DioConfig() {
		_singletonHttp ??= DioConfig._singleton();
		return _singletonHttp!;
	}

	DioConfig._singleton() {
		_dio = Dio();
		_dio.interceptors.add(CheckConnectionInterceptor());
		_dio.interceptors.add(CustomInterceptor());
	}

	dispose() {
		_dio.interceptors.clear();
		_dio.close();
	}
}