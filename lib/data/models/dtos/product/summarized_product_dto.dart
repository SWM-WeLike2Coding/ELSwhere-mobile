import 'package:json_annotation/json_annotation.dart';

part 'summarized_product_dto.g.dart';

@JsonSerializable()
class SummarizedProductDto {
  final int id;
  final String issuer;
  final String name;
  final String productType;
  final String equities;
  final double yieldIfConditionsMet;
  final int? knockIn;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;

  SummarizedProductDto({
    required this.id,
    required this.issuer,
    required this.name,
    required this.productType,
    required this.equities,
    required this.yieldIfConditionsMet,
    this.knockIn,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
  });

  factory SummarizedProductDto.fromJson(Map<String, dynamic> json) => _$SummarizedProductDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SummarizedProductDtoToJson(this);
}
