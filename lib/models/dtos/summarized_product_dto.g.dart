// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summarized_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummarizedProductDto _$SummarizedProductDtoFromJson(
        Map<String, dynamic> json) =>
    SummarizedProductDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      equities: json['equities'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      subscriptionStartDate:
          DateTime.parse(json['subscriptionStartDate'] as String),
      subscriptionEndDate:
          DateTime.parse(json['subscriptionEndDate'] as String),
    );

Map<String, dynamic> _$SummarizedProductDtoToJson(
        SummarizedProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'equities': instance.equities,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
    };
