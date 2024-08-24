// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_single_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseSingleProductDto _$ResponseSingleProductDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseSingleProductDto(
      id: (json['id'] as num).toInt(),
      issuer: json['issuer'] as String,
      name: json['name'] as String,
      equities: json['equities'] as String,
      equityCount: (json['equityCount'] as num).toInt(),
      knockIn: (json['knockIn'] as num?)?.toInt(),
      volatilites: json['volatilites'] as String,
      earlyRepaymentEvaluationDates:
          json['earlyRepaymentEvaluationDates'] as String?,
      issuedDate: json['issuedDate'] as String,
      maturityDate: json['maturityDate'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      maximumLossRate: (json['maximumLossRate'] as num).toDouble(),
      subscriptionStartDate: json['subscriptionStartDate'] as String,
      subscriptionEndDate: json['subscriptionEndDate'] as String,
      initialBasePriceEvaluationDate:
          json['initialBasePriceEvaluationDate'] as String,
      type: json['type'] as String,
      productFullInfo: json['productFullInfo'] as String,
      productInfo: json['productInfo'] as String?,
      remarks: json['remarks'] as String,
      link: json['link'] as String,
      summaryInvestmentProspectusLink:
          json['summaryInvestmentProspectusLink'] as String,
      equityTickerSymbols:
          Map<String, String>.from(json['equityTickerSymbols'] as Map),
    );

Map<String, dynamic> _$ResponseSingleProductDtoToJson(
        ResponseSingleProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'issuer': instance.issuer,
      'name': instance.name,
      'equities': instance.equities,
      'equityCount': instance.equityCount,
      'knockIn': instance.knockIn,
      'volatilites': instance.volatilites,
      'earlyRepaymentEvaluationDates': instance.earlyRepaymentEvaluationDates,
      'issuedDate': instance.issuedDate,
      'maturityDate': instance.maturityDate,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'maximumLossRate': instance.maximumLossRate,
      'subscriptionStartDate': instance.subscriptionStartDate,
      'subscriptionEndDate': instance.subscriptionEndDate,
      'initialBasePriceEvaluationDate': instance.initialBasePriceEvaluationDate,
      'type': instance.type,
      'productFullInfo': instance.productFullInfo,
      'productInfo': instance.productInfo,
      'remarks': instance.remarks,
      'link': instance.link,
      'summaryInvestmentProspectusLink':
          instance.summaryInvestmentProspectusLink,
      'equityTickerSymbols': instance.equityTickerSymbols,
    };
