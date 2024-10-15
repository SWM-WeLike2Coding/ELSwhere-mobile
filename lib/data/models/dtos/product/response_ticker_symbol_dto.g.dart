// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_ticker_symbol_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseTickerSymbolDto _$ResponseTickerSymbolDtoFromJson(
        Map<String, dynamic> json) =>
    ResponseTickerSymbolDto(
      id: (json['id'] as num).toInt(),
      equityName: json['equityName'] as String,
      tickerSymbol: json['tickerSymbol'] as String,
    );

Map<String, dynamic> _$ResponseTickerSymbolDtoToJson(
        ResponseTickerSymbolDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'equityName': instance.equityName,
      'tickerSymbol': instance.tickerSymbol,
    };
