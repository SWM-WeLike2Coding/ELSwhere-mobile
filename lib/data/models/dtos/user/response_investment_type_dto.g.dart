// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_investment_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseInvestmentTypeDto _$ResponseInvestmentTypeDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseInvestmentTypeDto(
      investmentExperience: json['investmentExperience'] as String,
      riskPropensity: json['riskPropensity'] as String,
      repaymentOption: json['repaymentOption'] as String,
      minPreferredReturn: (json['minPreferredReturn'] as num).toInt(),
    );

Map<String, dynamic> _$ResponseInvestmentTypeDtoToJson(
        ResponseInvestmentTypeDto instance) =>
    <String, dynamic>{
      'investmentExperience': instance.investmentExperience,
      'riskPropensity': instance.riskPropensity,
      'repaymentOption': instance.repaymentOption,
      'minPreferredReturn': instance.minPreferredReturn,
    };
