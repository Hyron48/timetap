import 'dart:convert';

import 'package:flutter/services.dart';

class BackendLocalizations {

  BackendLocalizations({required this.languageCode}) {
    load();
  }

  final String languageCode;
  static late Map<String, String> _localizedStrings;

  Future<void> load() async {
    String jsonString = await rootBundle.loadString('lib/l10n/backend/backend_$languageCode.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String translate(String key) {
    if (_localizedStrings[key] != null && _localizedStrings[key]!.isNotEmpty) {
      return _localizedStrings[key]!;
    } else {
      return _localizedStrings['genericError']!;
    }
  }
}