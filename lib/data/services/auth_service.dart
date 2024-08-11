import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/response_login_dto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class AuthService {
  static Future<ResponseLoginDto?> authenticateUser(String authUrl) async {
    try {
      Uri loginUrl = Uri.parse(authUrl);

      final result = await FlutterWebAuth2.authenticate(
        url: loginUrl.toString(),
        callbackUrlScheme: callbackUrlScheme,
      );

      final jsonResponse = Uri.parse(result).queryParameters;
      final response = ResponseLoginDto.fromJson(jsonResponse);
      // print('${response.accessToken} \n ${response.refreshToken}}');
      return response;
    } catch (e) {
      if (e is PlatformException && e.code == 'CANCELED') {
        print('로그인 취소');
      } else {
        print('에러 발생: $e');
      }
      return null;
    }
  }
}
