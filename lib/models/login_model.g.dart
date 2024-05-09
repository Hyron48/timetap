// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
      accessToken: json['access_token'] as String,
      createdAt: (json['created_at'] as num).toInt(),
      expiresIn: (json['expires_in'] as num).toInt(),
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      rememberMeSwitch: json['switchValue'] as bool? ?? false,
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isLogged: json['isLogged'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'created_at': instance.createdAt,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'switchValue': instance.rememberMeSwitch,
      'email': instance.email,
      'password': instance.password,
      'isLogged': instance.isLogged,
    };
