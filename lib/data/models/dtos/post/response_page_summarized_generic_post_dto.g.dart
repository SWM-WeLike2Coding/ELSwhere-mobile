// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_page_summarized_generic_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsePageSummarizedGenericPostDto
    _$ResponsePageSummarizedGenericPostDtoFromJson(Map<String, dynamic> json) =>
        ResponsePageSummarizedGenericPostDto(
          content: (json['content'] as List<dynamic>)
              .map((e) =>
                  SummarizedGenericPostDto.fromJson(e as Map<String, dynamic>))
              .toList(),
          hasNext: json['hasNext'] as bool,
          totalPages: (json['totalPages'] as num).toInt(),
          totalElements: (json['totalElements'] as num).toInt(),
          page: (json['page'] as num).toInt(),
          size: (json['size'] as num).toInt(),
          first: json['first'] as bool,
          last: json['last'] as bool,
        );

Map<String, dynamic> _$ResponsePageSummarizedGenericPostDtoToJson(
        ResponsePageSummarizedGenericPostDto instance) =>
    <String, dynamic>{
      'content': instance.content,
      'hasNext': instance.hasNext,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'page': instance.page,
      'size': instance.size,
      'first': instance.first,
      'last': instance.last,
    };
