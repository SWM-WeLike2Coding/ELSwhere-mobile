// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLoginDto _$ResponseLoginDtoFromJson(Map<String, dynamic> json) =>
    ResponseLoginDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$ResponseLoginDtoToJson(ResponseLoginDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
