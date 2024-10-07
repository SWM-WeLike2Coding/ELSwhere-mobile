import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/widgets/holding_product_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_resource.dart';
import '../../data/models/dtos/els_product_for_schedule_dto.dart';
import '../../data/models/dtos/summarized_user_holding_dto.dart';

class RedemptionScheduleScreen extends StatefulWidget {
  const RedemptionScheduleScreen({super.key});

  @override
  State<RedemptionScheduleScreen> createState() => _RedemptionScheduleScreenState();
}

class _RedemptionScheduleScreenState extends State<RedemptionScheduleScreen> {
  ElsProductForScheduleDto convertHoldingProductToProductForSchedule(SummarizedUserHoldingDto holdingProduct) {
    return ElsProductForScheduleDto(
      isHolding: true,
      productId: holdingProduct.productId,
      holdingId: holdingProduct.holdingId,
      issuer: holdingProduct.issuer,
      name: holdingProduct.name,
      productType: holdingProduct.productType,
      equities: '',
      yieldIfConditionsMet: holdingProduct.yieldIfConditionsMet,
      subscriptionStartDate: DateTime.now(),
      subscriptionEndDate: holdingProduct.nextRepaymentEvaluationDate,
      investingAmount: holdingProduct.price,
      currentEarningPercent: holdingProduct.recentAndInitialPriceRatio,
    );
  }

  SummarizedUserHoldingDto convertProductForScheduleToSummarizedHolding(ElsProductForScheduleDto product) {
    return SummarizedUserHoldingDto(
      holdingId: product.holdingId!,
      productId: product.productId,
      issuer: product.issuer,
      name: product.name,
      productType: product.productType,
      yieldIfConditionsMet: product.yieldIfConditionsMet,
      nextRepaymentEvaluationDate: product.subscriptionEndDate,
      price: product.investingAmount!,
      recentAndInitialPriceRatio: product.currentEarningPercent,
    );
  }

  bool isTodayOrFuture(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isAfter(today) || targetDate.isAtSameMomentAs(today);
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '상환 일정 화면',
      screenClass: 'RedemptionScheduleScreen',
    );
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(
      builder: (context, provider, child) {
        var holdingProducts = Provider.of<UserInfoProvider>(context, listen: false).holdingProducts;
        holdingProducts ??= [];
        Map<DateTime, List<ElsProductForScheduleDto>> tempScheduleMap = {};

        for (int i = 0; i < holdingProducts.length; i++) {
          if (tempScheduleMap.containsKey(holdingProducts[i].nextRepaymentEvaluationDate)) {
            tempScheduleMap[holdingProducts[i].nextRepaymentEvaluationDate]!.add(convertHoldingProductToProductForSchedule(holdingProducts[i]));
          } else {
            tempScheduleMap[holdingProducts[i].nextRepaymentEvaluationDate] = [convertHoldingProductToProductForSchedule(holdingProducts[i])];
          }
        }

        List<DateTime> sortedDates = tempScheduleMap.keys.toList()..sort();
        Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap = {for (var key in sortedDates) key: tempScheduleMap[key]!};

        Map<DateTime, List<ElsProductForScheduleDto>> subscriptionEndSchedule = {};
        List<DateTime> dates = scheduleMap.keys.toList();

        for (int i = 0; i < dates.length; i++) {
          var tempList = scheduleMap[dates[i]];
          for (int j = 0; j < tempList!.length; j++) {
            if (tempList[j].isHolding == true && isTodayOrFuture(tempList[j].subscriptionEndDate)) {
              if (subscriptionEndSchedule[dates[i]] == null) {
                subscriptionEndSchedule[dates[i]] = [];
              }
              subscriptionEndSchedule[dates[i]]!.add(tempList[j]);
            }
          }
        }

        scheduleMap = subscriptionEndSchedule;

        if (scheduleMap.isEmpty) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: AppColors.gray50,
                  width: 1,
                ))),
                child: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
                    child: Align(
                      alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  title: const Text(
                    "가입 상품 중 상환 일정",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  centerTitle: false,
                ),
              ),
            ),
            body: const Center(
              child: Text("일정이 없어요"),
            ),
          );
        } else {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: AppColors.gray50,
                    width: 1,
                  ))),
                  child: AppBar(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
                      child: Align(
                        alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    title: const Text(
                      "가입 상품 중 상환 일정",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    centerTitle: false,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: scheduleMap.entries.map((entry) {
                    DateTime date = entry.key;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                          child: Text(
                            "${date.month}월 ${date.day}일",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 16.52 / 14,
                              letterSpacing: -0.02,
                              color: Color(0xFF838A8E),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
                          child: Text(
                            "조기/만기 상환",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 18.88 / 16,
                              letterSpacing: -0.02,
                              color: AppColors.gray950,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: entry.value.asMap().entries.map((entry) {
                            ElsProductForScheduleDto product = entry.value;
                            return HoldingProductCard(product: convertProductForScheduleToSummarizedHolding(product));
                          }).toList(),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ));
        }
      },
    );
    // return Scaffold(
    //   appBar: PreferredSize(
    //     preferredSize: const Size.fromHeight(72),
    //     child: Container(
    //       decoration: const BoxDecoration(
    //           border: Border(
    //               bottom: BorderSide(
    //         color: AppColors.backgroundGray,
    //         width: 1,
    //       ))),
    //       child: AppBar(
    //         leading: Padding(
    //           padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
    //           child: Align(
    //             alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
    //             child: IconButton(
    //               icon: const Icon(Icons.arrow_back),
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //             ),
    //           ),
    //         ),
    //         title: const Text(
    //           "가입 상품 중 상환 일정",
    //           style: TextStyle(
    //             fontWeight: FontWeight.w600,
    //             fontSize: 18,
    //           ),
    //         ),
    //         centerTitle: false,
    //       ),
    //     ),
    //   ),
    //   body: const Center(
    //     child: Text("일정이 없어요"),
    //   ),
    // );
  }
}
