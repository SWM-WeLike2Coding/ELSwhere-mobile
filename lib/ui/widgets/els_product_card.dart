import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/ui/screens/els_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class ELSProductCard extends StatefulWidget {
  final SummarizedProductDto product;
  final int index;

  const ELSProductCard({
    super.key,
    required this.product,
    required this.index,
  });


  @override
  State<ELSProductCard> createState() => _ELSProductCardState();
}

class _ELSProductCardState extends State<ELSProductCard> {
  bool isSelected = false;
  final cardHeight = 125.0;

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ELSProductProvider>(context, listen: false);
    final format = DateFormat('yyyy년 MM월 dd일');

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
                              color: Color(0xFFF5F6F6),
                            ),
                            child: Padding(
                              padding: edgeInsetsAll16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_right_alt, color: Color(0xFF595E62),),
                                  Text(
                                    '자세히',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Color(0xFF595E62),
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
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 500),
                transform: Matrix4.translationValues(isSelected ? -190 : 0, 0, 0),
                child: Container(
                  height: cardHeight,
                  padding: edgeInsetsAll16,
                  decoration: BoxDecoration(
                    color: AppColors.contentWhite,
                    borderRadius: borderRadiusCircular10,
                    border: Border.all(
                      color: isSelected ? Color(0xFFF5F6F6) : AppColors.contentWhite
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(Assets.iconHana),
                            ),
                            backgroundColor: const Color(0xFFF5F6F6),
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
                                        velocity: 30.0,
                                        pauseAfterRound: const Duration(seconds: 1),
                                        startPadding: 10.0,
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
                            const SizedBox(height: 6),
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
                              letterSpacing: -0.2,
                              fontSize: 18,
                              color: AppColors.contentRed,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${widget.product.subscriptionEndDate.difference(DateTime.now()).inDays}일 뒤 마감',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 14,
                              color: const Color(0xFF595E62),
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


