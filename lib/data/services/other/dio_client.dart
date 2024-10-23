import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';

class DioClient {
  static Dio createDio({bool needAuth = true}) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (needAuth) options.headers["Authorization"] = accessToken;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.statusCode == 200) {
          print('응답(Type: ${response.data.runtimeType}): $response');
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
