// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summarized_generic_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummarizedGenericPostDto _$SummarizedGenericPostDtoFromJson(
        Map<String, dynamic> json) =>
    SummarizedGenericPostDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      author: json['author'] as String,
      createdAt: json['createdAt'] as String,
      body: json['body'] as String,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => PostImageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => PostFileDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SummarizedGenericPostDtoToJson(
        SummarizedGenericPostDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'createdAt': instance.createdAt,
      'body': instance.body,
      'images': instance.images,
      'files': instance.files,
    };
