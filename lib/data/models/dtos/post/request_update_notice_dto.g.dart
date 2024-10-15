// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_update_notice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestUpdateNoticeDto _$RequestUpdateNoticeDtoFromJson(
        Map<String, dynamic> json) =>
    RequestUpdateNoticeDto(
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$RequestUpdateNoticeDtoToJson(
        RequestUpdateNoticeDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };
