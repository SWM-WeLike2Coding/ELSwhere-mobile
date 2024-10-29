import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';

class AIResultConverter {
  static AIResultConverter? _instance;

  AIResultConverter._internal();

  static AIResultConverter getInstance() {
    _instance ??= AIResultConverter._internal();
    return _instance!;
  }

  static Map<String, dynamic>? getResultMap(double? safetyScore) {
    if (safetyScore == null) return null;

    Map<String, dynamic> map;
    map = switch (safetyScore) {
      < 0.22 => {'label': LABEL_VERY_HIGH_RISK, 'color': AppColors.veryHighRisk},
      >= 0.22 && < 0.65 => {'label': LABEL_HIGH_RISK, 'color': AppColors.highRisk},
      >= 0.65 && < 0.77 => {'label': LABEL_MODERATE_RISK, 'color': AppColors.moderateRisk},
      >= 0.77 => {'label': LABEL_LOW_RISK, 'color': AppColors.lowRisk},
      double() => throw Exception('위험도가 잘못 입력되었습니다.'),
    };
    return map;
  }
}
