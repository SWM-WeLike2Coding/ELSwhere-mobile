import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/widgets/stock_price_graph.dart';
import 'package:flutter/material.dart';

class StockPriceGraphView extends StatefulWidget {
  const StockPriceGraphView({super.key});

  @override
  State<StockPriceGraphView> createState() => _StockPriceGraphViewState();
}

class _StockPriceGraphViewState extends State<StockPriceGraphView> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void changeIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPeriodButton(0, '1개월'),
              _buildPeriodButton(1, '3개월'),
              _buildPeriodButton(2, '6개월'),
              _buildPeriodButton(3, '1년'),
              _buildPeriodButton(4, '3년'),
              _buildPeriodButton(5, '5년'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        IndexedStack(
          index: _selectedIndex,
          children: [
            StockPriceGraph(0),
            StockPriceGraph(1),
            StockPriceGraph(2),
            StockPriceGraph(3),
            StockPriceGraph(4),
            StockPriceGraph(5),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodButton(int index, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          changeIndex(index);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          fixedSize: const Size.fromWidth(63),
          backgroundColor: index == _selectedIndex ? AppColors.gray900 : AppColors.contentWhite,
          elevation: 0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text,
            style: textTheme.labelSmall!.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: index == _selectedIndex ? AppColors.contentWhite : AppColors.gray300,
            ),
          ),
        ),
      ),
    );
  }
}
