import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/response_user_info_dto.dart';
import 'package:elswhere/data/services/user_service.dart';
import 'package:elswhere/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  final UserService _userService;
  ResponseUserInfoDto? _userInfo;
  bool _isLoading = false;

  ResponseUserInfoDto? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  bool get checkAuthenticated => _userInfo != null;

  String _nickname = "";

  String getNickname() => _nickname;


  UserInfoProvider(this._userService);

  Future<bool> checkUser() async {
    try {
      final httpResponse = await _userService.checkUser();
      final response = httpResponse.response;
      final data = response.data;
      final userInfo = ResponseUserInfoDto.fromJson(data);

      _userInfo = userInfo;
      _nickname = _userInfo!.nickname;
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

  Future<bool> changeNickname(String nickname) async {
    try {
      final response = await _userService.changeNickname({'nickname': nickname});
      if (response.response.statusCode == 200) {
        print('Nickname changed successfully');
        _nickname = nickname;
        notifyListeners();
        return true;
      } else {
        print('Failed to change nickname: ${response.response.statusCode}');
        print('Response body: ${response.response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      return false;
      }
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
    return false;
  }

  Future<bool> checkNicknamePossible(String nickname) async {
    try {
      final response = await _userService.checkNicknamePossible({'nickname': nickname});
      if (response.response.statusCode == 200) {
        print('Nickname can be used');
        notifyListeners();
        return true;
      } else {
        print('Failed to check nickname: ${response.response.statusCode}');
        print('Response body: ${response.response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        return false;
      }
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
    return false;
  }

  Future<bool> logout(BuildContext context) async {
    print(_userInfo);

    try {
      final response = await _userService.logout();
      if (response.response.statusCode == 200) {
        _userInfo = null;
        notifyListeners();
        await storage.deleteAll();

        print(_userInfo);
        print('로그아웃됨');
        return true;
      } else {
        print('로그아웃에 실패했습니다.');
        return false;
      }
    } catch (e) {
      print('오류가 발생했습니다. : $e');
      return false;
    }
  }

  Future<bool> quitService(BuildContext context) async {
    try {
      final response = await _userService.deleteUser();
      if (response.response.statusCode == 200) {
        print('Service Quitted successfully');
        _userInfo = null;
        notifyListeners();
        await storage.deleteAll();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return true;
      } else {
        print('Failed to quit: ${response.response.statusCode}');
        print('Response body: ${response.response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        return false;
      }
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
    return false;
  }
}