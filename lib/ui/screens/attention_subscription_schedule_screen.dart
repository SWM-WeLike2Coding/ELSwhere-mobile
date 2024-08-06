import 'package:elswhere/data/models/dtos/els_product_for_schedule_dto.dart';
import 'package:elswhere/data/models/dtos/response_interesting_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/ui/screens/redemption_schedule_screen.dart';
import 'package:elswhere/ui/screens/subscription_end_schedule_screen.dart';
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

  bool isTodayOrFuture(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isAfter(today) || targetDate.isAtSameMomentAs(today);
  }

  @override
  Widget build(BuildContext context) {
    var interestingProducts = Provider.of<ELSProductProvider>(context, listen: false).interestingProducts;
    Map<DateTime, List<ElsProductForScheduleDto>> tempScheduleMap = {};

    for (int i = 0; i < interestingProducts.length; i++) {
      print(interestingProducts[i].subscriptionEndDate);
      if (tempScheduleMap.containsKey(interestingProducts[i].subscriptionEndDate)) {
        tempScheduleMap[interestingProducts[i].subscriptionEndDate]!.add(convertInterestingProductToProductForSchedule(interestingProducts[i]));
      } else {
        tempScheduleMap[interestingProducts[i].subscriptionEndDate] = [convertInterestingProductToProductForSchedule(interestingProducts[i])];
      }
    }

    // 나중에 여기에 보유 상품 관련 정보들도 DTO 변환해서 tempScheduleMap에 넣어줘야함!!!

    List<DateTime> sortedDates = tempScheduleMap.keys.toList()..sort();
    Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap = { for (var key in sortedDates) key : tempScheduleMap[key]! };

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: AppColors.backgroundGray,
                    width: 1,
                  )
              )
          ),
          child: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
              child: Align(
                alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            title: Text(
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
            _buildTwoGreyCards(context),
            _buildScheduleCalendar(),
            _buildSchedules(scheduleMap),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGreyCard(BuildContext context, String text, int numItems) {
    return GestureDetector(
      onTap: () {
        if (text == "가입 상품 중 상환 일정") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RedemptionScheduleScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubscriptionEndScheduleScreen(),
            ),
          );
        }
      },
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFFF5F6F6),
        ),
        child: Row(
          children: [
            SizedBox(width: 16,),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.18,
                letterSpacing: -0.28,
                color: Color(0xFF434648),
              ),
            ),
            Spacer(),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF000000),
              ),
              child: Center(
                child: Text(
                  "${numItems}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.18,
                    letterSpacing: -0.28,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16,),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoGreyCards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreyCard(context, "가입 상품 중 상환 일정", 2),
          SizedBox(height: 8,),
          _buildGreyCard(context, "관심 등록 상품 중 청약 마감", 3),
        ],
      ),
    );
  }

  Widget _buildScheduleCalendar() {
    TextStyle calendarTextStyle = TextStyle(
      color: Color(0xFF000000),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.18,
      letterSpacing: -0.28,
    );

    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
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
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
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
          todayTextStyle: TextStyle(
            color: Color(0xFF1C6BF9),
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.18,
            letterSpacing: -0.28,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          cellAlignment: Alignment.center, // 셀 안의 날짜 가운데 정렬
        ),
        daysOfWeekHeight: 31,
        rowHeight: 56,
        headerStyle: HeaderStyle(
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMMM('ko').format(date), // 헤더 텍스트 한글로 포맷
          formatButtonVisible: false,
          leftChevronIcon: Icon(
            Icons.arrow_left,
            color: Color(0xFFCFD2D3),
          ),
          rightChevronIcon: Icon(
            Icons.arrow_right,
            color: Color(0xFFCFD2D3),
          ),
          leftChevronMargin: EdgeInsets.zero,
          rightChevronMargin: EdgeInsets.only(left: 10),
          titleCentered: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            height: 1.18,
            letterSpacing: -0.36,
          ),
          headerMargin: EdgeInsets.zero,
          headerPadding: EdgeInsets.only(left: 8),
        ),
        locale: 'ko_KR',
      ),
    );
  }

  Widget _buildSchedules(Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap) {
    DateTime now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // children: scheduleMap.entries.where((entry) => entry.key.isAfter(now)).map((entry){
      children: scheduleMap.entries.where((entry) => isTodayOrFuture(entry.key)).map((entry){
      // children: scheduleMap.entries.map((entry){
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


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Text(
                "${date.month}월 ${date.day}일",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 16.52 / 14,
                  letterSpacing: -0.02,
                  color: Color(0xFF838A8E),
                ),
              ),
            ),
            if (isThereInterested)
              Padding(
                padding: EdgeInsets.only(top: 16, bottom:16, left: 24, right: 24),
                child: Text(
                  "청약 마감",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 18.88 / 16,
                    letterSpacing:  -0.02,
                    color: Color(0xFF131415),
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
        );
      }).toList(),
    );
  }
}
