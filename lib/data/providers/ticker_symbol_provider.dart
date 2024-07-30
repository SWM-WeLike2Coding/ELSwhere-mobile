import 'package:dio/dio.dart';
import 'package:elswhere/data/models/dtos/response_ticker_symbol_dto.dart';
import 'package:elswhere/data/services/els_product_service.dart';
import 'package:flutter/material.dart';

class TickerSymbolProvider extends ChangeNotifier {
  List<ResponseTickerSymbolDto> _tickers = [];
  bool _isLoading = false;

  final ProductService _productService;

  TickerSymbolProvider(this._productService);

  List<ResponseTickerSymbolDto> get tickers => _tickers;
  bool get isLoading => _isLoading;

  Future<void> fetchTickers() async {
    _isLoading = true;
    // notifyListeners();

    try {
      final response = await _productService.fetchTickers();
      _tickers = response;
    } on DioException catch (error) {
      // DioException의 상세 정보 출력
      print('Error fetching tickers:');
      print('Request: ${error.requestOptions}');
      print('Response: ${error.response}');
      print('Error: ${error.message}');
      if (error.response != null) {
        print('Response data: ${error.response?.data}');
      }
    }catch (error) {
      print('Error fetching products: $error');
      // 에러 처리 로직 추가
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}