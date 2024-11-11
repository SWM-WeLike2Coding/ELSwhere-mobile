import 'dart:developer';

import 'package:elswhere/data/models/dtos/product/summarized_product_dto.dart';
import 'package:elswhere/data/services/product/els_product_service.dart';
import 'package:flutter/material.dart';

class AIProductProvider extends ChangeNotifier {
  final ProductService _productService;

  AIProductProvider(this._productService);

  List<SummarizedProductDto> _aiRecommendationProducts = [];

  List<SummarizedProductDto> get aiRecommendationProducts => _aiRecommendationProducts;

  final bool _isLoading = false;

  Future<bool> fetchAIRecommendationProducts() async {
    bool success = false;

    try {
      final httpResponse = await _productService.fetchAIRecommendationProducts();
      final response = httpResponse.response;
      if (response.statusCode == 200) {
        _aiRecommendationProducts = httpResponse.data;
        success = true;
      } else {
        _aiRecommendationProducts = [];
        throw Exception('Error Code: ${response.statusCode}\nError Message: ${response.statusMessage}');
      }
    } catch (e) {
      log('$e');
      success = false;
    }
    return success;
  }
}
