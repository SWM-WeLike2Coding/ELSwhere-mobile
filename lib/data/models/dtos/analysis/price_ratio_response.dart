import 'package:json_annotation/json_annotation.dart';

part 'price_ratio_response.g.dart';

@JsonSerializable()
class PriceRatioResponse {
  final Map<String, double> initial;
  final Map<String, double> recent;
  final Map<String, double> ratio;
  final double? recentAndInitialPriceRatio;

  PriceRatioResponse({
    required this.initial,
    required this.recent,
    required this.ratio,
    required this.recentAndInitialPriceRatio,
  });

  factory PriceRatioResponse.fromJson(Map<String, dynamic> json) => _$PriceRatioResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PriceRatioResponseToJson(this);
}
