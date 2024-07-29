const String appName = "ELSwhere";
const String errorMessage = "문제가 발생했습니다.";
const String callbackUrlScheme = "elswhere";
const String googleIconPath = "assets/icons/icon_google.svg";
late final String baseUrl;
late String accessToken;
late final String loginEndpoint;
const Map<String, String> productType = {
  'STEP_DOWN': '스텝다운',
  'LIZARD': '리자드',
  'MONTHLY_PAYMENT': '월지급',
  'ETC': '기타유'
};