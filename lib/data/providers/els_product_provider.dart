import 'package:dio/dio.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/models/dtos/user_like_product_dto.dart';
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
  SummarizedUserHoldingDto? _holdingProduct;
  bool _isLoading = false;
  bool _isBookmarked = false;
  bool _isLiked = false;
  bool _isHeld = false;
  int? _interestId;
  int? _holdingId;
  List<ResponseInterestingProductDto> _interestingProducts = [];
  List<UserLikeProductDto> _likeProducts = [];
  List<int> _compareId = [];
  List<ResponseSingleProductDto> _compareProducts = [];
  Map<String, YahooFinanceResponse>? _stockPrices;

  ResponseSingleProductDto? get product => _product;
  SummarizedUserHoldingDto? get holdingProduct => _holdingProduct;
  bool get isLoading => _isLoading;
  bool get isBookmarked => _isBookmarked;
  bool get isLiked => _isLiked;
  int? get interestedId => _interestId;
  int? get holdingId => _holdingId;
  bool get isHeld => _isHeld;
  List<ResponseInterestingProductDto> get interestingProducts => _interestingProducts;
  List<UserLikeProductDto> get likeProducts => _likeProducts;
  List<int> get compareId => _compareId;
  List<ResponseSingleProductDto> get compareProducts => _compareProducts;
  Map<String, YahooFinanceResponse>? get stockPrices => _stockPrices;

  Future<bool> fetchProduct(int id) async {
    _isLiked = false;
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

      for (int i = 0; i < _likeProducts.length; i++) {
        print('id값: ${_product!.id}, ${_likeProducts[i].id}');
        if (_product?.id == _likeProducts[i].id) {
          _isLiked = true;
          break;
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
    return _product != null;
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

  Future<bool> fetchStockPrices() async {
    // fetchProduct로 _product가 있어야만 해당 상품에서 조회가 가능
    bool success = true;
    _isLoading = true;
    notifyListeners();
    try {
      _stockPrices = await _yFinanceService.fetchStockPrices(_product!.equityTickerSymbols);
    } catch (e) {
      print('주가 가져오기 실패: $e');
      success = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  bool checkisHeld(List<SummarizedUserHoldingDto> holdingProducts) {
    bool success = true;
    try {
      _isHeld = false;
      _holdingId = null;
      _holdingProduct = null;
      for (SummarizedUserHoldingDto product in holdingProducts) {
        if (product.productId == _product!.id) {
          _holdingId = product.holdingId;
          _holdingProduct = product;
          _isHeld = true;
        }
      }
    } catch (e) {
      print("무슨 오류인가?: $e");
      _holdingId = null;
      _isHeld = false;
      success = false;
    } finally {
      notifyListeners();
    }
    print('$_isHeld, 성공?: $success');
    return success;
  }

  Future<bool> fetchLikeProducts() async {
    bool success = true;
    _isLoading = true;

    try {
      final httpResponse = await _userService.fetchLikeProducts();
      final response = httpResponse.response;
      if (response.statusCode == 200) {
        _likeProducts = httpResponse.data;
      } else {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      print("좋아요 상품 불러오기 실패: $e");
      success = false;
    } finally {
      _isLoading = false;
    }
    return success;
  }

  Future<bool> postProductLike(int id) async {
    bool success = true;

    try {
      final httpResponse = await _productService.postProductLike(id);
      final response = httpResponse.response;
      if (response.statusCode != 200 || !await fetchLikeProducts()) {
        success = false;
        throw Exception("Error Code: ${response.statusCode}, ${response.statusMessage}");
      }
      _isLiked = true;
    } catch (e) {
      print("상품 좋아요 실패: $e");
    }
    return success;
  }

  Future<bool> deleteProductLike(int id) async {
    bool success = true;

    try {
      final httpResponse = await _productService.deleteProductLike(id);
      final response = httpResponse.response;
      if (response.statusCode != 200 || !await fetchLikeProducts()) {
        success = false;
        throw Exception("Error Code: ${response.statusCode}, ${response.statusMessage}");
      }
      _isLiked = false;
    } catch (e) {
      print("상품 좋아요 실패: $e");
    }
    return success;
  }
}
