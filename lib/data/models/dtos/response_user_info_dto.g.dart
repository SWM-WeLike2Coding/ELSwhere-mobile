// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_user_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseUserInfoDto _$ResponseUserInfoDtoFromJson(Map<String, dynamic> json) =>
    ResponseUserInfoDto(
      socialType: json['socialType'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      admin: json['admin'] as bool,
    );

Map<String, dynamic> _$ResponseUserInfoDtoToJson(
        ResponseUserInfoDto instance) =>
    <String, dynamic>{
      'socialType': instance.socialType,
      'email': instance.email,
      'name': instance.name,
      'nickname': instance.nickname,
      'admin': instance.admin,
    };
