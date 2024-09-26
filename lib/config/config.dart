import 'package:dio/dio.dart';

const String appName = "ELSwhere";
const String errorMessage = "문제가 발생했습니다.";
const String callbackUrlScheme = "elswhere";

late final Dio dio;

late final String baseUrl;
late final String loginEndpoint;

late String accessToken;
late String refreshToken;
const Map<String, String> productType = {
  'STEP_DOWN': '스텝다운',
  'LIZARD': '리자드',
  'MONTHLY_PAYMENT': '월지급',
  'ETC': '기타유'
};