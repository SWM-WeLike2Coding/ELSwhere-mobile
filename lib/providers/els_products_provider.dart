import 'package:flutter/material.dart';
import '../models/dtos/summarized_product_dto.dart';
import '../services/els_product_service.dart';

class ELSProductsProvider with ChangeNotifier {
  List<SummarizedProductDto> _products = [];
  bool _isLoading = false;
  bool _hasNext = true;
  int _page = 0;
  final int _size = 20;

  final ProductService _productService;

  ELSProductsProvider(this._productService);

  List<SummarizedProductDto> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasNext => _hasNext;

  Future<void> fetchProducts(String type) async {
    _isLoading = true;
    notifyListeners();

    try {
      final responsePage = await _productService.fetchProducts(type, _page, _size);
      _products += responsePage.content;
      _hasNext = responsePage.hasNext;
      _page++;
    } catch (error) {
      print('Error fetching products: $error');
      // 에러 처리 로직 추가
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetProducts() {
    _products = [];
    _page = 0;
    _hasNext = false;
    notifyListeners();
  }
}
