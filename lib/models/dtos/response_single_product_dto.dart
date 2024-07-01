import 'package:json_annotation/json_annotation.dart';

part 'response_single_product_dto.g.dart';

@JsonSerializable()
class ResponseSingleProductDto {
  final int id;
  final String name;
  final String equities;
  final DateTime issuedDate;
  final DateTime maturityDate;
  final double yieldIfConditionsMet;
  final double maximumLossRate;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;
  final String type;
  final String link;
  final String? remarks;
  final String? summaryInvestmentProspectusLink;
  final String? earlyRepaymentEvaluationDates;

  ResponseSingleProductDto({
    required this.id,
    required this.name,
    required this.equities,
    required this.issuedDate,
    required this.maturityDate,
    required this.yieldIfConditionsMet,
    required this.maximumLossRate,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.type,
    required this.link,
    required this.remarks,
    required this.summaryInvestmentProspectusLink,
    required this.earlyRepaymentEvaluationDates,
  });

  factory ResponseSingleProductDto.fromJson(Map<String, dynamic> json) => _$ResponseSingleProductDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseSingleProductDtoToJson(this);
}
