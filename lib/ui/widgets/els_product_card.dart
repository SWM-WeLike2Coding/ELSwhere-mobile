import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/ui/screens/compare_product_screen.dart';
import 'package:elswhere/ui/screens/els_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class ELSProductCard<T extends SummarizedProductDto> extends StatefulWidget {
  final T product;
  final int index;
  void Function(bool, int)? checkCompare;

  ELSProductCard({
    super.key,
    required this.product,
    required this.index,
    this.checkCompare,
  });


  @override
  State<ELSProductCard> createState() => _ELSProductCardState();
}

class _ELSProductCardState extends State<ELSProductCard> {
  bool isSelected = false;
  bool nowComparing = false;
  final cardHeight = 105.0;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    final productsProvider = Provider.of<ELSOnSaleProductsProvider>(context, listen: false);
    final isOnSale = widget.product.subscriptionEndDate.difference(DateTime.now()).inDays < 0;
    final format = DateFormat('yyyy년 MM월 dd일');
    final dayDifference = widget.product.subscriptionEndDate.difference(DateTime.now()).inDays;

    void _onItemTapped() {
      setState(() {
        isSelected = !isSelected;
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        print('$width');
        return GestureDetector(
          onTap: () => _onItemTapped(),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: Container(
                  height: cardHeight,
                  width: 190,
                  child: Row(
                    children: [
                      Padding(
                        padding: edgeInsetsAll8,
                        child: GestureDetector(
                          child: Container(
                            width: 75,
                            decoration: const BoxDecoration(
                              borderRadius: borderRadiusCircular10,
                              color: AppColors.backgroundGray,
                            ),
                            child: Padding(
                              padding: edgeInsetsAll16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_right_alt, color: AppColors.textGray,),
                                  Text(
                                    '자세히',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            await productProvider.fetchProduct(widget.product.id);

                            // 로딩 다이얼로그 닫기
                            Navigator.of(context).pop();

                            if (productProvider.product != null) {
                              // ELSDetailDialog.show(context, productProvider.product!);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ELSProductDetailScreen()));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: edgeInsetsAll8,
                        child: GestureDetector(
                          child: Container(
                            width: 75,
                            decoration: const BoxDecoration(
                              borderRadius: borderRadiusCircular10,
                              color: Color(0xFF434648),
                            ),
                            child: Padding(
                              padding: edgeInsetsAll16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: AppColors.contentWhite,),
                                  Text(
                                    '비교',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.contentWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            setState(() {
                              nowComparing = !nowComparing;
                              if (widget.checkCompare != null) {
                                widget.checkCompare!(nowComparing, widget.index);
                              }
                            });
                            productProvider.compareId.add(widget.product.id);
                            if (productProvider.compareId.length == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CompareProductScreen()),
                              );
                            } else {
                              await productsProvider.fetchSimilarProducts(widget.product.id);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 500),
                transform: Matrix4.translationValues(isSelected ? -200 : 0, 0, 0),
                child: Container(
                  height: cardHeight,
                  padding: edgeInsetsAll16,
                  decoration: BoxDecoration(
                    color: AppColors.contentWhite,
                    borderRadius: borderRadiusCircular10,
                    border: Border.all(
                      color: isSelected ? AppColors.backgroundGray : AppColors.contentWhite
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  widget.product.name,
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
                                          text: widget.product.equities,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        maxLines: 1,
                                        textDirection: ui.TextDirection.ltr,
                                      )
                                        ..layout(maxWidth: constraints.maxWidth);

                                      final isOverflowing = textPainter.didExceedMaxLines;

                                      return isOverflowing
                                          ? Marquee(
                                        text: widget.product.equities,
                                        style: const TextStyle(color: AppColors.contentGray, fontSize: 14),
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        startAfter: const Duration(seconds: 1),
                                        blankSpace: 30,
                                        velocity: 30.0,
                                        accelerationDuration: const Duration(seconds: 1),
                                        accelerationCurve: Curves.linear,
                                        fadingEdgeEndFraction: 0.7,
                                        decelerationDuration:
                                        const Duration(milliseconds: 500),
                                        decelerationCurve: Curves.easeOut,
                                      ) : Text(
                                        widget.product.equities,
                                        style: const TextStyle(color: AppColors.contentGray, fontSize: 14),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${productType[widget.product.productType]!}형',
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
                            '연 ${widget.product.yieldIfConditionsMet}%',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.02,
                              fontSize: 18,
                              color: AppColors.contentRed,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${dayDifference.abs()}일 ${dayDifference < 0 ? '전' : '후'} 마감',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 14,
                              color: AppColors.textGray,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


