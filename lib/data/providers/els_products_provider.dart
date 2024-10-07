import 'dart:convert';

import 'package:elswhere/data/models/dtos/request_product_search_dto.dart';
import 'package:elswhere/data/models/dtos/response_product_comparison_main_dto.dart';
import 'package:flutter/material.dart';
import '../models/dtos/summarized_product_dto.dart';
import '../services/els_product_service.dart';
import 'package:intl/intl.dart';

class ELSProductsProvider extends ChangeNotifier {
  List<SummarizedProductDto> _products = [];
  ResponseProductComparisonMainDto? _similarProducts;
  bool _isInit = true;
  bool _isLoading = false;
  bool _hasNext = true;
  int _page = 0;
  final int _size = 5000;
  final String status;

  final ProductService _productService;

  ELSProductsProvider(this._productService, this.status);

  List<SummarizedProductDto> get products => _products;
  ResponseProductComparisonMainDto? get similarProducts => _similarProducts;
  bool get isInit => _isInit;
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
    _isInit = true;
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
    final now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    resetProducts();
    _isInit = false;
    _isLoading = true;
    notifyListeners();
    try {
      final responsePage = await _productService.fetchFilteredProducts(_page, _size, body);
      for (var e in responsePage.content) {
        print(e.equities.split('/').length);
      }
      _products = responsePage.content.where((e) => status == 'on' ? e.subscriptionEndDate.compareTo(now) >= 0 : e.subscriptionEndDate.compareTo(now) < 0).toList();
    } catch (error) {
      print('Error fetching products: $error');
      // 에러 처리 로직 추가
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<SummarizedProductDto> convertToSummarizedProductDtoList(List<dynamic> data) {
    return data.map((item) => SummarizedProductDto(
      id: item['id'] as int,
      issuer: item['issuer'] as String,
      name: item['name'] as String,
      productType: item['productType'] as String,
      equities: item['equities'] as String,
      yieldIfConditionsMet: (item['yieldIfConditionsMet'] as num).toDouble(),
      knockIn: item['knockIn'] as int?,
      subscriptionStartDate: DateFormat('yyyy-MM-dd').parse(item['subscriptionStartDate'] as String),
      subscriptionEndDate: DateFormat('yyyy-MM-dd').parse(item['subscriptionEndDate'] as String),
    )).toList();
  }

  Future<void> fetchProductByNumber(int number) async {
    resetProducts();
    _isInit = false;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _productService.fetchProductByNumber(number);
      final tempProductList = convertToSummarizedProductDtoList(response.data);

      for (var tempProduct in tempProductList) {
        _products.add(tempProduct);
      }
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
        _products.sort((a, b) => b.id.compareTo(a.id));
        if (similarProducts?.results != null) similarProducts!.results.sort((a, b) => b.id.compareTo(a.id));
      case '낙인순':
        _products.sort((a, b) {
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
        _products.sort((a, b) {
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
