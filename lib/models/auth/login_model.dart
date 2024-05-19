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

  const LoginModel({
    required this.jwt,
    required this.refreshToken,
    required this.userPermissions,
    this.email = '',
    this.password = '',
  });

  static const empty = LoginModel(
    jwt: '',
    refreshToken: '',
    userPermissions: [],
    email: '',
    password: '',
  );

  LoginModel copyWith({String? email, String? password, bool? isLogged}) =>
      LoginModel(
        email: email ?? this.email,
        password: password ?? this.password,
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
        jwt,
        refreshToken,
        userPermissions,
      ];

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
