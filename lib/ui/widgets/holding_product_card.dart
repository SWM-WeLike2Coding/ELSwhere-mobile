import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/compare_product_screen.dart';
import 'package:elswhere/ui/screens/els_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class HoldingProductCard extends StatefulWidget {
  SummarizedUserHoldingDto product;

  HoldingProductCard({
    super.key,
    required this.product,
  });

  @override
  State<HoldingProductCard> createState() => _ELSProductCardState();
}

class _ELSProductCardState extends State<HoldingProductCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late ELSProductProvider productProvider;
  late UserInfoProvider userProvider;
  late final SummarizedUserHoldingDto product;
  bool isSelected = false;
  final cardHeight = 105.0;
  bool isOnSale = false;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  void onItemTapped() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final result = [
      await productProvider.fetchProduct(product.productId),
      await productProvider.fetchStockPrices(),
      productProvider.checkisHeld(userProvider.holdingProducts!),
    ].every((result) => result);

    if (mounted) Navigator.pop(context);

    if (result) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ELSProductDetailScreen()),
        );
      }
    } else {
      Fluttertoast.showToast(msg: '정보를 불러오는데 실패했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final productsProvider = Provider.of<ELSOnSaleProductsProvider>(context, listen: false);
    final dayDifference = product.nextRepaymentEvaluationDate.difference(DateTime.now()).inDays;
    final format = NumberFormat.decimalPattern('ko');
    final price = '${format.format(product.price)}원';
    final nowPrice = product.price * product.yieldIfConditionsMet / 100;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onItemTapped,
      child: SizedBox(
        height: cardHeight,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.backgroundGray,
                      child: Padding(
                        padding: edgeInsetsAll4,
                        child: Assets.issuerIconMap[widget.product.issuer] != null
                            ? SvgPicture.asset(Assets.issuerIconMap[widget.product.issuer]!)
                            : const Icon(Icons.question_mark, color: AppColors.contentBlack),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
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
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            height: 16,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final textPainter = TextPainter(
                                  text: TextSpan(
                                    text: price,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  maxLines: 1,
                                  textDirection: ui.TextDirection.ltr,
                                )..layout(maxWidth: constraints.maxWidth);

                                final isOverflowing = textPainter.didExceedMaxLines;

                                return isOverflowing
                                    ? Marquee(
                                        text: price,
                                        style: const TextStyle(color: Color(0xFF686F74), fontSize: 14),
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
                                        price,
                                        style: const TextStyle(color: Color(0xFF686F74), fontSize: 14),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('다음 상환평가일',
                              style: textTheme.labelSmall!.copyWith(
                                color: const Color(0xFFACB2B5),
                              )),
                          const SizedBox(
                            width: 4,
                          ),
                          Text('$dayDifference일 후',
                              style: textTheme.labelSmall!.copyWith(
                                color: const Color(0xFF595E62),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${format.format(nowPrice.toInt())}원',
                            style: textTheme.labelSmall!.copyWith(
                              color: const Color(0xFF434648),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${product.recentAndInitialPriceRatio == 0 ? '' : product.recentAndInitialPriceRatio > 0 ? '+' : '-'}${product.yieldIfConditionsMet.toStringAsPrecision(2)}%',
                          style: textTheme.labelSmall!.copyWith(
                            color: product.recentAndInitialPriceRatio == 0
                                ? AppColors.contentGray
                                : product.recentAndInitialPriceRatio > 0
                                    ? AppColors.contentRed
                                    : AppColors.mainBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${productType[product.productType]!}형',
                      style: textTheme.labelSmall!.copyWith(
                        color: AppColors.mainBlue,
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  // Widget _buildHiddenButtons(BuildContext context, ELSProductProvider productProvider, ELSProductsProvider productsProvider) {
  //   return Positioned(
  //     right: 0,
  //     child: Container(
  //       height: cardHeight,
  //       width: 190 - (isOnSale ? 0 : 91),
  //       child: Row(
  //         children: [
  //           Padding(
  //             padding: edgeInsetsAll8,
  //             child: GestureDetector(
  //               child: Container(
  //                 width: 75,
  //                 decoration: const BoxDecoration(
  //                   borderRadius: borderRadiusCircular10,
  //                   color: AppColors.backgroundGray,
  //                 ),
  //                 child: Padding(
  //                   padding: edgeInsetsAll16,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Icon(Icons.arrow_right_alt, color: AppColors.textGray,),
  //                       Text(
  //                         '자세히',
  //                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                           color: AppColors.textGray,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               onTap: () async {
  //                 showDialog(
  //                   context: context,
  //                   barrierDismissible: false,
  //                   builder: (BuildContext context) {
  //                     return const Center(
  //                       child: CircularProgressIndicator(),
  //                     );
  //                   },
  //                 );
  //
  //                 await productProvider.fetchProduct(product.id);
  //                 await productProvider.fetchStockPrices();
  //
  //                 // 로딩 다이얼로그 닫기
  //                 Navigator.of(context).pop();
  //
  //                 if (productProvider.product != null) {
  //                   // ELSDetailDialog.show(context, productProvider.product!);
  //                   Navigator.push(context, MaterialPageRoute(builder: (context) => ELSProductDetailScreen()));
  //                 }
  //                 onItemTapped();
  //               },
  //             ),
  //           ),
  //           if (isOnSale) Padding(
  //             padding: edgeInsetsAll8,
  //             child: GestureDetector(
  //               child: Container(
  //                 width: 75,
  //                 decoration: const BoxDecoration(
  //                   borderRadius: borderRadiusCircular10,
  //                   color: Color(0xFF434648),
  //                 ),
  //                 child: Padding(
  //                   padding: edgeInsetsAll16,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       const Icon(Icons.add, color: AppColors.contentWhite,),
  //                       Text(
  //                         '비교',
  //                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                           color: AppColors.contentWhite,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               onTap: () async {
  //                 productProvider.compareId.add(product.id);
  //                 if (productProvider.compareId.length == 2) {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => CompareProductScreen()),
  //                   );
  //                 } else {
  //                   setState(() {
  //                     nowComparing = !nowComparing;
  //                     if (checkCompare != null) {
  //                       checkCompare!(nowComparing, product);
  //                     }
  //                   });
  //                   final result = await productsProvider.fetchSimilarProducts(product.id);
  //                   if (!result) {
  //                     Fluttertoast.showToast(msg: '제품을 불러오는데 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
  //                   }
  //                 }
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
