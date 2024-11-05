import 'package:dio/dio.dart';

const String appName = "ELSwhere";
const String packageName = "com.welike2coding.elswhere";
const String appleAppId = "6714471331";
const String errorMessage = "문제가 발생했습니다.";
const String callbackUrlScheme = "elswhere";

late final Dio dio;

late final String baseUrl;
late final String loginEndpoint;

String localLatestVersion = '0.0.0';
String remoteLatestVersion = '0.0.0';

late String accessToken;
late String refreshToken;
const Map<String, String> productType = {
  'STEP_DOWN': '스텝다운',
  'LIZARD': '리자드',
  'MONTHLY_PAYMENT': '월지급',
  'ETC': '기타유',
};

final List<String> items = [
  '최신순',
  '낙인순',
  '수익률순',
  '마감일순',
];

final Map<String, String> itemsMap = {
  '최신순': 'latest',
  '낙인순': 'knock-in',
  '수익률순': 'profit',
  '마감일순': 'deadline',
};

List<Map<String, dynamic>> aiData = [{}];
List<Map<String, dynamic>> mcsData = [{}];
