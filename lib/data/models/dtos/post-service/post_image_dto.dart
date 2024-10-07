import 'package:json_annotation/json_annotation.dart';

part 'post_image_dto.g.dart';

@JsonSerializable()
class PostImageDto {
  final int id;
  final String url;
  final String originalName;
  final String mimeType;

  PostImageDto({
    required this.id,
    required this.url,
    required this.originalName,
    required this.mimeType,
  });

  factory PostImageDto.fromJson(Map<String, dynamic> json) => _$PostImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostImageDtoToJson(this);
}
