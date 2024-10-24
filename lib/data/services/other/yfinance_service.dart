import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class YFinanceService {
  static YFinanceService? _instance;
  late final YahooFinanceDailyReader _yahooFinanceDailyReader;

  YFinanceService._internal() {
    _yahooFinanceDailyReader = const YahooFinanceDailyReader();
  }

  static YFinanceService getInstance() {
    _instance ??= YFinanceService._internal();
    return _instance!;
  }

  Future<Map<String, YahooFinanceResponse>?> fetchStockPrices(Map<String, String> tickers) async {
    final now = DateTime.now();
    final Map<String, YahooFinanceResponse> responses = {};
    try {
      final List<Future<MapEntry<String, YahooFinanceResponse>>> futures = tickers.entries.map((entry) async {
        final [equity, ticker] = [entry.key, entry.value];
        final response = await _yahooFinanceDailyReader.getDailyDTOs(ticker, startDate: now.subtract(const Duration(days: 365 * 5)));
        return MapEntry<String, YahooFinanceResponse>(equity, response);
      }).toList();

      final results = await Future.wait(futures);
      responses.addEntries(results);
      print('야후 응답 : ${responses.values}');
      return responses;
    } catch (e) {
      print('불러오는 데 에러가 발생했습니다. $e');
    }
    return null; // 에러 발생해도 빈 맵 반환
  }
}
