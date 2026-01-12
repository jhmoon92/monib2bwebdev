// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLogin _$UserLoginFromJson(Map<String, dynamic> json) => UserLogin(
  json['token_type'] as String,
  json['access_token'] as String,
  (json['expires_in'] as num).toInt(),
);

Map<String, dynamic> _$UserLoginToJson(UserLogin instance) => <String, dynamic>{
  'token_type': instance.token_type,
  'access_token': instance.access_token,
  'expires_in': instance.expires_in,
};
