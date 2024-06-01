import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_stamp_model.g.dart';

@JsonSerializable(includeIfNull: false)
class TagStampModel extends Equatable {
  @JsonKey(name: 'id', includeIfNull: false)
  final String id;

  @JsonKey(name: 'positionLabel', includeIfNull: false)
  final String positionLabel;

  @JsonKey(name: 'coordinates', includeIfNull: false)
  final List<double> coordinates;

  @JsonKey(name: 'timeCode', includeIfNull: false)
  final DateTime? timeCode;

  const TagStampModel({
    required this.id,
    required this.positionLabel,
    required this.coordinates,
    required this.timeCode,
  });

  static const empty = TagStampModel(
    id: '',
    positionLabel: '',
    coordinates: [],
    timeCode: null,
  );

  TagStampModel copyWith({
    String? id,
    String? positionLabel,
    List<double>? coordinates,
    DateTime? timeCode,
  }) {
    return TagStampModel(
      id: id ?? this.id,
      positionLabel: positionLabel ?? this.positionLabel,
      coordinates: coordinates ?? this.coordinates,
      timeCode: timeCode ?? this.timeCode,
    );
  }

  @override
  List<Object?> get props => [
        id,
        positionLabel,
        coordinates,
        timeCode,
      ];

  factory TagStampModel.fromJson(Map<String, dynamic> json) =>
      _$TagStampModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagStampModelToJson(this);
}
