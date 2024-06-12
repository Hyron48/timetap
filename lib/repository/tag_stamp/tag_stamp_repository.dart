import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:timetap/models/tag-stamp/tag_stamp_model.dart';

import '../../http/custom_interceptors.dart';
import '../../utils/custom_exception.dart';
import '../../utils/flavor_config.dart';

class TagStampRepository {
  static late http.Client client;

  TagStampRepository() {
    client = InterceptedClient.build(
        interceptors: [CustomInterceptor()],
        retryPolicy: ExpiredTokenRetryPolicy());
  }

  Future<void> addNewTagStamp({
    required List<double> coordinates,
    required String label,
  }) async {
    Uri uri = Uri.parse('${FlavorConfig.instance.values.appUrl}/tag-stamp');

    try {
      await client.post(
        uri,
        body: jsonEncode({
          'positionLabel': label.replaceAll('+', ' '),
          'coordinates': coordinates,
        }),
      );
    } catch (ex) {
      throw CustomException(
        statusCode: 0,
        message: ex.toString(),
      );
    }
  }

  Future<List<TagStampModel>> getAllTagStamp() async {
    Uri uri = Uri.parse('${FlavorConfig.instance.values.appUrl}/tag-history');

    try {
      var response = await client.get(uri);
      final List<dynamic> responseBody = jsonDecode(response.body);
      final List<TagStampModel> parsedList = responseBody
          .map((tagStamp) => TagStampModel.fromJson(tagStamp))
          .toList();
      return parsedList;
    } catch (ex) {
      throw CustomException(
        statusCode: 0,
        message: ex.toString(),
      );
    }
  }
}
