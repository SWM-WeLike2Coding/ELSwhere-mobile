import 'package:json_annotation/json_annotation.dart';

part 'post_file_dto.g.dart';

@JsonSerializable()
class PostFileDto {
  final int id;
  final String url;
  final String originalName;
  final String mimeType;

  PostFileDto({
    required this.id,
    required this.url,
    required this.originalName,
    required this.mimeType,
  });

  factory PostFileDto.fromJson(Map<String, dynamic> json) => _$PostFileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostFileDtoToJson(this);
}
