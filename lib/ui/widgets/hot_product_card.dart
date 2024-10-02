import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/models/dtos/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/els_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class HotProductCard extends StatelessWidget {
  final int rank;
  final SummarizedProductDto product;
  final cardHeight = 105.0;

  const HotProductCard({
    super.key,
    required this.rank,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final dayDifference = product.subscriptionEndDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _onItemTapped(context);
      },
      child: SizedBox(
        height: cardHeight,
        child: Padding(
          padding: edgeInsetsAll16,
          child: Row(
            children: [
              Text(
                '$rank',
                style: textTheme.SM_16.copyWith(color: rank == 1 ? AppColors.contentRed : AppColors.mainBlue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.backgroundGray,
                          child: Padding(
                            padding: edgeInsetsAll4,
                            child:
                                Assets.issuerIconMap[product.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[product.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.contentBlack,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              // const SizedBox(height: 8),
                              SizedBox(
                                height: 16,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final textPainter = TextPainter(
                                      text: TextSpan(
                                        text: product.equities,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      maxLines: 1,
                                      textDirection: ui.TextDirection.ltr,
                                    )..layout(maxWidth: constraints.maxWidth);

                                    final isOverflowing = textPainter.didExceedMaxLines;

                                    return isOverflowing
                                        ? Marquee(
                                            text: product.equities,
                                            style: const TextStyle(color: AppColors.gray400, fontSize: 14),
                                            scrollAxis: Axis.horizontal,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            startAfter: const Duration(seconds: 1),
                                            blankSpace: 30,
                                            velocity: 30.0,
                                            accelerationDuration: const Duration(seconds: 1),
                                            accelerationCurve: Curves.linear,
                                            fadingEdgeEndFraction: 0.7,
                                            decelerationDuration: const Duration(milliseconds: 500),
                                            decelerationCurve: Curves.easeOut,
                                          )
                                        : Text(
                                            product.equities,
                                            style: const TextStyle(color: AppColors.gray400, fontSize: 14),
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${productType[product.productType]!}형',
                            style: const TextStyle(color: AppColors.mainBlue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '연 ${product.yieldIfConditionsMet}%',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.02,
                                fontSize: 18,
                                color: AppColors.contentRed,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${dayDifference != 0 ? '${dayDifference.abs()}일 ${dayDifference < 0 ? '전' : '후'}' : '오늘'} 마감',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 14,
                                color: AppColors.gray600,
                              ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context) async {
    final productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    await productProvider.fetchMonteCarloResponse(product.id);
    final result = [
      await productProvider.fetchProduct(product.id),
      await productProvider.fetchStockPrices(),
      productProvider.checkisHeld(userProvider.holdingProducts!),
    ].every((result) => result);

    Navigator.pop(context);

    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ELSProductDetailScreen()),
      );
    } else {
      Fluttertoast.showToast(msg: MSG_ERR_FETCH, toastLength: Toast.LENGTH_SHORT);
    }
  }
}
