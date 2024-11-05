import 'package:json_annotation/json_annotation.dart';

part 'response_investment_type_dto.g.dart';

@JsonSerializable()
class ResponseInvestmentTypeDto {
  final String investmentExperience;
  final String riskPropensity;
  final String repaymentOption;
  final int minPreferredReturn;

  ResponseInvestmentTypeDto({
    required this.investmentExperience,
    required this.riskPropensity,
    required this.repaymentOption,
    required this.minPreferredReturn,
  });

  factory ResponseInvestmentTypeDto.fromJson(Map<String, dynamic> json) => _$ResponseInvestmentTypeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseInvestmentTypeDtoToJson(this);
}