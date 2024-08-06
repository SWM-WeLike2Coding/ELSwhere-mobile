// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'els_product_for_schedule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElsProductForScheduleDto _$ElsProductForScheduleDtoFromJson(
        Map<String, dynamic> json) =>
    ElsProductForScheduleDto(
      isHolding: json['isHolding'] as bool,
      productId: (json['productId'] as num).toInt(),
      issuer: json['issuer'] as String,
      name: json['name'] as String,
      equities: json['equities'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      subscriptionStartDate:
          DateTime.parse(json['subscriptionStartDate'] as String),
      subscriptionEndDate:
          DateTime.parse(json['subscriptionEndDate'] as String),
      interestId: (json['interestId'] as num?)?.toInt(),
      productType: json['productType'] as String,
      knockIn: (json['knockIn'] as num?)?.toInt(),
      investingAmount: (json['investingAmount'] as num?)?.toInt(),
      earlyRedemptionEvaluationDates:
          (json['earlyRedemptionEvaluationDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList(),
      currentEarningPercent:
          (json['currentEarningPercent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ElsProductForScheduleDtoToJson(
        ElsProductForScheduleDto instance) =>
    <String, dynamic>{
      'isHolding': instance.isHolding,
      'productId': instance.productId,
      'issuer': instance.issuer,
      'name': instance.name,
      'equities': instance.equities,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
      'knockIn': instance.knockIn,
      'productType': instance.productType,
      'investingAmount': instance.investingAmount,
      'earlyRedemptionEvaluationDates': instance.earlyRedemptionEvaluationDates
          ?.map((e) => e.toIso8601String())
          .toList(),
      'currentEarningPercent': instance.currentEarningPercent,
      'interestId': instance.interestId,
    };
