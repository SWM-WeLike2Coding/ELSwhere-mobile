import 'package:json_annotation/json_annotation.dart';

part 'els_product_for_schedule_dto.g.dart';

@JsonSerializable()
class ElsProductForScheduleDto {
  final bool isHolding;
  final int productId;
  final int? holdingId;
  final String issuer;
  final String name;
  final String equities;
  final double yieldIfConditionsMet;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;
  final int? knockIn;
  final String productType;
  final double? investingAmount;
  final List<DateTime>? earlyRedemptionEvaluationDates; // 조기상환평가일
  final double? currentEarningPercent;
  final int? interestId;



  ElsProductForScheduleDto({
    required this.isHolding,
    required this.productId,
    this.holdingId,
    required this.issuer,
    required this.name,
    required this.equities,
    required this.yieldIfConditionsMet,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    this.interestId,
    required this.productType,
    this.knockIn,
    this.investingAmount,
    this.earlyRedemptionEvaluationDates,
    this.currentEarningPercent,
  });

  factory ElsProductForScheduleDto.fromJson(Map<String, dynamic> json) => _$ElsProductForScheduleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ElsProductForScheduleDtoToJson(this);
}