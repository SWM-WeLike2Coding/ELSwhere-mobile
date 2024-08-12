import 'package:elswhere/data/models/dtos/response_ticker_symbol_dto.dart';
import 'package:elswhere/data/services/els_product_service.dart';
import 'package:flutter/material.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class TickerSymbolProvider extends ChangeNotifier {
  List<ResponseTickerSymbolDto> _tickers = [];
  final List<String> _stockIndex = ['KOSPI200', 'S&P500', 'EUROSTOXX50', 'NIKKEI225', 'HSCEI'];
  final List<String> _tickerSymbol = ['KS200', 'GSPC', 'STOXX50E', 'N225', 'HSCE'];
  final List<double> _price = List.filled(5, 0);
  final List<double> _rate = List.filled(5, 0);
  final int _length = 5;
  final _yfinanceReader = const YahooFinanceDailyReader();
  bool _isLoading = false;

  final ProductService _productService;

  TickerSymbolProvider(this._productService);

  List<ResponseTickerSymbolDto> get tickers => _tickers;
  List<String> get stockIndex => _stockIndex;
  List<String> get tickerSymbol => _tickerSymbol;
  List<double> get rate => _rate;
  List<double> get price => _price;
  int get length => _length;
  bool get isLoading => _isLoading;

  Future<void> fetchTickers() async {
    _isLoading = true;
    try {
      final response = await _productService.fetchTickers();
      _tickers = response;
    } catch (error) {
      print('Error fetching products: $error');
      // 에러 처리 로직 추가
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStockPrices() async {
    try {
      for (int i = 0; i < _length; i++) {
        final String stock = _tickerSymbol[i];
        final now = DateTime.now();
        final twoDaysAgo = now.subtract(const Duration(days: 2));
        final response = await _yfinanceReader.getDailyDTOs('^$stock', startDate: twoDaysAgo);
        print('${_tickerSymbol[i]}: ${response.candlesData}');
        final candlesData = response.candlesData;
        if (candlesData.isNotEmpty) {
          final day1ago = candlesData.last.close;
          final day2ago = candlesData.first.close;
          _price[i] = day1ago;
          _rate[i] = (day1ago - day2ago) / day2ago * 100.0;
          // print(_tickerSymbol[i]);
          // print(_price[i]);
          // print(_rate[i]);
        }
      }
    } catch (e) {
      print('가져오는 데 오류가 발생했습니다. : $e');
    }
  }
}