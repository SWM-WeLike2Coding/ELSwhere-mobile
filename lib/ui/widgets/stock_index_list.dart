import 'package:card_swiper/card_swiper.dart';
import 'package:elswhere/data/providers/ticker_symbol_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/app_resource.dart';
import '../../data/models/dtos/response_ticker_symbol_dto.dart';

class StockIndexList extends StatefulWidget {
  const StockIndexList({super.key});

  @override
  State<StockIndexList> createState() => _StockIndexListItemState();
}

class _StockIndexListItemState extends State<StockIndexList> {
  final NumberFormat priceFormat = NumberFormat.decimalPattern();
  final NumberFormat percentageFormat = NumberFormat.percentPattern();

  @override
  Widget build(BuildContext context) {
    return Consumer<TickerSymbolProvider>(
      builder: (context, tickerSymbolProvider, child) {
        if (tickerSymbolProvider.isLoading && tickerSymbolProvider.stockIndex.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (tickerSymbolProvider.stockIndex.isEmpty) {
          return const Center(child: Text('준비 중입니다.'));
        } else {
          print(tickerSymbolProvider.tickers.runtimeType);
          List<String> stockIndexList = tickerSymbolProvider.stockIndex;
          List<double> priceList = tickerSymbolProvider.price;
          List<double> rateList = tickerSymbolProvider.rate;


          return Column(
            children: [
              ...stockIndexList.asMap().entries.map((entry) {
                int index = entry.key;
                String stockIndex = entry.value;
                Color getColor(double rate) {
                  if (rate > 0) {
                    return Color(0xFFEE5648);
                  } else if (rate < 0) {
                    return Color(0xFF3181F7);
                  } else {
                    return AppColors.textGray;
                  }
                }

                return Column(
                  children: [
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(
                          stockIndex,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.18,
                            letterSpacing: -0.28,
                            color: Color(0xFF000000),
                          ),
                        ),
                        Spacer(),
                        Text(
                          priceFormat.format(priceList[index]),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14, 
                            height: 1.18,
                            letterSpacing: -0.28,
                            color: getColor(rateList[index]),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          '${rateList[index] > 0
                              ? '+'
                              : ''}${tickerSymbolProvider.rate[index]
                              .toStringAsPrecision(2)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.18,
                            letterSpacing: -0.24,
                            color: getColor(rateList[index]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    if (index != stockIndexList.length - 1) SizedBox(height: 16,),
                  ],
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }
}
