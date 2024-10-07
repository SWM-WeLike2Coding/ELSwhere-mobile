import 'package:elswhere/data/models/dtos/post-service/post_file_dto.dart';
import 'package:elswhere/data/models/dtos/post-service/post_image_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_single_generic_post_dto.g.dart';

@JsonSerializable()
class ResponseSingleGenericPostDto {
  final int id;
  final String title;
  final String body;
  final String author;
  final String createdAt;
  final List<PostImageDto>? images;
  final List<PostFileDto>? files;
  final bool mine;

  ResponseSingleGenericPostDto({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.createdAt,
    required this.images,
    required this.files,
    required this.mine,
  });

  factory ResponseSingleGenericPostDto.fromJson(Map<String, dynamic> json) => _$ResponseSingleGenericPostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseSingleGenericPostDtoToJson(this);
}
