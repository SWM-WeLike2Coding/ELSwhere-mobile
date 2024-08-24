// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLoginDto _$ResponseLoginDtoFromJson(Map<String, dynamic> json) =>
    ResponseLoginDto(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$ResponseLoginDtoToJson(ResponseLoginDto instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
