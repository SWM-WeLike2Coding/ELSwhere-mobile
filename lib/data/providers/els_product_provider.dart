import 'package:flutter/material.dart';
import '../models/dtos/response_single_product_dto.dart';
import '../services/els_product_service.dart';

class ELSProductProvider with ChangeNotifier {
  final ProductService _productService;

  ELSProductProvider(this._productService);

  ResponseSingleProductDto? _product;
  bool _isLoading = false;

  ResponseSingleProductDto? get product => _product;
  bool get isLoading => _isLoading;

  Future<void> fetchProduct(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await _productService.fetchProduct(id);
    } catch (error) {
      print('Error fetching product: $error');
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
