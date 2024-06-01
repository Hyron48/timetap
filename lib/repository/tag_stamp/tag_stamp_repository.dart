import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:timetap/models/tag-stamp/tag_stamp_model.dart';

import '../../http/custom_interceptors.dart';
import '../../utils/custom_exception.dart';
import '../../utils/flavor_config.dart';

class TagStampRepository {
  static late http.Client client;

  TagStampRepository() {
    client = InterceptedClient.build(interceptors: [CustomInterceptor()]);
  }

  Future<bool> addNewTagStamp({
    required List<double> coordinates,
    required String label,
  }) async {
    Uri uri = Uri.parse('${FlavorConfig.instance.values.appUrl}/tag-stamp');

    try {
      var response = await client.post(
        uri,
        body: jsonEncode({
            'positionLabel': label,
            'coordinates': coordinates,
          }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final tagStamp = TagStampModel.fromJson(responseBody);
      return tagStamp.id != '';
    } on SocketException catch (ex) {
      throw CustomException(
        statusCode: 0,
        message: ex.toString(),
      );
    }
  }
}
