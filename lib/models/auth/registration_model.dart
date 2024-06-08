import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registration_model.g.dart';

@JsonSerializable(includeIfNull: false)
class RegistrationModel extends Equatable {
  @JsonKey(name: 'firstName', includeIfNull: false)
  final String firstName;
  @JsonKey(name: 'lastName', includeIfNull: false)
  final String lastName;
  @JsonKey(name: 'email', includeIfNull: false)
  final String email;
  @JsonKey(name: 'password', includeIfNull: false)
  final String password;

  RegistrationModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() => _$RegistrationModelToJson(this);
}
