// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_issuer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseIssuerDto _$ResponseIssuerDtoFromJson(Map<String, dynamic> json) =>
    ResponseIssuerDto(
      id: (json['id'] as num).toInt(),
      issuer: json['issuer'] as String,
    );

Map<String, dynamic> _$ResponseIssuerDtoToJson(ResponseIssuerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'issuer': instance.issuer,
    };
