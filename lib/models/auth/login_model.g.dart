// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
      jwt: json['jwt'] as String,
      refreshToken: json['refreshToken'] as String,
      userPermissions: (json['userPermissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'refreshToken': instance.refreshToken,
      'userPermissions': instance.userPermissions,
      'email': instance.email,
      'password': instance.password,
    };
