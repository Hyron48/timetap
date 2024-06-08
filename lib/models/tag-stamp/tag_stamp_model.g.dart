// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_stamp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagStampModel _$TagStampModelFromJson(Map<String, dynamic> json) =>
    TagStampModel(
      id: json['id'] as String,
      positionLabel: json['positionLabel'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      timeCode: json['timeCode'] == null
          ? null
          : DateTime.parse(json['timeCode'] as String),
    );

Map<String, dynamic> _$TagStampModelToJson(TagStampModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'positionLabel': instance.positionLabel,
    'coordinates': instance.coordinates,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('timeCode', instance.timeCode?.toIso8601String());
  return val;
}
