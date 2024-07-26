import 'package:dio/dio.dart';
import 'package:elswhere/resources/config.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Authorization"] = accessToken;
    super.onRequest(options, handler);
  }
}
