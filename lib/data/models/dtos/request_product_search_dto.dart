import 'package:json_annotation/json_annotation.dart';

part 'request_product_search_dto.g.dart';

@JsonSerializable()
class RequestProductSearchDto {
  final List<String>? equityNames;
  final int? equityCount;
  final String? issuer;
  final String? maxKnockIn;
  final double? minYieldIfConditionsMet;
  final int? initialRedemptionBarrier;
  final int? maturityRedemptionBarrier;
  final int? subscriptionPeriod;
  final int? redemptionInterval;
  final String? equityType;
  final String? type;
  final String? subscriptionStartDate;
  final String? subscriptionEndDate;

  RequestProductSearchDto({
    required this.equityNames,
    required this.equityCount,
    required this.issuer,
    required this.maxKnockIn,
    required this.minYieldIfConditionsMet,
    required this.initialRedemptionBarrier,
    required this.maturityRedemptionBarrier,
    required this.subscriptionPeriod,
    required this.redemptionInterval,
    required this.equityType,
    required this.type,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
  });

  factory RequestProductSearchDto.fromJson(Map<String, dynamic> json) => _$RequestProductSearchDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RequestProductSearchDtoToJson(this);
}