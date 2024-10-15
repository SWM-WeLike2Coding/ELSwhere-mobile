import 'package:elswhere/data/models/dtos/post/summarized_generic_post_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_page_summarized_generic_post_dto.g.dart';

@JsonSerializable()
class ResponsePageSummarizedGenericPostDto {
  final List<SummarizedGenericPostDto> content;
  final bool hasNext;
  final int totalPages;
  final int totalElements;
  final int page;
  final int size;
  final bool first;
  final bool last;

  ResponsePageSummarizedGenericPostDto({
    required this.content,
    required this.hasNext,
    required this.totalPages,
    required this.totalElements,
    required this.page,
    required this.size,
    required this.first,
    required this.last,
  });

  factory ResponsePageSummarizedGenericPostDto.fromJson(Map<String, dynamic> json) => _$ResponsePageSummarizedGenericPostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsePageSummarizedGenericPostDtoToJson(this);
}
