import 'package:flutter/material.dart';
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
  List<ResponseSingleProductDto> _interestingProducts = [];

  ResponseSingleProductDto? get product => _product;
  bool get isLoading => _isLoading;
  bool get isBookmarked => _isBookmarked;
  List<ResponseSingleProductDto> get interestingProducts => _interestingProducts;

  Future<void> fetchProduct(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await _productService.fetchProduct(id);
      final response = await _userService.getInterestedProducts();
      for (int i = 0; i < response.length; i++) {
        if (_product?.id == response[i].productId) {
          _isBookmarked = true;
          break;
        } else {
          _isBookmarked = false;
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

  Future<void> registerInterested(int id) async {
    _isBookmarked = true;
    notifyListeners();

    try {
      await _userService.registerInterestedProduct({'productId': id});
    } catch (error) {
      print('Error regiter interested product: $error');
      _isBookmarked = true;
    } finally {
      // _isBookmarked = false;
      notifyListeners();
    }
  }
}
