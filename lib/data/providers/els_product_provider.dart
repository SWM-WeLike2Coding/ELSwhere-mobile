import 'package:flutter/material.dart';
import 'package:retrofit/dio.dart';
import '../models/dtos/response_interesting_product_dto.dart';
import '../models/dtos/response_single_product_dto.dart';
import '../services/els_product_service.dart';
import '../services/user_service.dart';

class ELSProductProvider with ChangeNotifier {
  final ProductService _productService;
  final UserService _userService;

  ELSProductProvider(this._productService, this._userService);

  ResponseSingleProductDto? _product;
  bool _isLoading = false;
  bool _isBookmarked = false;
  int? _interestId;
  List<ResponseInterestingProductDto> _interestingProducts = [];

  ResponseSingleProductDto? get product => _product;
  bool get isLoading => _isLoading;
  bool get isBookmarked => _isBookmarked;
  int? get interestedId => _interestId;
  List<ResponseInterestingProductDto> get interestingProducts => _interestingProducts;

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

  Future<void> registerInterested(int id) async {
    _isBookmarked = true;
    notifyListeners();

    try {
      HttpResponse response = await _userService.registerInterestedProduct({'productId': id});
      _interestId = response.data['id'];
      _interestingProducts = await _userService.getInterestedProducts();
    } catch (error) {
      print('Error regiter interested product: $error');
      _isBookmarked = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteFromInterested() async {
    _isBookmarked = false;
    notifyListeners();

    try {
      await _userService.deleteInterestedProduct(_interestId!);
      _interestingProducts = await _userService.getInterestedProducts();
    } catch (error) {
      print('Error delete interested product: $error');
      _isBookmarked = true;
    } finally {
      notifyListeners();
    }
  }
}
