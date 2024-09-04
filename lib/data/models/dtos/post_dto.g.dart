// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDto _$PostDtoFromJson(Map<String, dynamic> json) => PostDto(
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PostDtoToJson(PostDto instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'type': instance.type,
      'createdAt': instance.createdAt?.toIso8601String(),
};
