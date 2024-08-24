import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/response_single_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/ui/views/stock_price_graph_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ELSProductDetailView extends StatelessWidget {
  ResponseSingleProductDto? product;

  ELSProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading &&
            productProvider.product == null) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (productProvider.product == null) {
          return const Center(child: Text('상품이 존재하지 않습니다.'));
        }

        product = productProvider.product!;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: edgeInsetsAll24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductTitle(width),
                      const SizedBox(height: 48),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildYieldRateCard(),
                          const SizedBox(width: 8),
                          _buildEquitiesCard(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDateCard(),
                      const SizedBox(height: 8),
                      _buildProductTypeCard(),
                      const SizedBox(height: 8),
                      _buildRemarksCard(context),
                      const SizedBox(height: 48),
                      _buildTitleText('기초자산 주가'),
                      const SizedBox(height: 24),
                      StockPriceGraphView(),
                      // const SizedBox(height: 48),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _buildTitleText('엘스웨어 분석 결과'),
                      //     SizedBox(
                      //       width: 24,
                      //       height: 24,
                      //       child: GestureDetector(
                      //         onTap: () {},
                      //         child: CircleAvatar(
                      //           backgroundColor: const Color(0xFFE6E7E8),
                      //           child: Text(
                      //             '?',
                      //             style: textTheme.labelSmall!.copyWith(
                      //               fontWeight: FontWeight.w700,
                      //             )
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(height: 32),
                      // _buildRepaymentRatesList(),
                      const SizedBox(height: 48),
                      _buildTitleText('조기•만기상환 평가 일정'),
                      const SizedBox(height: 32),
                      _buildEvaluationDatesList(),
                      const SizedBox(height: 48),
                      const Divider(height: 1, color: const Color(0xFFE6E7E8),),
                      const SizedBox(height: 24),
                      _buildRedirectText('간이투자설명서', product!.summaryInvestmentProspectusLink),
                      _buildRedirectText('홈페이지', product!.link),
                      const SizedBox(height: 24),
                      _buildNoticeText(product!.issuer),
                      const SizedBox(height: 8),
                    ],
                  )
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget _buildProductTitle(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIssuerIcon(),
        const SizedBox(height: 16),
        _buildText(
          text: product!.name,
          height: 30,
          maxWidth: width - 48,
          style: textTheme.labelLarge!.copyWith(),
        ),
        const SizedBox(height: 4),
        Text(
          product!.issuer,
          style: textTheme.labelMedium?.copyWith(
            fontSize: 18,
            color: AppColors.contentGray,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: textTheme.titleLarge!.copyWith(
        fontSize: 24,
        color: AppColors.titleGray,
      )
    );
  }

  Widget _buildIssuerIcon() {
    return SizedBox(
      width: 65,
      height: 65,
      child: CircleAvatar(
        child: Padding(
          padding: edgeInsetsAll8,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Assets.issuerIconMap[product?.issuer] != null
                      ? SvgPicture.asset(Assets.issuerIconMap[product?.issuer]!)
                      : const Icon(Icons.question_mark, color: AppColors.contentBlack),
                ),
              );
            }
          ),
        ),
      ),
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
    )
      ..layout(maxWidth: maxWidth);

    final isOverflowing = textPainter.didExceedMaxLines;

    return isOverflowing
        ? SizedBox(
      height: height,
      child: Marquee(
        text: text,
        style: style,
        scrollAxis: Axis.horizontal,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        startAfter: const Duration(seconds: 1),
        velocity: 30.0,
        blankSpace: 100,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        fadingEdgeEndFraction: 0.7,
        decelerationCurve: Curves.linear,
      ),
    ) : Text(
      text,
      style: style,
    );
  }

  Widget _buildYieldRateCard() {
    return Expanded(
      child: Container(
        padding: edgeInsetsAll16,
        decoration: BoxDecoration(
          color: AppColors.contentWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                    '수익률',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.contentGray,
                    )
                ),
                const SizedBox(height: 18),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '연 최대 ${product!.yieldIfConditionsMet}%',
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 20,
                      color: AppColors.contentRed,
                    )
                ),
                const SizedBox(height: 4),
                Text(
                  '조건 충족시',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 14,
                    color: AppColors.contentGray,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEquitiesCard() {
    return Expanded(
      child: Container(
        padding: edgeInsetsAll16,
        decoration: BoxDecoration(
          color: AppColors.contentWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                    '기초자산',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.contentGray,
                    )
                ),
                const SizedBox(height: 18),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final equities = product!.equities.split('/');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: equities.map((e) {
                    final String equity = e.trim();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildText(
                          text: equity,
                          height: 20,
                          maxWidth: constraints.maxWidth,
                          style: textTheme.labelMedium!.copyWith(),
                        ),
                        if (e != product!.equities.split('/').last) const SizedBox(height: 8,),
                      ],
                    );
                  }).toList(),
                );
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    final dayDifference = DateTime.parse(product!.subscriptionEndDate).difference(DateTime.now()).inDays;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.contentWhite,
        borderRadius: borderRadiusCircular10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '청약 시작•마감일',
                    style: textTheme.labelMedium!.copyWith(
                      color: AppColors.textGray,
                    )
                ),
                Text(
                    '${dayDifference != 0 ? '${dayDifference.abs()}일 ${dayDifference < 0 ? '전' : '후'}' : '오늘'} 마감',
                    style: textTheme.labelMedium!.copyWith(
                      color: AppColors.mainBlue,
                    )
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${product!.subscriptionStartDate} ~ ${product!.subscriptionEndDate}',
              style: textTheme.labelMedium,
            ),
            const SizedBox(height: 16),
            Text(
                '발행•만기일',
                style: textTheme.labelMedium!.copyWith(
                  color: AppColors.textGray,
                )
            ),
            const SizedBox(height: 12),
            Text(
              '${product!.issuedDate} ~ ${product!.maturityDate}',
              style: textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTypeCard() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.contentWhite,
        borderRadius: borderRadiusCircular10,
      ),
      child: Padding(
        padding: edgeInsetsAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '상품 유형',
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.textGray,
                  ),
                ),
                Text(
                  '${productType[product!.type]!}형',
                  style: textTheme.labelMedium!.copyWith(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'KI ${product!.knockIn ?? '없음'}',
              style: textTheme.labelMedium!.copyWith()
            ),
            const SizedBox(height: 8),
            if (product!.productInfo != null)
              Text(
                '${product!.productInfo}',
                style: textTheme.labelMedium!.copyWith()
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksCard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.contentWhite,
        borderRadius: borderRadiusCircular10,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: edgeInsetsAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '비고',
                style: textTheme.labelMedium!.copyWith(
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                '${product!.remarks}형',
                style: textTheme.labelMedium!.copyWith(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepaymentRatesList() {
    return const Placeholder();
  }

  Widget _buildEvaluationDatesList() {
    final List<String> rows = product!.earlyRepaymentEvaluationDates?.split(',') ?? [];
    final List<List<String>> evaluationDates = rows.map((row) => row.trim().split(':')).toList();
    return Column(
      children: [
        ...evaluationDates.map((item) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.first} 평가일',
                    style: textTheme.labelMedium!.copyWith(
                      color: AppColors.textGray,
                    ),
                  ),
                  Text(
                    item.last,
                    style: textTheme.labelMedium
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '만기 평가일',
              style: textTheme.labelMedium!.copyWith(
                color: AppColors.textGray,
              ),
            ),
            Text(
              DateFormat().addPattern('yyyy년 MM월 dd일').format(DateTime.parse(product!.maturityDate)),
              style: textTheme.labelMedium
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRedirectText(String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: textTheme.labelMedium!.copyWith(
                color: const Color(0xFF3B3D3F)
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      )
    );
  }

  Widget _buildNoticeText(String issuer) {
    return Text(
      '''본 상품은 $issuer에서 광고하는 상품으로
엘스웨어는 상품 내용 및 판매에 관여하지 않습니다.''',
      style: textTheme.displaySmall!.copyWith(
        color: const Color(0xFFACB2B5),
      ),
    );
  }
}