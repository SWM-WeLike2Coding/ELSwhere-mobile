import 'package:json_annotation/json_annotation.dart';

part 'request_create_holding_dto.g.dart';

@JsonSerializable()
class RequestCreateHoldingDto {
  final int productId;
  final double price;

  RequestCreateHoldingDto({
    required this.productId,
    required this.price,
  });

  factory RequestCreateHoldingDto.fromJson(Map<String, dynamic> json) =>
      _$RequestCreateHoldingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestCreateHoldingDtoToJson(this);
}