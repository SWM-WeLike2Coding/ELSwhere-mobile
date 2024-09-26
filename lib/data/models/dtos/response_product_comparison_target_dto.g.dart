// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_product_comparison_target_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseProductComparisonTargetDto _$ResponseProductComparisonTargetDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseProductComparisonTargetDto(
      id: (json['id'] as num).toInt(),
      issuer: json['issuer'] as String,
      name: json['name'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      equities: json['equities'] as String,
      productType: json['type'] as String,
      productFullInfo: json['productFullInfo'] as String,
      productInfo: json['productInfo'] as String?,
      knockIn: (json['knockIn'] as num?)?.toInt(),
      maximumLossRate: (json['maximumLossRate'] as num).toDouble(),
      subscriptionStartDate:
          DateTime.parse(json['subscriptionStartDate'] as String),
      subscriptionEndDate:
          DateTime.parse(json['subscriptionEndDate'] as String),
    );

Map<String, dynamic> _$ResponseProductComparisonTargetDtoToJson(
        ResponseProductComparisonTargetDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'issuer': instance.issuer,
      'name': instance.name,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'equities': instance.equities,
      'type': instance.productType,
      'productFullInfo': instance.productFullInfo,
      'productInfo': instance.productInfo,
      'knockIn': instance.knockIn,
      'maximumLossRate': instance.maximumLossRate,
      'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
    };
