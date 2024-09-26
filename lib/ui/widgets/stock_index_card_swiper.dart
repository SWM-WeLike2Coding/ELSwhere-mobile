import 'package:card_swiper/card_swiper.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/ticker_symbol_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StockIndexCardSwiper extends StatefulWidget {
  const StockIndexCardSwiper({super.key});

  @override
  State<StockIndexCardSwiper> createState() => StockIndexCardSwiperState();
}

class StockIndexCardSwiperState extends State<StockIndexCardSwiper> {
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
          return IgnorePointer(
            child: Padding(
              padding: edgeInsetsAll8,
              child: Swiper(
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 15,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: SvgPicture.asset(
                            Assets.indicesFlagIconMap[tickerSymbolProvider.stockIndex[index]]!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Text(
                        tickerSymbolProvider.stockIndex[index],
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          letterSpacing: -0.02,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        priceFormat.format(tickerSymbolProvider.price[index]),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          color: tickerSymbolProvider.rate[index] > 0
                              ? AppColors.contentRed
                              : (tickerSymbolProvider.rate[index] != 0
                              ? AppColors.mainBlue
                              : AppColors.textGray),
                          letterSpacing: -0.02,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        // percentageFormat.format(tickerSymbolProvider.rate[index]),
                        '${tickerSymbolProvider.rate[index] > 0
                            ? '+'
                            : ''}${tickerSymbolProvider.rate[index]
                            .toStringAsPrecision(2)}%',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          color: tickerSymbolProvider.rate[index] > 0
                              ? AppColors.contentRed
                              : (tickerSymbolProvider.rate[index] != 0
                              ? AppColors.mainBlue
                              : AppColors.textGray),
                          letterSpacing: -0.02,
                        ),
                      ),
                    ],
                  );
                },
                itemCount: tickerSymbolProvider.length,
                autoplay: true,
                autoplayDelay: 4000,
                scrollDirection: Axis.vertical,
                axisDirection: AxisDirection.down,
                duration: 1000,
              ),
            ),
          );
        }
      },
    );
  }
}
