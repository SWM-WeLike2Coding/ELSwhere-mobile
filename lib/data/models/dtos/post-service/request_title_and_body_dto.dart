import 'package:json_annotation/json_annotation.dart';

part 'request_title_and_body_dto.g.dart';

@JsonSerializable()
class RequestTitleAndBodyDto {
  final String title;
  final String body;

  RequestTitleAndBodyDto({required this.title, required this.body});

  factory RequestTitleAndBodyDto.fromJson(Map<String, dynamic> json) => _$RequestTitleAndBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestTitleAndBodyDtoToJson(this);
}
