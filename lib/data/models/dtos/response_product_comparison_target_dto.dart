import 'package:elswhere/data/models/dtos/summarized_product_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_product_comparison_target_dto.g.dart';

@JsonSerializable()
class ResponseProductComparisonTargetDto extends SummarizedProductDto {
  final int id;
  final String issuer;
  final String name;
  final double yieldIfConditionsMet;
  final String equities;
  @JsonKey(name: 'type')
  final String productType;
  final String productFullInfo;
  final String? productInfo;
  final int? knockIn;
  final double maximumLossRate;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;

  ResponseProductComparisonTargetDto({
    required this.id,
    required this.issuer,
    required this.name,
    required this.yieldIfConditionsMet,
    required this.equities,
    required this.productType,
    required this.productFullInfo,
    this.productInfo,
    this.knockIn,
    required this.maximumLossRate,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
  }) : super(
          id: id,
          issuer: issuer,
          name: name,
          productType: productType,
          equities: equities,
          yieldIfConditionsMet: yieldIfConditionsMet,
          subscriptionStartDate: subscriptionStartDate,
          subscriptionEndDate: subscriptionEndDate,
          knockIn: knockIn,
        );

  factory ResponseProductComparisonTargetDto.fromJson(Map<String, dynamic> json) => _$ResponseProductComparisonTargetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseProductComparisonTargetDtoToJson(this);
}
