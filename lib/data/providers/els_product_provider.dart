import 'package:dio/dio.dart';
import 'package:elswhere/data/services/yfinance_service.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/dio.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';
import '../models/dtos/response_interesting_product_dto.dart';
import '../models/dtos/response_single_product_dto.dart';
import '../services/els_product_service.dart';
import '../services/user_service.dart';

class ELSProductProvider with ChangeNotifier {
  final ProductService _productService;
  final UserService _userService;
  final YFinanceService _yFinanceService;

  ELSProductProvider(this._productService, this._userService, this._yFinanceService);

  ResponseSingleProductDto? _product;
  bool _isLoading = false;
  bool _isBookmarked = false;
  int? _interestId;
  List<ResponseInterestingProductDto> _interestingProducts = [];
  List<int> _compareId = [];
  List<ResponseSingleProductDto> _compareProducts = [];
  Map<String, YahooFinanceResponse>? _stockPrices;

  ResponseSingleProductDto? get product => _product;
  bool get isLoading => _isLoading;
  bool get isBookmarked => _isBookmarked;
  int? get interestedId => _interestId;
  List<ResponseInterestingProductDto> get interestingProducts => _interestingProducts;
  List<int> get compareId => _compareId;
  List<ResponseSingleProductDto> get compareProducts => _compareProducts;
  Map<String, YahooFinanceResponse>? get stockPrices => _stockPrices;

  Future<void> fetchProduct(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await _productService.fetchProduct(id);
      print(_product!.equities);
      // final response = await _userService.getInterestedProducts();
      for (int i = 0; i < _interestingProducts.length; i++) {
        if (_product?.id == _interestingProducts[i].productId) {
          _isBookmarked = true;
          _interestId = _interestingProducts[i].interestId;
          print(_interestId);
          break;
        } else {
          _isBookmarked = false;
          _interestId = null;
        }
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching product: $error');
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInterested() async {
    print("관심 상품 가져옵니다.");
    _isLoading = true;
    try {
      final response = await _userService.getInterestedProducts();
      _interestingProducts = response;
    } catch (error) {
      print('Error fetching Interesting products: $error');
      // 에러 처리 로직 추가
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerInterested(int id) async {
    _isBookmarked = true;
    notifyListeners();

    try {
      HttpResponse response = await _userService.registerInterestedProduct({'productId': id});
      _interestId = response.data['id'];
      _interestingProducts = await _userService.getInterestedProducts();
    } catch (error) {
      if (error is DioException && error.response != null) {
        print('Error details: ${error.response?.data}');
      }
      print('Error regiter interested product: $error');
      _isBookmarked = false;
      return false;
    } finally {
      notifyListeners();
    }
    return true;
  }

  Future<bool> deleteFromInterested() async {
    _isBookmarked = false;
    notifyListeners();

    try {
      await _userService.deleteInterestedProduct(_interestId!);
      _interestingProducts = await _userService.getInterestedProducts();
    } catch (error) {
      print('Error delete interested product: $error');
      _isBookmarked = true;
      return false;
    } finally {
      notifyListeners();
    }
    return true;
  }

  Future<void> fetchCompareProduct(int id1, int id2) async {
    _isLoading = true;
    try {
      _compareProducts.clear();
      _compareProducts.add(await _productService.fetchProduct(id1));
      _compareProducts.add(await _productService.fetchProduct(id2));
    } catch (error) {
      print('Error fetching product: $error');
      _compareProducts = [];
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchStockPrices() async { // fetchProduct로 _product가 있어야만 해당 상품에서 조회가 가능
    _isLoading = true;
    notifyListeners();
    try {
      _stockPrices = await _yFinanceService.fetchStockPrices(_product!.equityTickerSymbols);
    } catch (e) {
      print('주가 가져오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
