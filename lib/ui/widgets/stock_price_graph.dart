import 'dart:math';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/stock_price.dart';
import 'package:elswhere/data/providers/product/els_product_provider.dart';
import 'package:elswhere/utils/utils.dart';
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
  List<Duration> intervalDurations = const [Duration(days: 5), Duration(days: 15), Duration(days: 31), Duration(days: 61), Duration(days: 182), Duration(days: 305)];
  final DateFormat format = DateFormat().addPattern('yyyy년 MM월 dd일');
  final DateTime now = DateTime.now().getJustDay();
  Map<String, List<StockPrice>>? prices;
  late DateTime startDate;
  late DateTime endDate;

  // 기간별 데이터 불러오기
  void fetchStockData(int period, Map<String, YahooFinanceResponse> response) {
    DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
    DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    DateTime threeYearsAgo = DateTime(now.year - 3, now.month, now.day);
    DateTime fiveYearsAgo = DateTime(now.year - 5, now.month, now.day);

    endDate = now;

    prices = response.map((equity, yResponse) {
      final convert = yResponse.candlesData.map((e) => StockPrice(date: e.date, price: e.close)).toList();
      return MapEntry(equity, convert);
    });

    switch (period) {
      case 0:
        startDate = oneMonthAgo;
        break;
      case 1:
        startDate = threeMonthsAgo;
        break;
      case 2:
        startDate = sixMonthsAgo;
        break;
      case 3:
        startDate = oneYearAgo;
        break;
      case 4:
        startDate = threeYearsAgo;
        break;
      case 5:
        startDate = fiveYearsAgo;
        break;
      default:
        startDate = fiveYearsAgo;
        break;
    }

    prices = prices?.map((equity, stockPrice) {
      final location = stockPrice.indexWhere((element) => isDateMatchingWithPastPeriods(element.date.getJustDay(), startDate));
      stockPrice = stockPrice.sublist(location);
      return MapEntry(equity, stockPrice);
    });

    stockData = prices!.values.map((prices) {
      return convertStockDataToRelativeFlSpots(prices.toList());
    }).toList();

    final maxLength = stockData.map((e) => e.length).reduce(max);
    for (int i = 0; i < prices!.length; i++) {
      int difference = maxLength - stockData[i].length;
      for (int j = 0; j < difference; j++) {
        stockData[i].insert(0, FlSpot.nullSpot);
      }
    }
  }

  // 주가 데이터를 상대적인 퍼센트 값으로 변환
  List<FlSpot> convertStockDataToRelativeFlSpots(List<StockPrice> stockData) {
    final double startPrice = stockData.first.price;
    final DateTime stockStartDate = stockData.first.date.getJustDay();
    final double difference = stockStartDate.difference(startDate).inDays.toDouble();
    int cnt = 0;

    return stockData.map((data) {
      final double x = (data.date.getJustDay().difference(stockStartDate).inDays.toDouble()) + difference;
      final double y = cnt++ == 0 ? 100 : (data.price / startPrice) * 100; // 시작 값을 100%로 설정
      return FlSpot(x, y);
    }).toList();
  }

  bool isDateMatchingWithPastPeriods(DateTime date, DateTime dateToCompare) {
    return !date.isBefore(dateToCompare);
  }

  double findMinX(List<List<FlSpot>> stockData) {
    return stockData.expand((data) => data).map((data) => data.x).where((e) => e.isFinite).reduce(min);
  }

  double findMaxX(List<List<FlSpot>> stockData) {
    return stockData.expand((data) => data).map((data) => data.x).where((e) => e.isFinite).reduce(max);
  }

  double findMinY(List<List<FlSpot>> stockData) {
    return stockData.expand((data) => data).map((data) => data.y).where((e) => e.isFinite).reduce(min);
  }

  double findMaxY(List<List<FlSpot>> stockData) {
    return stockData.expand((data) => data).map((data) => data.y).where((e) => e.isFinite).reduce(max);
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
        dotData: const FlDotData(
          show: false,
        ), // 점 표시
      );
    }).toList();

    double minX = findMinX(stockData);
    double maxX = findMaxX(stockData);

    double minY = findMinY(stockData);
    double maxY = findMaxY(stockData);
    double padding = (maxY - minY) * 0.2; // 20% 여유를 둠

    return LineChartData(
      minX: minX,
      maxX: maxX,
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
            interval: (maxX - minX) / 3,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              DateTime date = stockDataMap.values.first.first.date.add(Duration(days: value.toInt())).getJustDay();
              DateTime minDate = stockDataMap.values.first.first.date.getJustDay();
              DateTime maxDate = stockDataMap.values.last.last.date.getJustDay();

              if (value == minX || value == maxX || (minDate.difference(date).abs().inDays > (maxX - minX) / 6 && maxDate.difference(date).abs().inDays > (maxX - minX) / 6)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${DateFormat().addPattern('yyyy년').format(date)}\n',
                          style: textTheme.labelSmall!.copyWith(color: Colors.black),
                        ),
                        TextSpan(
                          text: DateFormat().addPattern('MM월 dd일').format(date),
                          style: textTheme.labelSmall!.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 55,
            interval: (maxY - minY + padding * 2) / 3,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value == minY - padding || maxY + padding == value || ((value - minY).abs() > padding && (maxY - value).abs() > padding)) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value >= 0 ? '${value.toStringAsFixed(1)}%' : '',
                    style: textTheme.labelSmall,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            final DateTime startDate = stockDataMap.values.first.first.date;
            int stockIndex = 0;

            return touchedSpots.map((touchedSpot) {
              final DateTime touchedDate = startDate.add(Duration(days: touchedSpot.x.toInt()));
              final index = touchedSpots.indexOf(touchedSpot);
              final equity = prices!.keys.toList()[index];
              final color = [Colors.red, Colors.blue, Colors.green, Colors.yellow][index];
              double spotY = lineBarsData[stockIndex].spots[touchedSpot.spotIndex].y;
              if (spotY.isNaN) spotY = 100.0;

              final item = LineTooltipItem(
                '',
                const TextStyle(),
                children: [
                  if (stockIndex == 0)
                    TextSpan(
                      text: '${format.format(touchedDate)}\n',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  TextSpan(
                    text: '$equity:\n${spotY.toStringAsFixed(2)}%',
                    // text: '$equity:\n${touchedSpot.y.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
              stockIndex++;
              return item;
            }).toList();
          },
        ),
      ),
      extraLinesData: ExtraLinesData(
        extraLinesOnTop: false,
        horizontalLines: [
          HorizontalLine(
            y: 100.0,
            color: AppColors.gray500,
            dashArray: [8, 4],
            // label: HorizontalLineLabel(
            //   labelResolver: (p0) => '100.0%',
            //   show: true,
            //   alignment: Alignment.centerRight,
            //   style: textTheme.SM_12,
            // ),
          ),
        ],
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
