 import 'package:elswhere/ui/widgets/stock_index_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F6F6),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF5F6F6),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildAppBar(),
                _buildInvestmentTasteTestWidget(),
                _buildHoldingProductAssetWidget(),
                _buildHotAndAttentionProductWidget(),
                _buildAttentionScheduleWidget(),
                _buildIndexWidget(),
                SizedBox(height: 32,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildAppBar() {
  const String tempIcon = "assets/icons/icon_temp_logo.svg";

  return Padding(
    padding: EdgeInsets.only(left: 24, right: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          tempIcon,
          width: 24,
          height: 24,
        ),
        IconButton(
          onPressed: () {

          },
          icon: Icon(
            Icons.notifications_none,
            size: 24,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInvestmentTasteTestWidget() {
  const String profileIcon = "assets/icons/icon_profile.svg";
  return Padding(
    padding: EdgeInsets.only(left: 24, right: 24, top: 24),
    child: Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
            spreadRadius: 0, // 확산 반경
            blurRadius: 16, // 블러 반경
            offset: Offset(0, 0), // 그림자의 x, y 오프셋
          ),
        ]
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "나에게 딱 맞는 상품 추천",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF838A8E),
                  ),
                ),
                Text(
                  "나의 투자 성향을 진단하기",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: SvgPicture.asset(
              profileIcon,
              height: 36,
              width: 36,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildHoldingProductAssetWidget() {
  return Padding(
    padding: EdgeInsets.only(left: 24, right: 24, top: 16),
    child: Container(
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
              spreadRadius: 0, // 확산 반경
              blurRadius: 16, // 블러 반경
              offset: Offset(0, 0), // 그림자의 x, y 오프셋
            ),
          ]
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "보유 상품 가치",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.18, // 118% line-height
                letterSpacing: -0.28,
                color: Color(0xFF838A8E),
              ),
            ),
            SizedBox(height: 4,),
            Text(
              "2,000,000원",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.30, // 118% line-height
                letterSpacing: -0.44,
                color: Color(0xFF000000),
              ),
            ),
            SizedBox(height: 4,),
            Text(
              "+1,000,000원",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.18, // 118% line-height
                letterSpacing: -0.28,
                color: Color(0xFFEE5648),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildHotAndAttentionProductWidget() {
  return Padding(
    padding: EdgeInsets.only(top: 16, left: 24, right: 24),
    child: Row(
      children: [
        Expanded(child: _buildHotProductButton()),
        SizedBox(width: 8,),
        Expanded(child: _buildAttentionProductButton()),
      ],
    ),
  );
}

Widget _buildHotProductButton() {
  const String hotIcon = "assets/icons/icon_hot.svg";
  return Container(
    height: 100,
    decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
            spreadRadius: 0, // 확산 반경
            blurRadius: 16, // 블러 반경
            offset: Offset(0, 0), // 그림자의 x, y 오프셋
          ),
        ],
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            hotIcon,
            height: 24,
            width: 17.86,
          ),
          // SizedBox(height: 19,),
          Text(
            "가장 핫한 상품",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.18,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildAttentionProductButton() {
  const String attentionIcon = "assets/icons/icon_attention.svg";
  return Container(
    height: 100,
    decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
            spreadRadius: 0, // 확산 반경
            blurRadius: 16, // 블러 반경
            offset: Offset(0, 0), // 그림자의 x, y 오프셋
          ),
        ],
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            attentionIcon,
            height: 32,
            width: 32,
          ),
          // SizedBox(height: 19,),
          Text(
            "내 관심 상품",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.18,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildAttentionScheduleWidget() {
  return Padding(
    padding: EdgeInsets.only(top: 16, left: 24, right: 24),
    child: Container(
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
              spreadRadius: 0, // 확산 반경
              blurRadius: 16, // 블러 반경
              offset: Offset(0, 0), // 그림자의 x, y 오프셋
            ),
          ]
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "관심 청약 일정",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.18,
                letterSpacing: -0.32,
                color: Color(0xFF000000),
              ),
            ),
            SizedBox(height: 8,),
            Text(
              "곧 다가오는 청약 상품 일정이에요.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.18,
                letterSpacing: -0.24,
                color: Color(0xFF838A8E),
              ),
            ),
            SizedBox(height: 150,),
          ],
        ),
      ),
    ),
  );
}

Widget _buildIndexWidget() {
  return Padding(
    padding: EdgeInsets.only(top: 16, left: 24, right: 24),
    child: Container(
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
              spreadRadius: 0, // 확산 반경
              blurRadius: 16, // 블러 반경
              offset: Offset(0, 0), // 그림자의 x, y 오프셋
            ),
          ]
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "전일 주가 지수",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.18,
                letterSpacing: -0.32,
                color: Color(0xFF000000),
              ),
            ),
            SizedBox(height: 16,),
            StockIndexList(),
          ],
        ),
      ),
    ),
  );
}