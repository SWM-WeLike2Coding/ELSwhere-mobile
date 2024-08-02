import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/services/api_interceptor.dart';
import 'package:retrofit/retrofit.dart';

part 'user_service.g.dart';

@RestApi(baseUrl: '')
abstract class UserService {
  factory UserService(Dio dio) {
    final _baseUrl = '$baseUrl/user-service';
    return _UserService(dio, baseUrl: _baseUrl);
  }

  @GET("/v1/user")
  Future<HttpResponse> checkUser();

  @PATCH("/v1/user/change/nickname")
  Future<HttpResponse> changeNickname(@Body() Map<String, dynamic> body);

  @DELETE("/v1/user")
  Future<HttpResponse> deleteUser();
}