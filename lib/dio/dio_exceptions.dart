import 'dart:developer';
import '../../utils/custom_exception.dart';
import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  final CustomException _customException = CustomException.empty;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        log("DioError: request is cancelled");
        _customException.message = "cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        log("DioError: url is opened timeout");
        break;
      case DioExceptionType.receiveTimeout:
        log("DioError: receiving timeout");
        break;
      case DioExceptionType.sendTimeout:
        log("DioError: the server response, but with a incorrect status, such as 404, 503...");
        _customException.message = "genericError";
        break;
      case DioExceptionType.unknown:
        log('dio error - no connection');
        _customException.message = "noConnection";
        break;
      default:
        log("dioError - case default");
        log("dioError - ${dioError.response}");
        _customException.message = "genericError";
        break;
    }
  }

  CustomException getCustomException() => _customException;
}