// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_like_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLikeProductDto _$UserLikeProductDtoFromJson(Map<String, dynamic> json) =>
    UserLikeProductDto(
      id: (json['id'] as num).toInt(),
      issuer: json['issuer'] as String,
      name: json['name'] as String,
      productType: json['productType'] as String,
      equities: json['equities'] as String,
      yieldIfConditionsMet: (json['yieldIfConditionsMet'] as num).toDouble(),
      knockIn: (json['knockIn'] as num?)?.toInt(),
      subscriptionStartDate: json['subscriptionStartDate'] as String,
      subscriptionEndDate: json['subscriptionEndDate'] as String,
    );

Map<String, dynamic> _$UserLikeProductDtoToJson(UserLikeProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'issuer': instance.issuer,
      'name': instance.name,
      'productType': instance.productType,
      'equities': instance.equities,
      'yieldIfConditionsMet': instance.yieldIfConditionsMet,
      'knockIn': instance.knockIn,
      'subscriptionStartDate': instance.subscriptionStartDate,
      'subscriptionEndDate': instance.subscriptionEndDate,
    };
