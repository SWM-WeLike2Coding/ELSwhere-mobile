import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
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
  bool isSelected = false;
  bool isOnSale = false;
  final cardHeight = 105.0;

  late ELSProductProvider productProvider;
  late UserInfoProvider userProvider;
  late SummarizedUserHoldingDto product;
  late int dayDifference;
  late NumberFormat format;
  late String price;
  late double nowPrice;
  double? priceRatio;

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
      await productProvider.fetchMonteCarloResponse(product.productId),
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
    return Consumer<UserInfoProvider>(builder: (context, userProvider, _) {
      product = widget.product;
      dayDifference = product.nextRepaymentEvaluationDate.difference(DateTime.now()).inDays;
      format = NumberFormat.decimalPattern('ko');
      price = '${format.format(product.price)}원';
      priceRatio = product.recentAndInitialPriceRatio;
      nowPrice = priceRatio == null ? 0 : product.price * product.yieldIfConditionsMet / 100;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onItemTapped,
        child: SizedBox(
          height: cardHeight,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  Column(children: [_buildIssuerIcon()]),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProductName(),
                            const SizedBox(height: 4),
                            _buildPrice(),
                          ],
                        ),
                        _buildNextRepaymentDate(),
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
                          _buildProfitAndLossPrice(),
                          const SizedBox(width: 4),
                          _buildProfitAndLossRate(),
                        ],
                      ),
                      _buildProductType(),
                    ],
                  )
                ],
              )),
        ),
      );
    });
  }

  Widget _buildIssuerIcon() {
    return CircleAvatar(
      backgroundColor: AppColors.backgroundGray,
      child: Padding(
        padding: edgeInsetsAll4,
        child: Assets.issuerIconMap[widget.product.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[widget.product.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack),
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      product.name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.contentBlack,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildPrice() {
    return SizedBox(
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
    );
  }

  Widget _buildNextRepaymentDate() {
    return Row(
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
    );
  }

  Widget _buildProfitAndLossPrice() {
    // 추후 가격 제공 예정, 현재는 쿠폰금리로 표시
    return Text(
      // '${nowPrice == 0 ? '' : nowPrice > 0 ? '+' : '-'}${format.format(nowPrice.toInt())}원',
      '연 ${product.yieldIfConditionsMet.toStringAsFixed(1)}%',
      style: textTheme.labelMedium!.copyWith(
        // color: const Color(0xFF434648),
        color: AppColors.contentRed,
        // fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildProfitAndLossRate() {
    return Text(
      // priceRatio == null ? '미발행' : '${priceRatio! > 0 ? '+' : '-'}${product.yieldIfConditionsMet.toStringAsPrecision(2)}%',
      priceRatio == null ? '미반영' : '${priceRatio! < 0 ? '' : '+'}${priceRatio!.toStringAsFixed(2)}%',
      style: textTheme.labelSmall!.copyWith(
        color: (priceRatio ?? 0) == 0
            ? AppColors.contentGray
            : priceRatio! > 0
                ? AppColors.contentRed
                : AppColors.mainBlue,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildProductType() {
    return Text(
      '${productType[product.productType]!}형',
      style: textTheme.labelSmall!.copyWith(
        color: AppColors.mainBlue,
      ),
    );
  }
}
