import 'package:flutter/material.dart';

enum Flavor { dev, staging }

String getFlavorName({required Flavor flavor}) {
  String flavorName;

  switch (flavor) {
    case Flavor.dev:
      flavorName = 'dev';
      break;
    case Flavor.staging:
      flavorName = 'staging';
      break;
    default:
      flavorName = 'no flavor';
      break;
  }
  return flavorName;
}

class FlavorValues {
  const FlavorValues({required this.appUrl, this.apiVersion = '/api/v1'});

  final String appUrl;
  final String apiVersion;
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig(
      {required Flavor flavor,
      color = Colors.blue,
      required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(
        flavor, getFlavorName(flavor: flavor), color, values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);

  static FlavorConfig get instance => _instance!;

  static bool isDevelopment() => _instance?.flavor == Flavor.dev;

  static bool isStaging() => _instance?.flavor == Flavor.staging;
}
