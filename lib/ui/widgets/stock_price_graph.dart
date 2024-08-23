import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/stock_price.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';
import 'package:fl_chart/fl_chart.dart';

class StockPriceGraph extends StatefulWidget {
  int period;

  StockPriceGraph(this.period, {super.key});

  @override
  _StockPriceGraphState createState() => _StockPriceGraphState();
}

class _StockPriceGraphState extends State<StockPriceGraph> {
  int selectedPeriod = 0;
  List<List<FlSpot>> stockData = [];
  final DateFormat format = DateFormat().addPattern('yyyy년 MM월 dd일');
  final DateTime now = DateTime.now();
  Map<String, List<StockPrice>>? prices;

  // 기간별 데이터 불러오기
  void fetchStockData(int period, Map<String, YahooFinanceResponse> response) {
    DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
    DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    DateTime threeYearsAgo = DateTime(now.year - 3, now.month, now.day);

    prices = response.map((equity, yResponse) {
      final convert = yResponse.candlesData.map((e) => StockPrice(date: e.date, price: e.close)).toList();
      return MapEntry(equity, convert);
    });

    switch (period) {
      case 0:
        prices = prices?.map((equity, stockPrice) {
          final location = stockPrice.indexWhere((element) => isDateMatchingWithPastPeriods(element.date, oneMonthAgo));
          stockPrice = stockPrice.sublist(location);
          return MapEntry(equity, stockPrice);
        });
        break;
      case 1:
        prices = prices?.map((equity, stockPrice) {
          final location = stockPrice.indexWhere((element) => isDateMatchingWithPastPeriods(element.date, threeMonthsAgo));
          stockPrice = stockPrice.sublist(location);
          return MapEntry(equity, stockPrice);
        });
        break;
      case 2:
        prices = prices?.map((equity, stockPrice) {
          final location = stockPrice.indexWhere((element) => isDateMatchingWithPastPeriods(element.date, sixMonthsAgo));
          stockPrice = stockPrice.sublist(location);
          return MapEntry(equity, stockPrice);
        });
        break;
      case 3:
        prices = prices?.map((equity, stockPrice) {
          final location = stockPrice.indexWhere((element) => isDateMatchingWithPastPeriods(element.date, oneYearAgo));
          stockPrice = stockPrice.sublist(location);
          return MapEntry(equity, stockPrice);
        });
        break;
      case 4:
        prices = prices?.map((equity, stockPrice) {
          final location = stockPrice.indexWhere((element) => isDateMatchingWithPastPeriods(element.date, threeYearsAgo));
          stockPrice = stockPrice.sublist(location);
          return MapEntry(equity, stockPrice);
        });
        break;
    }

    stockData = prices!.values.map((prices) {
      return convertStockDataToRelativeFlSpots(prices.toList());
    }).toList();
  }

  // 주가 데이터를 상대적인 퍼센트 값으로 변환
  List<FlSpot> convertStockDataToRelativeFlSpots(List<StockPrice> stockData) {
    final double startPrice = stockData.first.price;
    final DateTime startDate = stockData.first.date;
    int cnt = 0;

    return stockData.map((data) {
      final double x = (data.date.difference(startDate).inDays.toDouble());
      final double y = cnt++ == 0 ? 100 : (data.price / startPrice) * 100; // 시작 값을 100%로 설정
      return FlSpot(x, y);
    }).toList();
  }

  bool isDateMatchingWithPastPeriods(DateTime date, DateTime dateToCompare) {
    return !date.isBefore(dateToCompare);
  }

  double findMinY(List<List<FlSpot>> stockData) {
    final result = stockData
        .expand((data) => data)
        .map((data) => data.y)
        .reduce((a, b) => a < b ? a : b);
    return result;
  }

  double findMaxY(List<List<FlSpot>> stockData) {
    final result = stockData
        .expand((data) => data)
        .map((data) => data.y)
        .reduce((a, b) => a > b ? a : b);
    return result;
  }

  LineChartData getMultiLineChartData(Map<String, List<StockPrice>> stockDataMap) {
    List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
    int index = 0;
    List<LineChartBarData> lineBarsData = stockData.map((entry) {
      return LineChartBarData(
        spots: entry,
        isCurved: true,
        color: colors[index++],
        barWidth: 3,
        belowBarData: BarAreaData(show: false),
        dotData: const FlDotData(show: false,), // 점 표시
      );
    }).toList();

    double minY = findMinY(stockData);
    double maxY = findMaxY(stockData);
    double padding = (maxY - minY) * 0.2; // 20% 여유를 둠

    return LineChartData(
      minY: minY - padding,
      maxY: maxY + padding,
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: false),
      lineBarsData: lineBarsData,
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 35,
            interval: <double>[10.5, 31, 63, 365/3, 365][selectedPeriod],
            showTitles: true,
            getTitlesWidget: (value, meta) {
              DateTime date = stockDataMap.values.first.first.date.add(Duration(days: value.toInt()));
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(text: '${DateFormat().addPattern('yyyy년').format(date)}\n', style: textTheme.labelSmall!.copyWith(color: Colors.black),),
                      TextSpan(text: DateFormat().addPattern('MM월 dd일').format(date), style: textTheme.labelSmall!.copyWith(color: Colors.black),),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 50,
            interval: (maxY - minY + padding * 2) / 3,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${value.toStringAsFixed(1)}%',
                  style: textTheme.labelSmall,
                ),
              );
            }
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            final DateTime startDate = stockDataMap.values.first.first.date;
            bool isFirst = false;

            return touchedSpots.map((touchedSpot) {
              final DateTime touchedDate = startDate.add(Duration(days: touchedSpot.x.toInt()));
              final index = touchedSpots.indexOf(touchedSpot);
              final equity = prices!.keys.toList()[index];
              final color = [Colors.red, Colors.blue, Colors.green, Colors.yellow][index];

              final item = LineTooltipItem(
                '',
                const TextStyle(),
                children: [
                  if (!isFirst) TextSpan(
                    text: '${format.format(touchedDate)}\n',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: '$equity: ${touchedSpot.y.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
              isFirst = true;
              return item;
            }).toList();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedPeriod = widget.period;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.stockPrices == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (!provider.isLoading && provider.stockPrices == null) {
          return const Center(child: Text("오류가 발생했습니다."));
        } else {
          fetchStockData(selectedPeriod, provider.stockPrices!);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: stockData.isEmpty
                      ? const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber),
                            SizedBox(width: 8),
                            Text('주가를 불러오는데 실패했습니다.'),
                          ],
                        ),
                      )
                      : LineChart(getMultiLineChartData(prices!)),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                children: prices!.keys.map((equity) {
                  final colorIndex = prices!.keys.toList().indexOf(equity);
                  final color = [Colors.red, Colors.blue, Colors.green, Colors.yellow][colorIndex];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        equity,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
