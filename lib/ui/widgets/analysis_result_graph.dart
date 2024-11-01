import 'dart:math';

import 'package:elswhere/config/app_resource.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalysisResultGraph extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final double prob;
  final double height;
  double scaler = 1;
  final String barMessage;
  final String bottomTitle;

  AnalysisResultGraph({
    super.key,
    required this.data,
    required this.prob,
    required this.height,
    this.scaler = 1,
    required this.barMessage,
    required this.bottomTitle,
  });

  @override
  State<AnalysisResultGraph> createState() => _AnalysisResultGraphState();
}

class _AnalysisResultGraphState extends State<AnalysisResultGraph> {
  double maxY = 100;
  late double scaler;
  late String barMessage;
  late String bottomTitle;
  late double height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barMessage = widget.barMessage;
    scaler = widget.scaler;
    bottomTitle = widget.bottomTitle;
    height = widget.height;
  }

  // LineChartBarData 생성 함수
  LineChartBarData createLineChartBarData(List<Map<String, dynamic>> data, String yKey, Color color) {
    final spots = data
        .map((point) => FlSpot(
              point['probability'] * scaler,
              point[yKey].toDouble(),
            ))
        .toList();
    maxY = max(maxY, _findMaxY(spots));
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartData _getMultiLineChartData() {
    List<LineChartBarData> lineBarsData = [
      createLineChartBarData(widget.data, 'is_redempted_1_count', Colors.red),
      createLineChartBarData(widget.data, 'is_redempted_0_count', Colors.blue),
    ];
    double padding = 30;
    return LineChartData(
      minX: 0,
      // maxX: 100,
      minY: 0,
      maxY: maxY + padding,
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: false),
      lineBarsData: lineBarsData,
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(bottomTitle),
          sideTitles: SideTitles(
              reservedSize: 20,
              interval: 10,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if ((meta.max != value && meta.max - value <= 5) || (meta.min != value && value - meta.min <= 5)) return Container();
                return Text('${value.toInt()}');
              }),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 18,
          axisNameWidget: const Text('상품 개수'),
          sideTitles: SideTitles(
            reservedSize: 30,
            interval: maxY / 4,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if ((meta.max != value && meta.max - value <= 10) || (meta.min != value && value - meta.min <= 10)) return Container();
              return Text('${value.toInt()}');
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            int dataIndex = 0;

            return touchedSpots.map((touchedSpot) {
              final index = touchedSpots.indexOf(touchedSpot);
              final title = ['수익 실현 상품 개수:', '원금 손실 상품 개수:'][index];
              final color = [Colors.red, Colors.blue][index];

              final item = LineTooltipItem(
                '',
                const TextStyle(),
                children: [
                  if (dataIndex == 0)
                    TextSpan(
                      text: '$barMessage: ${touchedSpot.x.toStringAsFixed(2)}\n',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  TextSpan(
                    text: '$title:\n${lineBarsData[dataIndex].spots[min(touchedSpot.spotIndex, lineBarsData[dataIndex].spots.length - 1)].y.toInt()}개',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
              dataIndex++;
              return item;
            }).toList();
          },
        ),
      ),
      extraLinesData: ExtraLinesData(horizontalLines: [], verticalLines: [
        VerticalLine(
          x: widget.prob,
          color: Colors.green[700],
          strokeWidth: 2,
          dashArray: [8, 4], // 점선 스타일 (선 길이, 공백 길이)
          label: VerticalLineLabel(
            show: true,
            alignment: widget.prob < 50 ? Alignment.topRight : Alignment.topLeft,
            labelResolver: (line) => '현재 상품의 $barMessage: ${widget.prob.toStringAsFixed(2)}',
            style: textTheme.M_16.copyWith(color: Colors.green[700], fontWeight: FontWeight.w700),
          ),
        ),
      ]),
    );
  }

  double _findMaxY(List<FlSpot> probabilityData) {
    final result = probabilityData.map((data) => data.y).reduce((a, b) => a > b ? a : b);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          child: LineChart(
            _getMultiLineChartData(),
            curve: Curves.bounceInOut,
          ),
        ),
      ],
    );
  }
}
