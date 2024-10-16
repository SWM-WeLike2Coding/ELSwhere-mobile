import 'package:json_annotation/json_annotation.dart';

part 'response_single_product_dto.g.dart';

@JsonSerializable()
class ResponseSingleProductDto {
  final int id;
  final String issuer;
  final String name;
  final String equities;
  final int equityCount;
  final int? knockIn;
  final String volatilites;
  final String? earlyRepaymentEvaluationDates;
  final String issuedDate;
  final String maturityDate;
  final double yieldIfConditionsMet;
  final double maximumLossRate;
  final String subscriptionStartDate;
  final String subscriptionEndDate;
  final String? initialBasePriceEvaluationDate;
  final String type;
  final String productFullInfo;
  final String? productInfo;
  final String remarks;
  final String link;
  final String summaryInvestmentProspectusLink;
  final Map<String, String> equityTickerSymbols;
  final int likes;
  final bool liked;

  ResponseSingleProductDto({
    required this.id,
    required this.issuer,
    required this.name,
    required this.equities,
    required this.equityCount,
    this.knockIn,
    required this.volatilites,
    this.earlyRepaymentEvaluationDates,
    required this.issuedDate,
    required this.maturityDate,
    required this.yieldIfConditionsMet,
    required this.maximumLossRate,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    this.initialBasePriceEvaluationDate,
    required this.type,
    required this.productFullInfo,
    this.productInfo,
    required this.remarks,
    required this.link,
    required this.summaryInvestmentProspectusLink,
    required this.equityTickerSymbols,
    required this.likes,
    required this.liked,
  });

  factory ResponseSingleProductDto.fromJson(Map<String, dynamic> json) => _$ResponseSingleProductDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseSingleProductDtoToJson(this);
}
