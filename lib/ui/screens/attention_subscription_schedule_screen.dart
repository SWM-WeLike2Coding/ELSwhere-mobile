import 'package:elswhere/data/models/dtos/els_product_for_schedule_dto.dart';
import 'package:elswhere/data/models/dtos/response_interesting_product_dto.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/redemption_schedule_screen.dart';
import 'package:elswhere/ui/screens/subscription_end_schedule_screen.dart';
import 'package:elswhere/ui/widgets/holding_product_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../config/app_resource.dart';
import '../../data/models/dtos/summarized_product_dto.dart';
import '../widgets/els_product_card.dart';

class AttentionSubscriptionScheduleScreen extends StatefulWidget {
  const AttentionSubscriptionScheduleScreen({super.key});

  @override
  State<AttentionSubscriptionScheduleScreen> createState() => _AttentionSubscriptionScheduleScreenState();
}

class _AttentionSubscriptionScheduleScreenState extends State<AttentionSubscriptionScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ElsProductForScheduleDto>>? _scheduleMap;

  ElsProductForScheduleDto convertInterestingProductToProductForSchedule(ResponseInterestingProductDto interestingProduct) {
    return ElsProductForScheduleDto(
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

  // 기존에 schedulDTO가 관심 상품에 맞춰져 있어서, 청약 상품까지 포함할 수 있게 바꾸거나 새로운 DTO를 나중에 만드는 것이 더 깔끔할 것 같음(나중에 유지보수 시 헷갈리지 않게끔 두 종류의 상품 데이터를 아우를 수 있는 변수명으로 바꿔야 할 듯)
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

  SummarizedProductDto convertProductForScheduleToSummarized(ElsProductForScheduleDto product) {
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
      screenName: '관심 상품 일정 화면',
      screenClass: 'AttentionSubscriptionScheduleScreen',
    );
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  void _updateScheduleMap(DateTime selectDate) {
    setState(() {
      // print(selectDate);
      // print(_scheduleMap!.values.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, elsProductProvider, child) {
        var interestingProducts = Provider.of<ELSProductProvider>(context, listen: false).interestingProducts;
        var holdingProducts = Provider.of<UserInfoProvider>(context, listen: false).holdingProducts;
        holdingProducts ??= [];

        Map<DateTime, List<ElsProductForScheduleDto>> tempScheduleMap = {};
        Map<DateTime, List<ElsProductForScheduleDto>> filteredScheduleMap = {};

        for (int i = 0; i < interestingProducts.length; i++) {
          if (tempScheduleMap.containsKey(interestingProducts[i].subscriptionEndDate)) {
            tempScheduleMap[interestingProducts[i].subscriptionEndDate]!.add(convertInterestingProductToProductForSchedule(interestingProducts[i]));
          } else {
            tempScheduleMap[interestingProducts[i].subscriptionEndDate] = [convertInterestingProductToProductForSchedule(interestingProducts[i])];
          }
        }

        // 나중에 여기에 보유 상품 관련 정보들도 DTO 변환해서 tempScheduleMap에 넣어줘야함!!!(방금 바로 아래에 넣어줌)
        for (int i = 0; i < holdingProducts.length; i++) {
          if (tempScheduleMap.containsKey(holdingProducts[i].nextRepaymentEvaluationDate)) {
            tempScheduleMap[holdingProducts[i].nextRepaymentEvaluationDate]!.add(convertHoldingProductToProductForSchedule(holdingProducts[i]));
          } else {
            tempScheduleMap[holdingProducts[i].nextRepaymentEvaluationDate] = [convertHoldingProductToProductForSchedule(holdingProducts[i])];
          }
        }

        List<DateTime> sortedDates = tempScheduleMap.keys.toList()..sort();
        Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap = {for (var key in sortedDates) key: tempScheduleMap[key]!};

        if (_selectedDay != null) {
          print(_selectedDay);
          DateTime selectedDayOnlyDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
          if (scheduleMap.containsKey(selectedDayOnlyDate)) {
            filteredScheduleMap[selectedDayOnlyDate] = scheduleMap[selectedDayOnlyDate]!;
          }
        }

        Map<DateTime, List<ElsProductForScheduleDto>> finalScheduleMap = _selectedDay == null ? scheduleMap : filteredScheduleMap;
        print(finalScheduleMap.values.toString());

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
                  "관심 청약 일정",
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
              children: [
                _buildTwoGreyCards(context, scheduleMap),
                _buildScheduleCalendar(scheduleMap),
                if (_selectedDay == null) _buildSchedules(finalScheduleMap, false),
                if (_selectedDay != null) _buildSchedules(finalScheduleMap, true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGreyCard(BuildContext context, String text, int numItems, Map<DateTime, List<ElsProductForScheduleDto>> schedulMap) {
    return GestureDetector(
      onTap: () {
        if (text == "가입 상품 중 상환 일정") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RedemptionScheduleScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubscriptionEndScheduleScreen(),
            ),
          );
        }
      },
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.gray50,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.18,
                letterSpacing: -0.28,
                color: AppColors.gray800,
              ),
            ),
            const Spacer(),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Center(
                child: Text(
                  "$numItems",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.18,
                    letterSpacing: -0.28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoGreyCards(BuildContext context, Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap) {
    Map<DateTime, List<ElsProductForScheduleDto>> subscriptionEndSchedule = {};
    Map<DateTime, List<ElsProductForScheduleDto>> redemptionSchedule = {};
    List<DateTime> dates = scheduleMap.keys.toList();
    int numAttentionProducts = 0;
    int numHoldingProducts = 0;

    for (int i = 0; i < dates.length; i++) {
      var tempList = scheduleMap[dates[i]];
      for (int j = 0; j < tempList!.length; j++) {
        if (!isTodayOrFuture(tempList[j].subscriptionEndDate)) {
          continue;
        }
        if (tempList[j].isHolding == false) {
          if (subscriptionEndSchedule[dates[i]] == null) {
            subscriptionEndSchedule[dates[i]] = [];
          }
          subscriptionEndSchedule[dates[i]]!.add(tempList[j]);
          numAttentionProducts += 1;
        } else {
          if (redemptionSchedule[dates[i]] == null) {
            redemptionSchedule[dates[i]] = [];
          }
          redemptionSchedule[dates[i]]!.add(tempList[j]);
          numHoldingProducts += 1;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreyCard(context, "가입 상품 중 상환 일정", numHoldingProducts, redemptionSchedule),
          const SizedBox(
            height: 8,
          ),
          _buildGreyCard(context, "관심 등록 상품 중 청약 마감", numAttentionProducts, subscriptionEndSchedule),
        ],
      ),
    );
  }

  Widget _buildScheduleCalendar(Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap) {
    TextStyle calendarTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.18,
      letterSpacing: -0.28,
    );

    List<DateTime> importantDays = scheduleMap.keys.toList();

    bool isImportantDay(DateTime date, List<DateTime> importantDays) {
      return importantDays.any((importantDay) => importantDay.year == date.year && importantDay.month == date.month && importantDay.day == date.day);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
      child: TableCalendar(
        availableGestures: AvailableGestures.none,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (isImportantDay(selectedDay, importantDays)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _updateScheduleMap(selectedDay);
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: calendarTextStyle,
          weekendStyle: calendarTextStyle,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: calendarTextStyle,
          weekendTextStyle: calendarTextStyle,
          todayTextStyle: const TextStyle(
            color: AppColors.mainBlue,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.18,
            letterSpacing: -0.28,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.18,
            letterSpacing: -0.28,
          ),
          selectedDecoration: BoxDecoration(
              color: Colors.white,
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15), // 그림자 색상
                  spreadRadius: 0, // 확산 반경
                  blurRadius: 16, // 블러 반경
                  offset: Offset(0, 0), // 그림자의 x, y 오프셋
                ),
              ]),
          todayDecoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          cellAlignment: Alignment.center, // 셀 안의 날짜 가운데 정렬
        ),
        daysOfWeekHeight: 31,
        rowHeight: 70,
        headerStyle: HeaderStyle(
          titleTextFormatter: (date, locale) => DateFormat.yMMMM('ko').format(date), // 헤더 텍스트 한글로 포맷
          formatButtonVisible: false,
          leftChevronIcon: const Icon(
            Icons.arrow_left,
            color: AppColors.gray200,
          ),
          rightChevronIcon: const Icon(
            Icons.arrow_right,
            color: AppColors.gray200,
          ),
          leftChevronMargin: EdgeInsets.zero,
          rightChevronMargin: const EdgeInsets.only(left: 10),
          titleCentered: false,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            height: 1.18,
            letterSpacing: -0.36,
          ),
          headerMargin: EdgeInsets.zero,
          headerPadding: const EdgeInsets.only(left: 8),
        ),
        locale: 'ko_KR',
        calendarBuilders: CalendarBuilders(
          // Builder for all days to add a default marker
          todayBuilder: (context, date, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: isImportantDay(date, importantDays)
                      ? const BoxDecoration(
                          color: Colors.red, // Ellipse color
                          shape: BoxShape.circle,
                        )
                      : const BoxDecoration(
                          color: Colors.white, // Ellipse color
                          shape: BoxShape.circle,
                        ),
                ),
                const SizedBox(
                  height: 3.5,
                ),
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.18,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            );
          },
          defaultBuilder: (context, date, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: isImportantDay(date, importantDays)
                      ? const BoxDecoration(
                          color: Colors.red, // Ellipse color
                          shape: BoxShape.circle,
                        )
                      : const BoxDecoration(
                          color: Colors.white, // Ellipse color
                          shape: BoxShape.circle,
                        ),
                ),
                const SizedBox(
                  height: 3.5,
                ),
                Text(
                  '${date.day}',
                  style: calendarTextStyle,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSchedules(Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap, bool isDaySelected) {
    DateTime now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // children: scheduleMap.entries.where((entry) => isTodayOrFuture(entry.key)).map((entry){
      children: scheduleMap.entries.map((entry) {
        DateTime date = entry.key;
        List<ElsProductForScheduleDto> wholeProducts = entry.value;
        List<ElsProductForScheduleDto> interestedProducts = [];
        List<ElsProductForScheduleDto> holdingProducts = [];
        bool isThereInterested = false;
        bool isThereHolding = false;
        DateTime now = DateTime.now();

        for (int i = 0; i < wholeProducts.length; i++) {
          if (wholeProducts[i].isHolding == false) {
            // 관심 등록 상품 처리 로직
            interestedProducts.add(wholeProducts[i]);
            isThereInterested = true;
          } else {
            holdingProducts.add(wholeProducts[i]);
            isThereHolding = true;
          }
        }

        if (!isDaySelected && !isTodayOrFuture(date)) {
          return const SizedBox.shrink();
        }

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
            if (isThereInterested)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    children: interestedProducts.asMap().entries.map((entry) {
                      int index = entry.key;
                      ElsProductForScheduleDto product = entry.value;
                      return ELSProductCard(product: convertProductForScheduleToSummarized(product), index: index);
                    }).toList(),
                  ),
                ],
              ),
            if (isThereHolding)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    children: holdingProducts.asMap().entries.map((entry) {
                      // int index = entry.key;
                      ElsProductForScheduleDto product = entry.value;
                      return HoldingProductCard(product: convertProductForScheduleToSummarizedHolding(product));
                      // return ELSProductCard(product: convertProductForScheduleToSummarized(product), index: index);
                    }).toList(),
                  ),
                ],
              )
          ],
        );
      }).toList(),
    );
  }
}
