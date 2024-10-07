import 'package:elswhere/data/models/dtos/post-service/post_file_dto.dart';
import 'package:elswhere/data/models/dtos/post-service/post_image_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summarized_generic_post_dto.g.dart';

@JsonSerializable()
class SummarizedGenericPostDto {
  final int id;
  final String title;
  final String author;
  final String createdAt;
  final String body;
  final List<PostImageDto>? images;
  final List<PostFileDto>? files;

  SummarizedGenericPostDto({
    required this.id,
    required this.title,
    required this.author,
    required this.createdAt,
    required this.body,
    required this.images,
    required this.files,
  });

  factory SummarizedGenericPostDto.fromJson(Map<String, dynamic> json) => _$SummarizedGenericPostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SummarizedGenericPostDtoToJson(this);
}
