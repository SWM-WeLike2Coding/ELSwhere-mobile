// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_product_comparison_main_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseProductComparisonMainDto _$ResponseProductComparisonMainDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseProductComparisonMainDto(
      results: (json['results'] as List<dynamic>)
          .map((e) => ResponseProductComparisonTargetDto.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      target: (json['target'] as List<dynamic>)
          .map((e) => ResponseProductComparisonTargetDto.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseProductComparisonMainDtoToJson(
        ResponseProductComparisonMainDto instance) =>
    <String, dynamic>{
      'results': instance.results,
      'target': instance.target,
    };
