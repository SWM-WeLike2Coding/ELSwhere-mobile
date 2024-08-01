import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elswhere/data/models/dtos/response_user_info_dto.dart';
import 'package:elswhere/data/services/user_service.dart';
import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  final UserService _userService;
  ResponseUserInfoDto? _userInfo;
  bool _isLoading = false;

  ResponseUserInfoDto? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  bool get checkAuthenticated => _userInfo != null;

  UserInfoProvider(this._userService);

  Future<bool> checkUser() async {
    try {
      final httpResponse = await _userService.checkUser();
      // print("HTTP: ${httpResponse.response.data}");
      final response = httpResponse.response;
      // print("RESPONSE: $response");
      final data = response.data;
      final statusCode = response.statusCode;
      // print("STATUS CODE: $statusCode\nDATA: $data");
      final userInfo = ResponseUserInfoDto.fromJson(data);
      // print("USER: $userInfo");

      _userInfo = userInfo;
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Error fetching User: Resource not found (404)');
      } else {
        print('Error fetching User: ${e.message}');
      }
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }
}