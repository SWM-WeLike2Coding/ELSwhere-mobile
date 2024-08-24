import 'package:json_annotation/json_annotation.dart';

part 'response_user_info_dto.g.dart';

@JsonSerializable()
class ResponseUserInfoDto {
  final String socialType;
  final String email;
  final String name;
  final String nickname;
  final bool admin;
  final DateTime createdAt;

  ResponseUserInfoDto({
    required this.socialType,
    required this.email,
    required this.name,
    required this.nickname,
    required this.admin,
    required this.createdAt,
  });

  factory ResponseUserInfoDto.fromJson(Map<String, dynamic> json) => _$ResponseUserInfoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseUserInfoDtoToJson(this);
}
