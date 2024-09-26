import 'package:elswhere/data/models/dtos/response_issuer_dto.dart';
import 'package:elswhere/data/services/els_product_service.dart';
import 'package:flutter/material.dart';

class IssuerProvider extends ChangeNotifier {
  List<ResponseIssuerDto> _issuer = [];

  final ProductService _productService;

  IssuerProvider(this._productService);

  List<ResponseIssuerDto> get issuer => _issuer;

  Future<void> fetchIssuers() async {
    try {
      final response = await _productService.fetchIssuers();
      _issuer = response;
    } catch (error) {
      print('Issuer Error fetching products: $error');
      // 에러 처리 로직 추가
    } finally {
      notifyListeners();
    }
  }
}
