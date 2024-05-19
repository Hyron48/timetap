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

  @JsonKey(name: 'email', includeIfNull: false, required: false)
  final String email;

  @JsonKey(name: 'password', includeIfNull: false, required: false)
  final String password;

  @JsonKey(name: 'isLogged', includeIfNull: false, required: false)
  final bool isLogged;

  @JsonKey(name: 'rememberMe', includeIfNull: false, required: false)
  final bool rememberMe;

  const LoginModel({
    required this.jwt,
    required this.refreshToken,
    required this.userPermissions,
    this.email = '',
    this.password = '',
    this.isLogged = false,
    this.rememberMe = false,
  });

  static const empty = LoginModel(
    jwt: '',
    refreshToken: '',
    userPermissions: [],
    email: '',
    password: '',
    isLogged: false,
    rememberMe: false,
  );

  LoginModel copyWith({String? email, String? password, bool? rememberMe, bool? isLogged}) =>
      LoginModel(
        email: email ?? this.email,
        password: password ?? this.password,
        rememberMe: rememberMe ?? this.rememberMe,
        isLogged: isLogged ?? this.isLogged,
        jwt: this.jwt,
        refreshToken: this.refreshToken,
        userPermissions: this.userPermissions,
      );

  bool get isEmpty => this == LoginModel.empty;

  bool get isNotEmpty => this != LoginModel.empty;

  @override
  List<Object?> get props => [
        email,
        password,
        isLogged,
        jwt,
        refreshToken,
        userPermissions,
        rememberMe
      ];

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
