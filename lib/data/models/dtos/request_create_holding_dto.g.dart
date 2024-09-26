// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_create_holding_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestCreateHoldingDto _$RequestCreateHoldingDtoFromJson(
        Map<String, dynamic> json) =>
    RequestCreateHoldingDto(
      productId: (json['productId'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$RequestCreateHoldingDtoToJson(
        RequestCreateHoldingDto instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'price': instance.price,
    };
