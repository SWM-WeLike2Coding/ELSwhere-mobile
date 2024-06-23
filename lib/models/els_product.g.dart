// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'els_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ELSProduct _$ELSProductFromJson(Map<String, dynamic> json) => ELSProduct(
      assetNames: (json['assetNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      maturityDate: DateTime.parse(json['maturityDate'] as String),
      subscriptionStartDate:
          DateTime.parse(json['subscriptionStartDate'] as String),
      subscriptionEndDate:
          DateTime.parse(json['subscriptionEndDate'] as String),
      productType: json['productType'] as ELSType,
      couponRate: (json['couponRate'] as num).toDouble(),
      earlyRedemptionEvaluationDates:
          (json['earlyRedemptionEvaluationDates'] as List<dynamic>)
              .map((e) => DateTime.parse(e as String))
              .toList(),
      earlyRedemptionBarrier:
          (json['earlyRedemptionBarrier'] as num).toDouble(),
      knockInBarrier: (json['knockInBarrier'] as num).toDouble(),
      productCode: json['productCode'] as String,
      issuer: json['issuer'] as String,
    );

Map<String, dynamic> _$ELSProductToJson(ELSProduct instance) =>
    <String, dynamic>{
      'assetNames': instance.assetNames,
      'maturityDate': instance.maturityDate.toIso8601String(),
      'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
      'productType': instance.productType,
      'couponRate': instance.couponRate,
      'earlyRedemptionEvaluationDates': instance.earlyRedemptionEvaluationDates
          .map((e) => e.toIso8601String())
          .toList(),
      'earlyRedemptionBarrier': instance.earlyRedemptionBarrier,
      'knockInBarrier': instance.knockInBarrier,
      'productCode': instance.productCode,
      'issuer': instance.issuer,
    };
