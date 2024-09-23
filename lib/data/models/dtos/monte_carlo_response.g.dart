// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monte_carlo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonteCarloResponse _$MonteCarloResponseFromJson(Map<String, dynamic> json) =>
    MonteCarloResponse(
      monteCarloResultId: (json['monteCarloResultId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      earlyRepaymentProbability: json['earlyRepaymentProbability'] as String,
      maturityRepaymentProbability:
          (json['maturityRepaymentProbability'] as num).toDouble(),
      lossProbability: (json['lossProbability'] as num).toDouble(),
    );

Map<String, dynamic> _$MonteCarloResponseToJson(MonteCarloResponse instance) =>
    <String, dynamic>{
      'monteCarloResultId': instance.monteCarloResultId,
      'productId': instance.productId,
      'earlyRepaymentProbability': instance.earlyRepaymentProbability,
      'maturityRepaymentProbability': instance.maturityRepaymentProbability,
      'lossProbability': instance.lossProbability,
    };
