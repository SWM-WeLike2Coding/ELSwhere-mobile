// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_ratio_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceRatioResponse _$PriceRatioResponseFromJson(Map<String, dynamic> json) =>
    PriceRatioResponse(
      initial: (json['initial'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      recent: (json['recent'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      ratio: (json['ratio'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      recentAndInitialPriceRatio:
          (json['recentAndInitialPriceRatio'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PriceRatioResponseToJson(PriceRatioResponse instance) =>
    <String, dynamic>{
      'initial': instance.initial,
      'recent': instance.recent,
      'ratio': instance.ratio,
      'recentAndInitialPriceRatio': instance.recentAndInitialPriceRatio,
    };
