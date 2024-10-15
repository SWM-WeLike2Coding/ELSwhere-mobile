// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_page_summarized_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsePageSummarizedProductDto _$ResponsePageSummarizedProductDtoFromJson(
        Map<String, dynamic> json) =>
    ResponsePageSummarizedProductDto(
      content: (json['content'] as List<dynamic>)
          .map((e) => SummarizedProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: json['hasNext'] as bool,
      totalPages: (json['totalPages'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      first: json['first'] as bool,
      last: json['last'] as bool,
    );

Map<String, dynamic> _$ResponsePageSummarizedProductDtoToJson(
        ResponsePageSummarizedProductDto instance) =>
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
