import 'package:json_annotation/json_annotation.dart';

part 'monte_carlo_response.g.dart';

@JsonSerializable()
class MonteCarloResponse {
  final int monteCarloResultId;
  final int productId;
  final String earlyRepaymentProbability;
  final double maturityRepaymentProbability;
  final double lossProbability;

  MonteCarloResponse({
    required this.monteCarloResultId,
    required this.productId,
    required this.earlyRepaymentProbability,
    required this.maturityRepaymentProbability,
    required this.lossProbability,
  });

  factory MonteCarloResponse.fromJson(Map<String, dynamic> json) =>
      _$MonteCarloResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MonteCarloResponseToJson(this);
}
