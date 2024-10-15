import 'package:json_annotation/json_annotation.dart';

part 'response_issuer_dto.g.dart';

@JsonSerializable()
class ResponseIssuerDto {
  final int id;
  final String issuer;

  ResponseIssuerDto({
    required this.id,
    required this.issuer,
  });

  factory ResponseIssuerDto.fromJson(Map<String, dynamic> json) => _$ResponseIssuerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseIssuerDtoToJson(this);

  static List<ResponseIssuerDto> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => ResponseIssuerDto.fromJson(json)).toList();
}