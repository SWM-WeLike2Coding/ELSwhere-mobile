// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summarized_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummarizedProductDto _$SummarizedProductDtoFromJson(
        Map<String, dynamic> json) =>
    SummarizedProductDto(
      id: (json['id'] as num).toInt(),
      issuer: json['issuer'] as String,
      name: json['name'] as String,
      productType: json['productType'] as String,
      equities: json['equities'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      knockIn: (json['knockIn'] as num?)?.toInt(),
      subscriptionStartDate:
          DateTime.parse(json['subscriptionStartDate'] as String),
      subscriptionEndDate:
          DateTime.parse(json['subscriptionEndDate'] as String),
    );

Map<String, dynamic> _$SummarizedProductDtoToJson(
        SummarizedProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'issuer': instance.issuer,
      'name': instance.name,
      'productType': instance.productType,
      'equities': instance.equities,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'knockIn': instance.knockIn,
      'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
    };
