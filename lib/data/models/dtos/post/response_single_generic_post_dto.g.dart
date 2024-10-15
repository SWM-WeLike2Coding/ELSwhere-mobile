// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_single_generic_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseSingleGenericPostDto _$ResponseSingleGenericPostDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseSingleGenericPostDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      author: json['author'] as String,
      createdAt: json['createdAt'] as String,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => PostImageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => PostFileDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      mine: json['mine'] as bool,
    );

Map<String, dynamic> _$ResponseSingleGenericPostDtoToJson(
        ResponseSingleGenericPostDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'author': instance.author,
      'createdAt': instance.createdAt,
      'images': instance.images,
      'files': instance.files,
      'mine': instance.mine,
    };
