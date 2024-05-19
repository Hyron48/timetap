import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginModel extends Equatable {
  @JsonKey(name: 'jwt', includeIfNull: false)
  final String jwt;

  @JsonKey(name: 'refreshToken', includeIfNull: false)
  final String refreshToken;

  @JsonKey(name: 'userPermissions', includeIfNull: false)
  final List<String> userPermissions;

  @JsonKey(name: 'userPermissions', includeIfNull: false, required: false)
  final String email;

  const LoginModel({
    required this.jwt,
    required this.refreshToken,
    required this.userPermissions,
  });

  static const empty = LoginModel(
    jwt: '',
    refreshToken: '',
    userPermissions: [],
  );

  LoginModel copyWith(
          {String? jwt, String? refreshToken, List<String>? userPermissions}) =>
      LoginModel(
        jwt: jwt ?? this.jwt,
        refreshToken: refreshToken ?? this.refreshToken,
        userPermissions: userPermissions ?? this.userPermissions,
      );

  bool get isEmpty => this == LoginModel.empty;

  bool get isNotEmpty => this != LoginModel.empty;

  @override
  List<Object?> get props => [jwt, refreshToken, userPermissions];

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
