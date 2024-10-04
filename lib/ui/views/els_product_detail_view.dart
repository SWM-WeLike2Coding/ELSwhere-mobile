import 'dart:ui' as ui;
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/models/dtos/monte_carlo_response.dart';
import 'package:elswhere/data/models/dtos/response_single_product_dto.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/views/add_holding_product_modal.dart';
import 'package:elswhere/ui/views/stock_price_graph_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ELSProductDetailView extends StatefulWidget {
  const ELSProductDetailView({super.key});

  @override
  State<ELSProductDetailView> createState() => _ELSProductDetailViewState();
}

class _ELSProductDetailViewState extends State<ELSProductDetailView> {
  late ELSProductProvider productProvider;
  late UserInfoProvider userProvider;
  late OverlayPortalController _overlayPortalController;
  // late AnimatedDigitController _animatedDigitController;
  ResponseSingleProductDto? product;
  bool isHeld = false;

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    _overlayPortalController = OverlayPortalController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(builder: (context, productProvider, child) {
      return Consumer<UserInfoProvider>(builder: (context, userProvider, child) {
        if (productProvider.isLoading && productProvider.product == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (productProvider.product == null) {
          return const Center(child: Text('상품이 존재하지 않습니다.'));
        }
        product = productProvider.product!;
        isHeld = productProvider.isHeld;

        print('보유중인가?: $isHeld');

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final length = (width - 56) / 2;

            return SingleChildScrollView(
              child: Padding(
                padding: edgeInsetsAll24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductTitle(width),
                    const SizedBox(height: 48),
                    _buildInvestmentStatusWidget(),
                    Row(
                      children: [
                        _buildYieldRateCard(length),
                        const SizedBox(width: 8),
                        _buildEquitiesCard(length),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInitialBasePriceEvaluationDateCard(),
                    const SizedBox(height: 8),
                    _buildDateCard(),
                    const SizedBox(height: 8),
                    _buildProductTypeCard(),
                    const SizedBox(height: 8),
                    _buildRemarksCard(context),
                    const SizedBox(height: 48),
                    _buildTitleText('기초자산 주가'),
                    const SizedBox(height: 24),
                    const StockPriceGraphView(),
                    if (productProvider.monteCarloResponse != null)
                      Column(
                        children: [
                          const SizedBox(height: 48),
                          _buildAnalysisResult(),
                          const SizedBox(height: 32),
                          _buildRepaymentRatesList(),
                        ],
                      ),
                    const SizedBox(height: 48),
                    _buildTitleText('조기•만기상환 평가 일정'),
                    const SizedBox(height: 32),
                    _buildEvaluationDatesList(),
                    const SizedBox(height: 48),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildRedirectText('간이투자설명서', product!.summaryInvestmentProspectusLink),
                    _buildRedirectText('홈페이지', product!.link),
                    const SizedBox(height: 24),
                    _buildNoticeText(product!.issuer),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      });
    });
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
            color: AppColors.gray600,
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
      ),
    );
  }

  Widget _buildIssuerIcon() {
    return SizedBox(
      width: 65,
      height: 65,
      child: CircleAvatar(
        child: Padding(
          padding: edgeInsetsAll8,
          child: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Assets.issuerIconMap[product?.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[product?.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInvestmentStatusWidget() {
    SummarizedUserHoldingDto? holdingProduct = productProvider.holdingProduct;
    double holdingPrice = 0;
    double? priceRatio;
    final decimalFormat = NumberFormat.decimalPattern('ko');
    final dateFormat = DateFormat().addPattern('yyyy년 MM월 dd일');

    Widget buildInvestedPrice() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '투자 금액',
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                Row(
                  children: [
                    // Text(
                    //   '${decimalFormat.format(holdingPrice.toInt())}원',
                    //   style: textTheme.labelLarge!.copyWith(
                    //     fontSize: 22,
                    //   ),
                    // ),
                    AnimatedFlipCounter(
                      value: holdingPrice.toInt(),
                      textStyle: textTheme.labelLarge!.copyWith(
                        fontSize: 22,
                      ),
                      thousandSeparator: ',',
                      suffix: '원',
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCirc,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => AddHoldingProductModal(initValue: holdingProduct!.price, isUpdate: true, holdingId: holdingProduct.holdingId),
                        );
                      },
                      icon: const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircleAvatar(
                          backgroundColor: AppColors.gray50,
                          child: Icon(Icons.edit, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildInRowText(int caseNumber) {
      String title = '';
      String content = '';
      Color color = Colors.black;
      switch (caseNumber) {
        case 0:
          // title = '평가 금액';
          // content =
          //     '${decimalFormat.format((holdingPrice * (100 + (priceRatio == null ? 0 : holdingProduct!.yieldIfConditionsMet)) / 100).toInt())}원\n(${priceRatio == null ? '미발행' : '+${holdingProduct!.yieldIfConditionsMet.toStringAsFixed(1)}%'})';
          // color = priceRatio == null ? Colors.black : AppColors.contentRed;
          title = '최초 기준가격 대비 변동율';
          content = priceRatio == null ? '미반영' : '${priceRatio! < 0 ? '' : '+'}${priceRatio!.toStringAsFixed(2)}%';
          color = priceRatio == null || priceRatio! == 0
              ? Colors.black
              : priceRatio! > 0
                  ? AppColors.contentRed
                  : AppColors.mainBlue;
          print(priceRatio);
        case 1:
          title = '다음 상환 평가일';
          content = dateFormat.format(holdingProduct!.nextRepaymentEvaluationDate);
        case 2:
          title = '만기 상환 평가일';
          content = dateFormat.format(DateTime.parse(product!.maturityDate));
        case 3:
          title = '낙인 도달 여부';
          content = 100 + (holdingProduct!.recentAndInitialPriceRatio ?? 0) < (product!.knockIn ?? 0) ? '있음' : '없음';
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: textTheme.labelMedium!.copyWith(
              color: AppColors.gray600,
            ),
          ),
          Text(
            content,
            textAlign: TextAlign.end,
            style: textTheme.labelMedium!.copyWith(
              color: color,
            ),
          ),
        ],
      );
    }

    Widget buildDetailInvestmentInformation() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildInRowText(0),
                const SizedBox(height: 18),
                buildInRowText(1),
                const SizedBox(height: 18),
                buildInRowText(2),
                const SizedBox(height: 18),
                buildInRowText(3),
              ],
            ),
          ),
        ),
      );
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.topCenter,
      curve: Curves.fastOutSlowIn,
      child: productProvider.isHeld
          ? Builder(
              key: const ValueKey(1),
              builder: (context) {
                holdingPrice = holdingProduct!.price;
                priceRatio = holdingProduct.recentAndInitialPriceRatio;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleText('내 투자 현황'),
                    const SizedBox(height: 24),
                    buildInvestedPrice(),
                    const SizedBox(height: 8),
                    buildDetailInvestmentInformation(),
                    const SizedBox(height: 48),
                    _buildTitleText('상품 정보'),
                    const SizedBox(height: 24),
                  ],
                );
              },
            )
          : const SizedBox(key: ValueKey(2)),
    );
    // return AnimatedSwitcher(
    //   duration: const Duration(milliseconds: 700),
    //   switchInCurve: Curves.fastOutSlowIn,
    //   switchOutCurve: Curves.fastOutSlowIn,
    //   transitionBuilder: (Widget child, Animation<double> animation) {
    //     final offsetAnimation = Tween<Offset>(
    //       begin: !isHeld ? const Offset(1, 0) : const Offset(-1, 0),
    //       end: !isHeld ? const Offset(0, 0) : const Offset(0, 0),
    //     ).animate(animation);
    //     return SlideTransition(position: offsetAnimation, child: child);
    //   },
    //   child: productProvider.isHeld
    //       ? Builder(
    //           key: const ValueKey(1),
    //           builder: (context) {
    //             holdingProductId = product!.id;
    //             holdingProduct = userProvider.holdingProducts?.firstWhere((e) => e.productId == holdingProductId);
    //             holdingPrice = holdingProduct?.price ?? 0;
    //             return Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 _buildTitleText('내 투자 현황'),
    //                 const SizedBox(height: 24),
    //                 buildInvestedPrice(),
    //                 const SizedBox(height: 8),
    //                 buildDetailInvestmentInformation(),
    //                 const SizedBox(height: 48),
    //                 _buildTitleText('상품 정보'),
    //                 const SizedBox(height: 24),
    //               ],
    //             );
    //           },
    //         )
    //       : const SizedBox(key: ValueKey(2)),
    // );
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

  Widget _buildYieldRateCard(double length) {
    final equities = product!.equities.split('/');
    return Container(
      width: length,
      height: 115 + equities.length * 20,
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
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('연 ${product!.yieldIfConditionsMet}%',
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 24,
                    color: AppColors.contentRed,
                  )),
              const SizedBox(height: 4),
              Text(
                '조건 충족시',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 14,
                  color: AppColors.gray600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEquitiesCard(double length) {
    final equities = product!.equities.split('/');
    return Container(
      width: length,
      height: 115 + equities.length * 20,
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
              Text('기초자산',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.gray600,
                  )),
              const SizedBox(height: 18),
            ],
          ),
          LayoutBuilder(builder: (context, constraints) {
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
                    if (e != product!.equities.split('/').last)
                      const SizedBox(
                        height: 8,
                      ),
                  ],
                );
              }).toList(),
            );
          })
        ],
      ),
    );
  }

  Widget _buildInitialBasePriceEvaluationDateCard() {
    // final format = DateFormat().addPattern('yyyy-MM-dd');
    final dayDifference = DateTime.parse(product!.initialBasePriceEvaluationDate.toString()).difference(DateTime.now()).inDays;

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
                  '최초 기준가격 평가일',
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                Text(
                  dayDifference != 0 ? '${dayDifference.abs()}일 ${dayDifference < 0 ? '전' : '후'}' : '오늘',
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.mainBlue,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product!.initialBasePriceEvaluationDate ?? '',
              style: textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    final format = DateFormat().addPattern('yyyy-MM-dd');
    final dayDifference = isHeld
        ? DateTime.parse(productProvider.holdingProduct!.nextRepaymentEvaluationDate.toString()).difference(DateTime.now()).inDays
        : DateTime.parse(product!.subscriptionEndDate).difference(DateTime.now()).inDays;

    return isHeld
        ? Container(
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
                        '다음 평가일',
                        style: textTheme.labelMedium!.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      Text(
                        '$dayDifference일 후',
                        style: textTheme.labelMedium!.copyWith(
                          color: AppColors.mainBlue,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    format.format(productProvider.holdingProduct!.nextRepaymentEvaluationDate),
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          )
        : Container(
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
                          color: AppColors.gray600,
                        ),
                      ),
                      Text(
                        '${dayDifference != 0 ? '${dayDifference.abs()}일 ${dayDifference < 0 ? '전' : '후'}' : '오늘'} 마감',
                        style: textTheme.labelMedium!.copyWith(
                          color: AppColors.mainBlue,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${product!.subscriptionStartDate} ~ ${product!.subscriptionEndDate}',
                    style: textTheme.labelMedium,
                  ),
                  const SizedBox(height: 16),
                  Text('발행•만기일',
                      style: textTheme.labelMedium!.copyWith(
                        color: AppColors.gray600,
                      )),
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
                    color: AppColors.gray600,
                  ),
                ),
                Text(
                  '${productType[product!.type]!}형',
                  style: textTheme.labelMedium!.copyWith(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('KI ${product!.knockIn ?? '없음'}', style: textTheme.labelMedium!.copyWith()),
            const SizedBox(height: 8),
            if (product!.productInfo != null) Text('${product!.productInfo}', style: textTheme.labelMedium!.copyWith()),
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
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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

  Widget _buildAnalysisResult() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitleText('엘스웨어 분석 결과'),
        OverlayPortal(
          controller: _overlayPortalController,
          overlayChildBuilder: (context) {
            return Positioned(
              top: 30,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: edgeInsetsAll24,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: edgeInsetsAll16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _overlayPortalController.hide,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Icon(Icons.close),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              MSG_DESCRIPTION_MONTECARLO,
                              style: textTheme.headlineSmall,
                              softWrap: true,
                              maxLines: null,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: SizedBox(
            width: 24,
            height: 24,
            child: GestureDetector(
              onTap: _overlayPortalController.toggle,
              child: CircleAvatar(
                backgroundColor: AppColors.gray100,
                child: Text(
                  '?',
                  style: textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRepaymentRatesList() {
    MonteCarloResponse monteCarloResponse = productProvider.monteCarloResponse!;
    List<String> splitedEarlyRepaymentProbability = monteCarloResponse.earlyRepaymentProbability.split(',');
    int length = splitedEarlyRepaymentProbability.length;
    List<double> earlyRepaymentProbabilities = splitedEarlyRepaymentProbability.map((e) => double.parse(e)).toList()
      ..addAll([monteCarloResponse.maturityRepaymentProbability, monteCarloResponse.lossProbability]);
    List<String> levelString = List.generate(length, (idx) => '${idx + 1}차 조기상환율')..addAll(["만기 상환율", "손실율"]);

    return Column(
      children: [
        for (int i = 0; i <= length + 1; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                levelString[i],
                style: textTheme.labelMedium!.copyWith(color: i == length + 1 ? AppColors.contentRed : AppColors.gray600),
              ),
              Text(
                '${earlyRepaymentProbabilities[i].toStringAsFixed(2)}%',
                style: textTheme.labelMedium!.copyWith(color: i == length + 1 ? AppColors.contentRed : AppColors.contentBlack),
              ),
            ],
          ),
          if (i != length + 1) const SizedBox(height: 24),
        ]
      ],
    );
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
                      color: AppColors.gray600,
                    ),
                  ),
                  Text(item.last, style: textTheme.labelMedium),
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
                color: AppColors.gray600,
              ),
            ),
            Text(DateFormat().addPattern('yyyy년 MM월 dd일').format(DateTime.parse(product!.maturityDate)), style: textTheme.labelMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: AppColors.gray100,
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
                style: textTheme.labelMedium!.copyWith(color: const Color(0xFF3B3D3F)),
              ),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ));
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
