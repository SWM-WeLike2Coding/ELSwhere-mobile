import 'package:json_annotation/json_annotation.dart';

part 'response_id_dto.g.dart';

@JsonSerializable()
class ResponseIdDto {
  final int id;

  ResponseIdDto({required this.id});

  factory ResponseIdDto.fromJson(Map<String, dynamic> json) => _$ResponseIdDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseIdDtoToJson(this);
}
