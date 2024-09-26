import 'package:json_annotation/json_annotation.dart';

part 'summarized_user_holding_dto.g.dart';

@JsonSerializable()
class SummarizedUserHoldingDto {
  final int holdingId;
  final int productId;
  final String issuer;
  final String name;
  final String productType;
  final double yieldIfConditionsMet;
  final DateTime nextRepaymentEvaluationDate;
  final double price;
  final double? recentAndInitialPriceRatio;

  SummarizedUserHoldingDto({
    required this.holdingId,
    required this.productId,
    required this.issuer,
    required this.name,
    required this.productType,
    required this.yieldIfConditionsMet,
    required this.nextRepaymentEvaluationDate,
    required this.price,
    required this.recentAndInitialPriceRatio,
  });

  factory SummarizedUserHoldingDto.fromJson(Map<String, dynamic> json) =>
      _$SummarizedUserHoldingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SummarizedUserHoldingDtoToJson(this);
}
