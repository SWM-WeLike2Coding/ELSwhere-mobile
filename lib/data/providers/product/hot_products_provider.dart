import 'dart:developer';

import 'package:elswhere/data/models/dtos/product/summarized_product_dto.dart';
import 'package:elswhere/data/services/product/els_product_service.dart';
import 'package:flutter/material.dart';

class HotProductsProvider extends ChangeNotifier {
  final ProductService _productService;

  bool _isLoading = false;

  List<SummarizedProductDto> _hotProducts = [];

  HotProductsProvider(this._productService);

  bool get isLoading => _isLoading;
  List<SummarizedProductDto> get hotProducts => _hotProducts;

  Future<bool> fetchDailyHotProducts() async {
    bool success = true;
    _isLoading = true;
    _hotProducts = [];
    notifyListeners();

    try {
      final httpResponse = await _productService.fetchDailyHotProducts();
      final response = httpResponse.response;

      if (response.statusCode == 200) {
        _hotProducts = httpResponse.data;
        for (var e in _hotProducts) {
          print(e.name);
        }
      } else {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      success = false;
      _hotProducts = [];
      log('일일 인기 상품 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }
}
