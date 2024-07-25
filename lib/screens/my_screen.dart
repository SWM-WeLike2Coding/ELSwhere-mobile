import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/screens/attention_products_screen.dart';
import 'package:elswhere/screens/holding_products_screen.dart';
import 'package:elswhere/screens/redempted_products_screen.dart';
import 'package:elswhere/widgets/total_attention_card.dart';
import 'package:elswhere/widgets/total_outcome_card.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// 이슈등
// 1. 카드 안에 오른쪽 화살표 마땅한 아이콘 없어서 텍스트 ">"로 대체
// 2. 각 카드들 높이 설정 및 텍스트 사이 간격 조절 따로 안함
// 3. 사용자 이름 받아오기 해야함
// 4. 청약 상품 상환 일정 및 관심 상품 청약 마감일 관련 data 어떻게 보여줄지 논의해봐야 할 듯
// 5. 달력은 우리 기능대로 동작하려면 커스텀 달력을 만들어야 할 것 같은데, 디자이너가 디자인 한 달력 나오면 그 때 다시 개발하는 것이 좋을 것 같음(우선 달력 라이브러리 사용)

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: edgeInsetsAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '내자산',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12,),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HoldingProductsScreen()),
                );
              },
              child: TotalOutcomeCard(
                isHoldingNow: true,
                numProducts: 4,
                sumOfProperty: 5540000,
                interestRate: 10,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RedemptedProductsScreen()),
                );
              },
              child: TotalOutcomeCard(
                isHoldingNow: false,
                numProducts: 10,
                sumOfProperty: 55540000,
                interestRate: 10,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttentionProductsScreen()),
                );
              },
              child: TotalAttentionCard(numProducts: 4)),
            SizedBox(height: 20,),
            Padding(
              padding: edgeInsetsAll8,
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${DateTime.now().month}월, WL2C님의\n",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: "가입 상품 중 상환 일정이 ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: "2개\n",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "관심 등록한 상품 중 청약 마감이 ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: "3개 ",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "있어요.",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),

          ],
        ),
      ),
    );
  }
}
