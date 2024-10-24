import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_resource.dart';
import '../../../data/models/dtos/user/els_product_for_schedule_dto.dart';
import '../../../data/models/dtos/user/response_interesting_product_dto.dart';
import '../../../data/models/dtos/product/summarized_product_dto.dart';
import '../../widgets/els_product_card.dart';

class SubscriptionEndScheduleScreen extends StatefulWidget {
  const SubscriptionEndScheduleScreen({super.key});

  @override
  State<SubscriptionEndScheduleScreen> createState() => _SubscriptionEndScheduleScreenState();
}

class _SubscriptionEndScheduleScreenState extends State<SubscriptionEndScheduleScreen> {
  SummarizedProductDto convertProductForScheduleToSummarized(ELSProductForScheduleDto product) {
    return SummarizedProductDto(
      id: product.productId,
      issuer: product.issuer,
      name: product.name,
      productType: product.productType,
      equities: product.equities,
      yieldIfConditionsMet: product.yieldIfConditionsMet,
      subscriptionStartDate: product.subscriptionStartDate,
      subscriptionEndDate: product.subscriptionEndDate,
    );
  }

  ELSProductForScheduleDto convertInterestingProductToProductForSchedule(ResponseInterestingProductDto interestingProduct) {
    return ELSProductForScheduleDto(
      isHolding: false,
      productId: interestingProduct.productId,
      issuer: interestingProduct.issuer,
      name: interestingProduct.name,
      productType: interestingProduct.productType,
      equities: interestingProduct.equities,
      yieldIfConditionsMet: interestingProduct.yieldIfConditionsMet,
      subscriptionStartDate: interestingProduct.subscriptionStartDate,
      subscriptionEndDate: interestingProduct.subscriptionEndDate,
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
      screenName: '청약 마감 일정 화면',
      screenClass: 'SubscriptionEndScheduleScreen',
    );
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, elsProvider, child) {
        var interestingProducts = Provider.of<ELSProductProvider>(context, listen: false).interestingProducts;
        Map<DateTime, List<ELSProductForScheduleDto>> tempScheduleMap = {};

        for (int i = 0; i < interestingProducts.length; i++) {
          if (tempScheduleMap.containsKey(interestingProducts[i].subscriptionEndDate)) {
            tempScheduleMap[interestingProducts[i].subscriptionEndDate]!.add(convertInterestingProductToProductForSchedule(interestingProducts[i]));
          } else {
            tempScheduleMap[interestingProducts[i].subscriptionEndDate] = [convertInterestingProductToProductForSchedule(interestingProducts[i])];
          }
        }

        // 나중에 여기에 보유 상품 관련 정보들도 DTO 변환해서 tempScheduleMap에 넣어줘야함!!!

        List<DateTime> sortedDates = tempScheduleMap.keys.toList()..sort();
        Map<DateTime, List<ELSProductForScheduleDto>> scheduleMap = {for (var key in sortedDates) key: tempScheduleMap[key]!};

        Map<DateTime, List<ELSProductForScheduleDto>> subscriptionEndSchedule = {};
        List<DateTime> dates = scheduleMap.keys.toList();

        for (int i = 0; i < dates.length; i++) {
          var tempList = scheduleMap[dates[i]];
          for (int j = 0; j < tempList!.length; j++) {
            if (tempList[j].isHolding == false && isTodayOrFuture(tempList[j].subscriptionEndDate)) {
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
                    "관심 등록 상품 중 청약 마감",
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
                      "관심 등록 상품 중 청약 마감",
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
                              color: AppColors.gray400,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
                          child: Text(
                            "청약 마감",
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
                            int index = entry.key;
                            ELSProductForScheduleDto product = entry.value;
                            return ELSProductCard(product: convertProductForScheduleToSummarized(product), index: index);
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
  }
}
