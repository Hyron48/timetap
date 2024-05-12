import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginModel extends Equatable {
  @JsonKey(
      name: 'access_token',
      includeIfNull: false
  )
  final String accessToken;

  @JsonKey(
      name: 'created_at',
      includeIfNull: false
  )
  final int createdAt;

  @JsonKey(
      name: 'expires_in',
      includeIfNull: false
  )
  final int expiresIn;

  @JsonKey(
      name: 'refresh_token',
      includeIfNull: false
  )
  final String refreshToken;

  @JsonKey(
      name: 'token_type',
      includeIfNull: false
  )
  final String tokenType;

  @JsonKey(
      name: 'switchValue',
      required: false
  )
  final bool rememberMeSwitch;

  @JsonKey(
    name: 'email',
    required: false,
  )
  final String email;

  @JsonKey(
      name: 'password',
      required: false
  )
  final String password;

  @JsonKey(
      name: 'isLogged',
      required: false
  )
  final bool isLogged;

  const LoginModel({
    required this.accessToken,
    required this.createdAt,
    required this.expiresIn,
    required this.refreshToken,
    required this.tokenType,
    this.rememberMeSwitch = false,
    this.email = '',
    this.password = '',
    this.isLogged = false
  });

  static const empty = LoginModel(
      accessToken: '',
      createdAt: 0,
      expiresIn: 0,
      refreshToken: '',
      tokenType: '',
      rememberMeSwitch: false,
      email: '',
      password: '',
      isLogged: false
  );

  LoginModel copyWith({
    String? accessToken,
    int? createdAt,
    int? expiresIn,
    String? refreshToken,
    String? tokenType,
    bool? rememberMeSwitch,
    String? email,
    String? password,
    bool? isLogged
  }) => LoginModel(
    accessToken: accessToken ?? this.accessToken,
    createdAt: createdAt ?? this.createdAt,
    expiresIn: expiresIn ?? this.expiresIn,
    refreshToken: refreshToken ?? this.refreshToken,
    tokenType: tokenType ?? this.tokenType,
    rememberMeSwitch: rememberMeSwitch ?? this.rememberMeSwitch,
    email: email ?? this.email,
    password: password ?? this.password,
    isLogged: isLogged ?? this.isLogged,
  );

  bool get isEmpty => this == LoginModel.empty;

  bool get isNotEmpty => this != LoginModel.empty;

  @override
  List<Object?> get props => [
    accessToken,
    createdAt,
    expiresIn,
    refreshToken,
    tokenType,
    rememberMeSwitch,
    email,
    password,
    isLogged
  ];

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}