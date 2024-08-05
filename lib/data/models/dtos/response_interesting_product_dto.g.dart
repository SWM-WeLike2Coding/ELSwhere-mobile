// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_interesting_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseInterestingProductDto _$ResponseInterestingProductDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseInterestingProductDto(
      interestId: (json['interestId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      issuer: json['issuer'] as String,
      name: json['name'] as String,
      productType: json['productType'] as String,
      equities: json['equities'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      knockIn: (json['knockIn'] as num?)?.toInt(),
      subscriptionStartDate: json['subscriptionStartDate'] as String,
      subscriptionEndDate: json['subscriptionEndDate'] as String,
    );

Map<String, dynamic> _$ResponseInterestingProductDtoToJson(
        ResponseInterestingProductDto instance) =>
    <String, dynamic>{
      'interestId': instance.interestId,
      'productId': instance.productId,
      'issuer': instance.issuer,
      'name': instance.name,
      'productType': instance.productType,
      'equities': instance.equities,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'knockIn': instance.knockIn,
      'subscriptionStartDate': instance.subscriptionStartDate,
      'subscriptionEndDate': instance.subscriptionEndDate,
    };
