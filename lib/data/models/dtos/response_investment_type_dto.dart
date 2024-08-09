import 'package:json_annotation/json_annotation.dart';

part 'response_investment_type_dto.g.dart';

@JsonSerializable()
class ResponseInvestmentTypeDto {
  final String investmentExperience;
  final String investmentPreferredPeriod;
  final String riskTakingAbility;

  ResponseInvestmentTypeDto({
    required this.investmentExperience,
    required this.investmentPreferredPeriod,
    required this.riskTakingAbility,
  });

  factory ResponseInvestmentTypeDto.fromJson(Map<String, dynamic> json) => _$ResponseInvestmentTypeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseInvestmentTypeDtoToJson(this);
}