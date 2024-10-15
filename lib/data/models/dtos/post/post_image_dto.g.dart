// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostImageDto _$PostImageDtoFromJson(Map<String, dynamic> json) => PostImageDto(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      originalName: json['originalName'] as String,
      mimeType: json['mimeType'] as String,
    );

Map<String, dynamic> _$PostImageDtoToJson(PostImageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'originalName': instance.originalName,
      'mimeType': instance.mimeType,
    };
