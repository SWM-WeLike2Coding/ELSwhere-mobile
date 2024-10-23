import 'dart:developer';

import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/user/response_login_dto.dart';
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
      final path = Uri.parse(result).path;
      late final ResponseLoginDto response;

      if (path == 'terms') {
        log('회원 가입');
      }
      if (jsonResponse.containsKey('error')) {
        throw Exception;
      } else if (jsonResponse.containsKey('signup_token')) {
        final signupToken = jsonResponse['signup_token']!;
        response = ResponseLoginDto(accessToken: '', refreshToken: signupToken);
      } else {
        response = ResponseLoginDto.fromJson(jsonResponse);
      }
      // print('${response.accessToken} \n ${response.refreshToken}}')containsKey('signup_token');
      return response;
    } catch (e) {
      if (e is PlatformException && e.code == 'CANCELED') {
        log('로그인 취소');
      } else {
        log('에러 발생: $e');
      }
      return null;
    }
  }
}
