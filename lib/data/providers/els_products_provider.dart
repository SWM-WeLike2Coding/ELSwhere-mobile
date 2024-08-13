import 'package:elswhere/data/models/dtos/request_product_search_dto.dart';
import 'package:elswhere/data/models/dtos/response_product_comparison_main_dto.dart';
import 'package:elswhere/data/models/dtos/response_product_comparison_target_dto.dart';
import 'package:flutter/material.dart';
import '../models/dtos/summarized_product_dto.dart';
import '../services/els_product_service.dart';

class ELSProductsProvider extends ChangeNotifier {
  List<SummarizedProductDto> _products = [];
  ResponseProductComparisonMainDto? _similarProducts;
  bool _isLoading = false;
  bool _hasNext = true;
  int _page = 0;
  final int _size = 1000;
  final String status;

  final ProductService _productService;

  ELSProductsProvider(this._productService, this.status);

  List<SummarizedProductDto> get products => _products;
  ResponseProductComparisonMainDto? get similarProducts => _similarProducts;
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
      _products += responsePage.content.where((e) => status == 'on'
          ? e.subscriptionEndDate.compareTo(DateTime.now()) >= 0
          : e.subscriptionEndDate.compareTo(DateTime.now()) < 0).toList();
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

  void sortProducts(String type) {
    switch (type) {
      case '최신순':
        products.sort((a, b) => b.id.compareTo(a.id));
        if (similarProducts?.results != null) similarProducts!.results.sort((a, b) => b.id.compareTo(a.id));
      case '낙인순':
        products.sort((a, b) {
          final x = a.knockIn ?? 999;
          final y = b.knockIn ?? 999;
          final result = x.compareTo(y);
          if (result == 0) return b.id.compareTo(a.id);
          return result;
        });
        if (similarProducts?.results != null) {
          similarProducts!.results.sort((a, b) {
            final x = a.knockIn ?? 999;
            final y = b.knockIn ?? 999;
            final result = x.compareTo(y);
            if (result == 0) return b.id.compareTo(a.id);
            return result;
          });
        }
      case '수익률순':
        products.sort((a, b) {
          final result = b.yieldIfConditionsMet.compareTo(a.yieldIfConditionsMet);
          if (result == 0) return b.id.compareTo(a.id);
          return result;
        });
        if (similarProducts?.results != null) {
          similarProducts!.results.sort((a, b) {
            final result = b.yieldIfConditionsMet.compareTo(a.yieldIfConditionsMet);
            if (result == 0) return b.id.compareTo(a.id);
            return result;
          });
        }
    }
  }

  Future<bool> fetchSimilarProducts(int id) async {
    bool isSuccessful = false;
    _similarProducts = null;
    _isLoading = true;
    notifyListeners();

    try {
      final httpResponse = await _productService.fetchSimilarProducts(id);
      final response = httpResponse.response;
      final int statusCode = response.statusCode!;
      final ResponseProductComparisonMainDto body = ResponseProductComparisonMainDto.fromJson(response.data);

      if (statusCode == 200) {
        _similarProducts = body;
        isSuccessful = true;
      } else {
        throw Exception;
      }

    } catch (e) {
      print('비슷한 상품 불러오기 오류 : $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return isSuccessful == true;
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