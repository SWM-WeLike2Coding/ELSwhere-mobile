import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:intl/intl.dart';

class StockIndexCardSwiper extends StatefulWidget {
  final List<String> stockIndex = [
    'KOSPI200', 'S&P500', 'EUROSTOXX50'
  ];
  final List<double> price = [
    1457.3, 22345.4, 5656.7
  ];
  final List<double> rate = [
    1.2, -3.4, 5.6
  ];

  StockIndexCardSwiper({super.key});

  @override
  State<StockIndexCardSwiper> createState() => _StockIndexCardSwiperState();
}

class _StockIndexCardSwiperState extends State<StockIndexCardSwiper> {
  final NumberFormat priceFormat = NumberFormat.decimalPattern();
  final NumberFormat percentageFormat = NumberFormat.percentPattern();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsetsAll8,
      child: Swiper(
        itemBuilder: (context, index) {
          return Row(
            children: [
              Text(
                widget.stockIndex[index],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  letterSpacing: -0.02,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                priceFormat.format(widget.price[index]),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: widget.rate[index] > 0 ? AppColors.contentRed : AppColors.mainBlue,
                  letterSpacing: -0.02,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                // percentageFormat.format(widget.rate[index]),
                '${widget.rate[index] > 0 ? '+' : ''}${widget.rate[index]}%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: widget.rate[index] > 0 ? AppColors.contentRed : AppColors.mainBlue,
                  letterSpacing: -0.02,
                ),
              ),
            ],
          );
        },
        itemCount: 3,
        autoplay: true,
        autoplayDelay: 5000,
        scrollDirection: Axis.vertical,
        axisDirection: AxisDirection.down,
        duration: 1000,
      )
    );
  }
}
