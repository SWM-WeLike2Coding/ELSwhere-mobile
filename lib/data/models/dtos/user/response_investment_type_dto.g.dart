// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_investment_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseInvestmentTypeDto _$ResponseInvestmentTypeDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseInvestmentTypeDto(
      investmentExperience: json['investmentExperience'] as String,
      investmentPreferredPeriod: json['investmentPreferredPeriod'] as String,
      riskTakingAbility: json['riskTakingAbility'] as String,
    );

Map<String, dynamic> _$ResponseInvestmentTypeDtoToJson(
        ResponseInvestmentTypeDto instance) =>
    <String, dynamic>{
      'investmentExperience': instance.investmentExperience,
      'investmentPreferredPeriod': instance.investmentPreferredPeriod,
      'riskTakingAbility': instance.riskTakingAbility,
    };
