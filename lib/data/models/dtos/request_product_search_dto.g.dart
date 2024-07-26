// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_product_search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestProductSearchDto _$RequestProductSearchDtoFromJson(
        Map<String, dynamic> json) =>
    RequestProductSearchDto(
      equityNames: (json['equityNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      equityCount: (json['equityCount'] as num?)?.toInt(),
      issuer: json['issuer'] as String?,
      maxKnockIn: json['maxKnockIn'] as String?,
      minYieldIfConditionsMet:
          (json['minYieldIfConditionsMet'] as num?)?.toDouble(),
      initialRedemptionBarrier:
          (json['initialRedemptionBarrier'] as num?)?.toInt(),
      maturityRedemptionBarrier:
          (json['maturityRedemptionBarrier'] as num?)?.toInt(),
      subscriptionPeriod: (json['subscriptionPeriod'] as num?)?.toInt(),
      redemptionInterval: (json['redemptionInterval'] as num?)?.toInt(),
      equityType: json['equityType'] as String?,
      type: json['type'] as String?,
      subscriptionStartDate: json['subscriptionStartDate'] as String?,
      subscriptionEndDate: json['subscriptionEndDate'] as String?,
    );

Map<String, dynamic> _$RequestProductSearchDtoToJson(
        RequestProductSearchDto instance) =>
    <String, dynamic>{
      'equityNames': instance.equityNames,
      'equityCount': instance.equityCount,
      'issuer': instance.issuer,
      'maxKnockIn': instance.maxKnockIn,
      'minYieldIfConditionsMet': instance.minYieldIfConditionsMet,
      'initialRedemptionBarrier': instance.initialRedemptionBarrier,
      'maturityRedemptionBarrier': instance.maturityRedemptionBarrier,
      'subscriptionPeriod': instance.subscriptionPeriod,
      'redemptionInterval': instance.redemptionInterval,
      'equityType': instance.equityType,
      'type': instance.type,
      'subscriptionStartDate': instance.subscriptionStartDate,
      'subscriptionEndDate': instance.subscriptionEndDate,
    };
