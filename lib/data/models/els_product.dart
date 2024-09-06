import 'package:json_annotation/json_annotation.dart';

part 'els_product.g.dart';

enum ELSType {
  stepDown,
  knockOut,
  lizard,
}


@JsonSerializable()
class ELSProduct {
  final List<String> assetNames; // 기초자산명
  final DateTime maturityDate; // 만기일
  final DateTime subscriptionStartDate; // 청약시작일
  final DateTime subscriptionEndDate; // 청약마감일
  final ELSType productType; // 상품종류 (스텝다운, 넉아웃, 리자드 등)
  final double couponRate; // 쿠폰금리
  final List<DateTime> earlyRedemptionEvaluationDates; // 조기상환평가일
  final double earlyRedemptionBarrier; // 조기상환배리어
  final double knockInBarrier; // 낙인배리어
  final String productCode; // 상품코드
  final String issuer; // 발행회사

  ELSProduct({
    required this.assetNames,
    required this.maturityDate,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.productType,
    required this.couponRate,
    required this.earlyRedemptionEvaluationDates,
    required this.earlyRedemptionBarrier,
    required this.knockInBarrier,
    required this.productCode,
    required this.issuer,
  });

  // JSON 직렬화
  factory ELSProduct.fromJson(Map<String, dynamic> json) =>
      _$ELSProductFromJson(json);
  Map<String, dynamic> toJson() => _$ELSProductToJson(this);
}
