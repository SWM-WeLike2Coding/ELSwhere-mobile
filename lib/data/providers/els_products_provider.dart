import 'package:elswhere/data/models/dtos/request_product_search_dto.dart';
import 'package:flutter/material.dart';
import '../models/dtos/summarized_product_dto.dart';
import '../services/els_product_service.dart';

class ELSProductsProvider extends ChangeNotifier {
  List<SummarizedProductDto> _products = [];
  bool _isLoading = false;
  bool _hasNext = true;
  int _page = 0;
  final int _size = 20;
  final String status;

  final ProductService _productService;

  ELSProductsProvider(this._productService, this.status);

  List<SummarizedProductDto> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasNext => _hasNext;

  Future<void> initProducts(String type) async {
    try {
      final responsePage = await _productService.fetchProducts(status, type, _page, _size);
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

  Future<void> refreshProducts(String type) async {
    resetProducts();
    fetchProducts(type);
  }

  Future<void> fetchProducts(String type) async {
    _isLoading = true;
    notifyListeners();

    try {
      final responsePage = await _productService.fetchProducts(status, type, _page, _size);
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

  // 07-22 상품 검색 구현하면서 try 함수
  Future<void> fetchFilteredProducts(RequestProductSearchDto body) async {
    resetProducts();
    _isLoading = true;
    notifyListeners();
    try {
      final responsePage = await _productService.fetchFilteredProducts(body);
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

class ELSOnSaleProductsProvider extends ELSProductsProvider {
  ELSOnSaleProductsProvider(ProductService productService) : super(productService, 'on');
}

class ELSEndSaleProductsProvider extends ELSProductsProvider {
  ELSEndSaleProductsProvider(ProductService productService) : super(productService, 'end');
}