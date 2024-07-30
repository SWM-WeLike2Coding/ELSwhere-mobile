import 'package:json_annotation/json_annotation.dart';

part 'response_ticker_symbol_dto.g.dart';

@JsonSerializable()
class ResponseTickerSymbolDto {
  final int id;
  final String equityName;
  final String tickerSymbol;

  ResponseTickerSymbolDto({
    required this.id,
    required this.equityName,
    required this.tickerSymbol,
  });

  factory ResponseTickerSymbolDto.fromJson(Map<String, dynamic> json) => _$ResponseTickerSymbolDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseTickerSymbolDtoToJson(this);

  static List<ResponseTickerSymbolDto> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => ResponseTickerSymbolDto.fromJson(json)).toList();
}