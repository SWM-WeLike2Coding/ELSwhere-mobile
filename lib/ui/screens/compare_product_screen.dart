import 'dart:io';
import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/response_single_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/els_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class CompareProductScreen extends StatelessWidget {
  late final double statusBarHeight;
  late final double height;
  late final double width;
  late final ELSProductProvider? productProvider;
  late final UserInfoProvider? userProvider;

  // ignore: prefer_const_constructors_in_immutables
  CompareProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    statusBarHeight = MediaQuery.of(context).padding.top;
    height = size.height;
    width = size.width;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if (productProvider != null) {
            productProvider!.compareId.removeLast();
            productProvider!.compareProducts.clear();
          }
        }
      },
      child: Scaffold(
          appBar: _buildAppBar(context),
          body: Consumer<ELSOnSaleProductsProvider>(
            builder: (context, productsProvider, child) {
              if (productsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (!productsProvider.isLoading && productsProvider.products.isEmpty) {
                return const Center(child: Text('상품이 없습니다.'));
              } else {
                return FutureBuilder(
                    future: productProvider!.fetchCompareProduct(productProvider!.compareId[0], productProvider!.compareId[1]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('An error occurred!'));
                      } else {
                        final compareProducts = productProvider!.compareProducts;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: edgeInsetsAll24,
                                child: Column(
                                  children: [
                                    _buildProductName(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 32),
                                    _buildProductIssuer(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 32),
                                    _buildProductYield(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 32),
                                    _buildProductEquities(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 32),
                                    _buildProductType(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 32),
                                    _buildProductKnockin(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 32),
                                    _buildProductLossRate(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 32),
                                    _buildProductSubscriptionEndDate(compareProducts[0], compareProducts[1]),
                                    const SizedBox(height: 16),
                                    _buildProductDetailScreeenButton(context, compareProducts[0], compareProducts[1]),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: AppColors.gray50),
                            ],
                          ),
                        );
                      }
                    });
              }
            },
          )),
    );
  }

  // ======================================================================================================
  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(width, 48 + statusBarHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, statusBarHeight + (Platform.isIOS ? 0 : 12), 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                print(productProvider!.compareId);
                print(productProvider!.compareProducts);
              },
            ),
            const SizedBox(width: 8),
            Text('상품 비교', style: textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildProductName(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '상품명',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            product1.name,
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            product2.name,
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductIssuer(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '발행사',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: edgeInsetsAll8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gray50,
                  ),
                  child: Assets.issuerIconMap[product1.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[product1.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack)),
              const SizedBox(height: 8),
              Text(
                product1.issuer,
                style: textTheme.labelSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: edgeInsetsAll8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gray50,
                  ),
                  child: Assets.issuerIconMap[product2.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[product2.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack)),
              const SizedBox(height: 8),
              Text(
                product2.issuer,
                style: textTheme.labelSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductYield(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '연 수익률',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '연 ${product1.yieldIfConditionsMet}%',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '연 ${product2.yieldIfConditionsMet}%',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductEquities(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '기초자산',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            flex: 2,
            child: LayoutBuilder(builder: (context, constraints) {
              final equities = product1.equities.split('/');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product1.equities.split('/').map((e) {
                  final String equity = e.trim();

                  return Column(
                    children: [
                      _buildText(
                        text: equity,
                        height: 20,
                        maxWidth: constraints.maxWidth,
                        style: textTheme.labelSmall!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.28,
                        ),
                      ),
                      if (e != product1.equities.split('/').last)
                        const SizedBox(
                          height: 8,
                        ),
                    ],
                  );
                }).toList(),
              );
            })),
        const SizedBox(width: 8),
        Expanded(
            flex: 2,
            child: LayoutBuilder(builder: (context, constraints) {
              final equities = product2.equities.split('/');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product2.equities.split('/').map((e) {
                  final String equity = e.trim();

                  return Column(
                    children: [
                      _buildText(
                        text: equity,
                        height: 20,
                        maxWidth: constraints.maxWidth,
                        style: textTheme.labelSmall!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.28,
                        ),
                      ),
                      if (e != product2.equities.split('/').last)
                        const SizedBox(
                          height: 8,
                        ),
                    ],
                  );
                }).toList(),
              );
            })),
      ],
    );
  }

  Widget _buildProductType(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '상품 유형',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '${productType[product1.type]}형\n${product1.productInfo ?? ''}',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '${productType[product2.type]}형\n${product2.productInfo ?? ''}',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductKnockin(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '낙인 유무',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '${product1.knockIn ?? '없음'}',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '${product2.knockIn ?? '없음'}',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductLossRate(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '최대 손실률',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '${product1.maximumLossRate}%',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.contentRed,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            '${product2.maximumLossRate}%',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.contentRed,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductSubscriptionEndDate(ResponseSingleProductDto product1, ResponseSingleProductDto product2) {
    final dayDifference1 = DateTime.parse(product1.subscriptionEndDate).difference(DateTime.now()).inDays;
    final dayDifference2 = DateTime.parse(product2.subscriptionEndDate).difference(DateTime.now()).inDays;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '청약 마감일',
            style: textTheme.labelSmall!.copyWith(
              color: AppColors.gray600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            dayDifference1 != 0 ? '$dayDifference1일 후' : '오늘',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            dayDifference2 != 0 ? '$dayDifference2일 후' : '오늘',
            style: textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetailScreeenButton(BuildContext context, ResponseSingleProductDto compareProduct1, ResponseSingleProductDto compareProduct2) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.gray50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  await productProvider!.fetchMonteCarloResponse(compareProduct1.id);
                  await productProvider!.fetchProduct(compareProduct1.id);
                  productProvider!.checkisHeld(userProvider!.holdingProducts ?? []);

                  // 로딩 다이얼로그 닫기
                  Navigator.of(context).pop();

                  if (productProvider!.product == null) throw Exception;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ELSProductDetailScreen(),
                      ));
                } catch (e) {
                  Fluttertoast.showToast(msg: '상품 불러오기에 실패했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Text(
                  '자세히',
                  style: textTheme.labelSmall!.copyWith(
                    fontSize: 14,
                    color: AppColors.contentBlack,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.gray50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  await productProvider!.fetchMonteCarloResponse(compareProduct2.id);
                  await productProvider!.fetchProduct(compareProduct2.id);
                  productProvider!.checkisHeld(userProvider!.holdingProducts ?? []);

                  // 로딩 다이얼로그 닫기
                  Navigator.of(context).pop();

                  if (productProvider!.product == null) throw Exception;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ELSProductDetailScreen(),
                      ));
                } catch (e) {
                  Fluttertoast.showToast(msg: '상품 불러오기에 실패했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Text(
                  '자세히',
                  style: textTheme.labelSmall!.copyWith(
                    fontSize: 14,
                    color: AppColors.contentBlack,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText({required String text, required double height, required double maxWidth, required TextStyle style}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final isOverflowing = textPainter.didExceedMaxLines;

    return isOverflowing
        ? SizedBox(
            height: height,
            child: Marquee(
              text: text,
              style: style,
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              startAfter: const Duration(seconds: 1),
              velocity: 30.0,
              blankSpace: 100,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              fadingEdgeEndFraction: 0.7,
              decelerationCurve: Curves.linear,
            ),
          )
        : Text(
            text,
            style: style,
          );
  }
}
