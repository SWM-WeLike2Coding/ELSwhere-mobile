import 'package:json_annotation/json_annotation.dart';
import 'response_product_comparison_target_dto.dart';

part 'response_product_comparison_main_dto.g.dart';

@JsonSerializable()
class ResponseProductComparisonMainDto {
  final List<ResponseProductComparisonTargetDto> results;
  final List<ResponseProductComparisonTargetDto> target;

  ResponseProductComparisonMainDto({
    required this.results,
    required this.target,
  });

  factory ResponseProductComparisonMainDto.fromJson(Map<String, dynamic> json) =>
      _$ResponseProductComparisonMainDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseProductComparisonMainDtoToJson(this);
}
