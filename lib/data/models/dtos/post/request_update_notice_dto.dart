import 'package:json_annotation/json_annotation.dart';

part 'request_update_notice_dto.g.dart';

@JsonSerializable()
class RequestUpdateNoticeDto {
  final String title;
  final String body;

  RequestUpdateNoticeDto({required this.title, required this.body});

  factory RequestUpdateNoticeDto.fromJson(Map<String, dynamic> json) => _$RequestUpdateNoticeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUpdateNoticeDtoToJson(this);
}
