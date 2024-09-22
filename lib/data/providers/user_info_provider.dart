import 'package:dio/dio.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/request_create_holding_dto.dart';
import 'package:elswhere/data/models/dtos/response_investment_type_dto.dart';
import 'package:elswhere/data/models/dtos/response_user_info_dto.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/services/user_service.dart';
import 'package:elswhere/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  final UserService _userService;
  ResponseUserInfoDto? _userInfo;
  bool _isLoading = false;
  ResponseInvestmentTypeDto? _investmentTypeInfo;
  List<SummarizedUserHoldingDto>? _holdingProducts;
  int _totalHoldingPrice = 0;
  int _profitAndLossPrice = 0;

  ResponseUserInfoDto? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  bool get checkAuthenticated => _userInfo != null;
  ResponseInvestmentTypeDto? get investmentTypeInfo => _investmentTypeInfo;
  List<SummarizedUserHoldingDto>? get holdingProducts => _holdingProducts ?? [];
  int get totalHoldingPrice => _totalHoldingPrice;
  int get profitAndLossPrice => _profitAndLossPrice;

  String _nickname = "";

  String getNickname() => _nickname;

  UserInfoProvider(this._userService);

  Future<bool> checkMyInvestmentType() async {
    try {
      _investmentTypeInfo = await _userService.getMyInvestmentType();

      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Error fetching Investment Type');
      } else {
        print('Error fetching Investment Type: ${e.message}');
      }
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }

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

  Future<bool> changeInvestmentType(int investmentExperience, int investmentPreferredPeriod, int riskTakingAbility) async {
    try {
      String investmentExperienceStr = '';
      String investmentPreferredPeriodStr = '';
      String riskTakingAbilityStr = '';

      if (investmentExperience == 1) {
        investmentExperienceStr = "YES";
      } else {
        investmentExperienceStr = "NO";
      }

      if (investmentPreferredPeriod == 0) {
        investmentPreferredPeriodStr = "LESS_THAN_A_YEAR";
      } else if (investmentPreferredPeriod == 1) {
        investmentPreferredPeriodStr = "A_YEAR_OR_TWO";
      } else {
        investmentPreferredPeriodStr = "MORE_THAN_THREE_YEARS";
      }

      if (riskTakingAbility == 0) {
        riskTakingAbilityStr = 'RISK_TAKING_TYPE';
      } else {
        riskTakingAbilityStr = 'STABILITY_SEEKING_TYPE';
      }

      final response = await _userService.sendNewInvestmentType({
        'investmentExperience': investmentExperienceStr,
        'investmentPreferredPeriod': investmentPreferredPeriodStr,
        'riskTakingAbility': riskTakingAbilityStr,
      });
      if (response.response.statusCode == 200) {
        print('Investment Type changed successfully');
        _investmentTypeInfo =
            ResponseInvestmentTypeDto(investmentExperience: investmentExperienceStr, investmentPreferredPeriod: investmentPreferredPeriodStr, riskTakingAbility: riskTakingAbilityStr);
        notifyListeners();
        return true;
      } else {
        print('Failed to change Investment Type : ${response.response.statusCode}');
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
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  Future<bool> fetchHoldingProducts() async {
    _isLoading = true;
    _totalHoldingPrice = _profitAndLossPrice = 0;
    _holdingProducts = null;

    try {
      final httpResponse = await _userService.fetchHoldingProducts();
      final response = httpResponse.response;
      if (response.statusCode == 200) {
        _holdingProducts = httpResponse.data;
        for (var product in _holdingProducts!) {
          double? priceRatio = product.recentAndInitialPriceRatio;
          _totalHoldingPrice += product.price.toInt();
          _profitAndLossPrice += priceRatio == null ? 0 : (product.price * product.yieldIfConditionsMet / 100).toInt();
        }
      } else {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      print("보유 상품 가져오기 실패: $e");
      _holdingProducts = null;
    } finally {
      _isLoading = false;
    }
    return _holdingProducts != null;
  }

  Future<bool> addHoldingProduct(RequestCreateHoldingDto data) async {
    _isLoading = true;
    bool success = true;
    notifyListeners();

    try {
      final httpResponse = await _userService.addHoldingProduct(data);
      final response = httpResponse.response;
      print('성공');
      if (response.statusCode != 200 || !await fetchHoldingProducts()) {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
      print('진짜 성공?');
    } catch (e) {
      success = false;
      print("보유 상품 추가 실패: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> deleteHoldingProduct(int id) async {
    bool success = true;
    _isLoading = true;

    try {
      final httpResponse = await _userService.deleteHoldingProduct(id);
      final response = httpResponse.response;
      if (response.statusCode != 200 || !await fetchHoldingProducts()) {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      print("보유 상품 삭제 실패: $e");
      success = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> updateHoldindProduct(int id, int price) async {
    bool success = true;
    _isLoading = true;

    try {
      final httpResponse = await _userService.updateHoldingProduct(id, price);
      final response = httpResponse.response;
      if (response.statusCode != 200 || !await fetchHoldingProducts()) {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      print("보유 상품 갱신 실패: $e");
      success = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }
}
