import 'package:json_annotation/json_annotation.dart';

part 'response_interesting_product_dto.g.dart';

@JsonSerializable()
class ResponseInterestingProductDto {
  final int interestId;
  final int productId;
  final String issuer;
  final String name;
  final String productType;
  final String equities;
  final double yieldIfConditionsMet;
  final int? knockIn;
  final String subscriptionStartDate;
  final String subscriptionEndDate;



  ResponseInterestingProductDto({
    required this.interestId,
    required this.productId,
    required this.issuer,
    required this.name,
    required this.productType,
    required this.equities,
    required this.yieldIfConditionsMet,
    this.knockIn,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
  });

  factory ResponseInterestingProductDto.fromJson(Map<String, dynamic> json) => _$ResponseInterestingProductDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseInterestingProductDtoToJson(this);
}
