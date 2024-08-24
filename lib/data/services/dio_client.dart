import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] = accessToken;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.statusCode == 200) {
          print('응답 + $response');
          return handler.next(response);
        } else {
          print('Error!');
        }
      },
      onError: (DioException e, handler) {
        print(e);
        // 에러 처리
        return handler.next(e);
      },
    ));

    return dio;
  }
}