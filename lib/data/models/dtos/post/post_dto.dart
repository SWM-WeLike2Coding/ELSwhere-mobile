import 'package:json_annotation/json_annotation.dart';

part 'post_dto.g.dart';

@JsonSerializable()
class PostDto {
  final String title;
  final String content;
  final String type;
  final String? imagePath;
  final DateTime? createdAt;

  PostDto({
    required this.title,
    required this.content,
    required this.type,
    this.createdAt,
    this.imagePath,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}