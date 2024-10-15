import 'package:json_annotation/json_annotation.dart';

part 'response_login_dto.g.dart';

@JsonSerializable()
class ResponseLoginDto {
  @JsonKey(name: "access_token")
  final String accessToken;
  @JsonKey(name: "refresh_token")
  final String refreshToken;

  ResponseLoginDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory ResponseLoginDto.fromJson(Map<String, dynamic> json) => _$ResponseLoginDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseLoginDtoToJson(this);
}
