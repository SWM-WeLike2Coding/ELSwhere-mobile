// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summarized_user_holding_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummarizedUserHoldingDto _$SummarizedUserHoldingDtoFromJson(
        Map<String, dynamic> json) =>
    SummarizedUserHoldingDto(
      holdingId: (json['holdingId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      issuer: json['issuer'] as String,
      name: json['name'] as String,
      productType: json['productType'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      nextRepaymentEvaluationDate:
          DateTime.parse(json['nextRepaymentEvaluationDate'] as String),
      price: (json['price'] as num).toDouble(),
      recentAndInitialPriceRatio:
          (json['recentAndInitialPriceRatio'] ?? 0 as num).toDouble(),
    );

Map<String, dynamic> _$SummarizedUserHoldingDtoToJson(
        SummarizedUserHoldingDto instance) =>
    <String, dynamic>{
      'holdingId': instance.holdingId,
      'productId': instance.productId,
      'issuer': instance.issuer,
      'name': instance.name,
      'productType': instance.productType,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'nextRepaymentEvaluationDate':
          instance.nextRepaymentEvaluationDate.toIso8601String(),
      'price': instance.price,
      'recentAndInitialPriceRatio': instance.recentAndInitialPriceRatio,
    };
