import 'package:json_annotation/json_annotation.dart';

part 'summarized_product_dto.g.dart';

@JsonSerializable()
class SummarizedProductDto {
  final int id;
  final String name;
  final String equities;
  final double yieldIfConditionsMet;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;

  SummarizedProductDto({
    required this.id,
    required this.name,
    required this.equities,
    required this.yieldIfConditionsMet,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
  });

  factory SummarizedProductDto.fromJson(Map<String, dynamic> json) => _$SummarizedProductDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SummarizedProductDtoToJson(this);
}
