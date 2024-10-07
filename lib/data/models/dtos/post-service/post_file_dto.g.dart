// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFileDto _$PostFileDtoFromJson(Map<String, dynamic> json) => PostFileDto(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      originalName: json['originalName'] as String,
      mimeType: json['mimeType'] as String,
    );

Map<String, dynamic> _$PostFileDtoToJson(PostFileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'originalName': instance.originalName,
      'mimeType': instance.mimeType,
    };
