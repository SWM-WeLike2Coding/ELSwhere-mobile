import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
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
  final cardHeight = 110.0;

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
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                Positioned(
                  left: width - 175,
                  child: Container(
                    height: cardHeight,
                    width: 165,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          decoration: const BoxDecoration(color: Colors.grey),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.grey),
                              child: const Center(
                                child: Text(
                                  '상세보기',
                                  style: TextStyle(color: Colors.white),
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
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.horizontal(right: Radius.circular(10))),
                            child: const Center(
                              child: Text(
                                '비교하기',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 500),
                  transform: Matrix4.translationValues(isSelected ? -150 : 0, 0, 0),
                  child: Container(
                    height: cardHeight,
                    padding: edgeInsetsAll12,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blues1,
                          AppColors.blues2,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: borderRadiusCircular10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                      color: AppColors.contentWhite,
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
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 14),
                                          ),
                                          maxLines: 1,
                                          textDirection: ui.TextDirection.ltr,
                                        )
                                          ..layout(maxWidth: constraints.maxWidth);

                                        final isOverflowing = textPainter.didExceedMaxLines;

                                        return isOverflowing
                                            ? Marquee(
                                          text: widget.product.equities,
                                          style: const TextStyle(color: Colors.white, fontSize: 14),
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
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 8),
                              Text(
                                '${format.format(widget.product.subscriptionStartDate)}',
                                style: const TextStyle(color: AppColors.contentWhite),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${widget.product.yieldIfConditionsMet}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.contentWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
