import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/product/summarized_product_dto.dart';
import 'package:elswhere/data/models/dtos/user/request_create_holding_dto.dart';
import 'package:elswhere/data/models/dtos/user/response_investment_type_dto.dart';
import 'package:elswhere/data/models/dtos/user/response_login_dto.dart';
import 'package:elswhere/data/models/dtos/user/response_user_info_dto.dart';
import 'package:elswhere/data/models/dtos/user/summarized_user_holding_dto.dart';
import 'package:elswhere/data/services/user/user_service.dart';
import 'package:elswhere/ui/screens/other/login_screen.dart';
import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  final UserService _userService;
  ResponseUserInfoDto? _userInfo;
  bool _isLoading = false;
  ResponseInvestmentTypeDto? _investmentTypeInfo;
  List<SummarizedUserHoldingDto>? _holdingProducts;
  List<SummarizedProductDto> _personalizedProducts = [];
  String? _signupToken;
  int _totalHoldingPrice = 0;
  int _profitAndLossPrice = 0;
  bool _surveyParticipationStatus = false;
  int _page = 0;
  bool _isInit = true;
  final int _size = 5000;

  ResponseUserInfoDto? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  bool get checkAuthenticated => _userInfo != null;
  ResponseInvestmentTypeDto? get investmentTypeInfo => _investmentTypeInfo;
  List<SummarizedUserHoldingDto>? get holdingProducts => _holdingProducts ?? [];
  List<SummarizedProductDto> get personalizedProducts => _personalizedProducts ?? [];
  String? get signupToken => _signupToken;
  int get totalHoldingPrice => _totalHoldingPrice;
  int get profitAndLossPrice => _profitAndLossPrice;
  bool get surveyParticipationStatus => _surveyParticipationStatus;
  bool get isInit => _isInit;

  set signupToken(String? signupToken) => _signupToken = signupToken;

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
      _investmentTypeInfo = null;

      return false;
    } catch (e) {
      print('Unexpected error: $e');
      _investmentTypeInfo = null;
      return false;
    }
  }

  Future<void> fetchPersonalizedProducts(String type) async {
    try {
      final responsePage = await _userService.fetchPersonalizedProducts(type, _page, _size);
      _personalizedProducts += responsePage.content;
      // _hasNext = responsePage.hasNext;
      _page++;
    } catch (error) {
      print('Error fetching personalized products: $error');
      _personalizedProducts = [];
      _surveyParticipationStatus = false;
      // 에러 처리 로직 추가
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sortPeronalizedProducts(String type) {
    switch (type) {
      case '최신순':
        _personalizedProducts.sort((a, b) => b.id.compareTo(a.id));
      case '낙인순':
        _personalizedProducts.sort((a, b) {
          final x = a.knockIn ?? 999;
          final y = b.knockIn ?? 999;
          final result = x.compareTo(y);
          if (result == 0) return b.id.compareTo(a.id);
          return result;
        });
      case '수익률순':
        _personalizedProducts.sort((a, b) {
          final result = b.yieldIfConditionsMet.compareTo(a.yieldIfConditionsMet);
          if (result == 0) return b.id.compareTo(a.id);
          return result;
        });
      case '마감일순':
        _personalizedProducts.sort((a, b) {
          final result = a.subscriptionEndDate.compareTo(b.subscriptionEndDate);
          if (result == 0) return b.id.compareTo(a.id);
          return result;
        });
    }
  }

  void resetPersonalizedProducts() {
    _personalizedProducts = [];
    _page = 0;
    notifyListeners();
  }

  Future<void> refreshProducts(String type) async {
    _isInit = true;
    resetPersonalizedProducts();
    fetchPersonalizedProducts(type);
    notifyListeners();
  }

  Future<bool> getSurveyParticipationStatus() async {
    try {
      final response = await _userService.getSurveyParticipationStatus();

      final message = response.data['message'] as String;
      if (message == 'ok') {
        _surveyParticipationStatus = true;
      } else {
        _surveyParticipationStatus = false;
      }
      notifyListeners();
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Error fetching User: Resource not found (404)');
      } else {
        print('Error fetching User: ${e.message}, ${e.response?.data['errorMessage'] ?? ''}');
      }
      _surveyParticipationStatus = false;
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      _surveyParticipationStatus = false;
      return false;
    }
  }

  Future<bool> checkUser() async {
    try {
      final httpResponse = await _userService.checkUser().timeout(const Duration(seconds: 10));
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
        print('Error fetching User: ${e.message}, ${e.response?.data['errorMessage'] ?? ''}');
      }
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }

  Future<bool> signUp() async {
    bool success = true;

    try {
      final httpResponse = await _userService.signUp(_signupToken!, {"agreed": true});
      final response = httpResponse.response;

      if (response.statusCode == 200) {
        final data = httpResponse.data as Map<String, dynamic>;

        accessToken = data['accessToken'];
        refreshToken = data['refreshToken'];
        storage.write(key: 'ACCESS_TOKEN', value: accessToken);
        storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
        // log(accessToken);
        // log(refreshToken);
      } else {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }

      _signupToken = null;
    } catch (e) {
      log('약관 동의 실패: $e');
      success = false;
    }
    return success;
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

  Future<bool> changeInvestmentType(int investmentExperience, int riskPropensity, int repaymentOption, int minPreferredReturn) async {
    try {
      String investmentExperienceStr = '';
      String riskPropensityStr = '';
      String repaymentOptionStr = '';

      if (investmentExperience == 1) {
        investmentExperienceStr = "YES";
      } else {
        investmentExperienceStr = "NO";
      }

      if (riskPropensity == 0) {
        riskPropensityStr = "EXTREME_RISK";
      } else if (riskPropensity == 1) {
        riskPropensityStr = "HIGH_RISK";
      } else if (riskPropensity == 2){
        riskPropensityStr = "MEDIUM_RISK";
      } else {
        riskPropensityStr = "LOW_RISK";
      }

      if (repaymentOption == 0) {
        repaymentOptionStr = 'EARLY_REPAYMENT';
      } else if (repaymentOption == 1){
        repaymentOptionStr = 'MATURITY_REPAYMENT';
      } else {
        repaymentOptionStr = 'NO_PREFERENCE';
      }

      final response = await _userService.sendNewInvestmentType({
        'investmentExperience': investmentExperienceStr,
        'riskPropensity': riskPropensityStr,
        'repaymentOption': repaymentOptionStr,
        'minPreferredReturn': minPreferredReturn,
      });
      if (response.response.statusCode == 200) {
        print('Investment Type changed successfully');
        _investmentTypeInfo =
            ResponseInvestmentTypeDto(investmentExperience: investmentExperienceStr, riskPropensity: riskPropensityStr, repaymentOption: repaymentOptionStr, minPreferredReturn: minPreferredReturn);
        _surveyParticipationStatus = true;
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

  Future<int> checkNicknamePossible(String nickname) async {
    try {
      final response = await _userService.checkNicknamePossible({'nickname': nickname});
      if (response.response.statusCode == 200) {
        print('Nickname can be used');
        notifyListeners();
        return 0;
      } else {
        print('Failed to check nickname: ${response.response.statusCode}');
        print('Response body: ${response.response.data}');
        return 1;
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        if (e.response?.data['code'] == 'BindingFailedException') {
          return 1;
        } else {
          return 2;
        }
      }
    } catch (e) {
      print('Unexpected error: $e');
      return 1;
    }
    return 1;
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
