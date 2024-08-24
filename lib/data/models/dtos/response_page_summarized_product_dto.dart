import 'package:json_annotation/json_annotation.dart';
import 'summarized_product_dto.dart';

part 'response_page_summarized_product_dto.g.dart';

@JsonSerializable()
class ResponsePageSummarizedProductDto {
  final List<SummarizedProductDto> content;
  final bool hasNext;
  final int totalPages;
  final int totalElements;
  final int page;
  final int size;
  final bool first;
  final bool last;

  ResponsePageSummarizedProductDto({
    required this.content,
    required this.hasNext,
    required this.totalPages,
    required this.totalElements,
    required this.page,
    required this.size,
    required this.first,
    required this.last,
  });

  factory ResponsePageSummarizedProductDto.fromJson(Map<String, dynamic> json) =>
      _$ResponsePageSummarizedProductDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ResponsePageSummarizedProductDtoToJson(this);
}
