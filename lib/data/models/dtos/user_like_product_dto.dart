import 'package:json_annotation/json_annotation.dart';

part 'user_like_product_dto.g.dart';

@JsonSerializable()
class UserLikeProductDto {
  final int id;
  final String issuer;
  final String name;
  final String productType;
  final String equities;
  final double yieldIfConditionsMet;
  final int? knockIn;
  final String subscriptionStartDate;
  final String subscriptionEndDate;

  UserLikeProductDto({
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

  factory UserLikeProductDto.fromJson(Map<String, dynamic> json) =>
      _$UserLikeProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserLikeProductDtoToJson(this);
}
