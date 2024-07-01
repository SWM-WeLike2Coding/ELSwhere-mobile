// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_single_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseSingleProductDto _$ResponseSingleProductDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseSingleProductDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      equities: json['equities'] as String,
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      maturityDate: DateTime.parse(json['maturityDate'] as String),
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      maximumLossRate: (json['maximumLossRate'] as num).toDouble(),
      subscriptionStartDate:
          DateTime.parse(json['subscriptionStartDate'] as String),
      subscriptionEndDate:
          DateTime.parse(json['subscriptionEndDate'] as String),
      type: json['type'] as String,
      link: json['link'] as String,
      remarks: json['remarks'] as String? ?? '',
      summaryInvestmentProspectusLink:
          json['summaryInvestmentProspectusLink'] as String? ?? '',
      earlyRepaymentEvaluationDates:
          json['earlyRepaymentEvaluationDates'] as String? ?? '',
    );

Map<String, dynamic> _$ResponseSingleProductDtoToJson(
        ResponseSingleProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'equities': instance.equities,
      'issuedDate': instance.issuedDate.toIso8601String(),
      'maturityDate': instance.maturityDate.toIso8601String(),
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'maximumLossRate': instance.maximumLossRate,
      'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
      'type': instance.type,
      'link': instance.link,
      'remarks': instance.remarks,
      'summaryInvestmentProspectusLink':
          instance.summaryInvestmentProspectusLink,
      'earlyRepaymentEvaluationDates': instance.earlyRepaymentEvaluationDates,
    };
