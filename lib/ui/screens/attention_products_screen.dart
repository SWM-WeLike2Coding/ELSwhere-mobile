import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/screens/attention_setting_screen.dart';
import 'package:elswhere/ui/views/els_product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/providers/els_products_provider.dart';


class AttentionProductsScreen extends StatefulWidget {
  const AttentionProductsScreen({super.key});

  @override
  State<AttentionProductsScreen> createState() => _AttentionProductsScreenState();
}

class _AttentionProductsScreenState extends State<AttentionProductsScreen> {
  String type = 'latest';

  @override
  Widget build(BuildContext context) {
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
              "관심 상품",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Color(0xFFF5F6F6),
                  child: Icon(
                    Icons.add,
                    size: 24,
                    color: Color(0xFF595E62),
                  ),
                ),
                onPressed: () {

                },
              ),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Color(0xFFF5F6F6),
                  child: Icon(
                    Icons.settings,
                    size: 24,
                    color: Color(0xFF595E62),
                  ),
                ),
                onPressed: () {

                },
              ),
              SizedBox(width: 16 ,),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildGetAlarmCard(context),
          _buildMyAttentionProductString(),
          ELSProductListView<ELSOnSaleProductsProvider>(type: type),
        ],
      ),
    );
  }
}


Widget _buildGetAlarmCard(BuildContext context) {
  const String girlIcon = "assets/icons/icon_girl_with_coin.svg";

  return Padding(
    padding: EdgeInsets.only(top: 16, left: 24, right: 24),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttentionSettingScreen(),
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFF1C6BF9),
        ),
        width: double.infinity,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24, top: 29, bottom: 29),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "조건별 알림 받기",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.18,
                      letterSpacing: -0.36,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    "원하는 조건을 등록하여 새로운\n상품이 나올 때 알림을 받아보세요!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.18,
                      letterSpacing: -0.24,
                      color: Color(0xFFCFD2D3),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 10, right: 10),
              child: SvgPicture.asset(
                girlIcon,
                width: 96,
                height: 144,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMyAttentionProductString() {
  return Padding(
    padding: EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 16),
    child: Container(
      width: double.infinity,
      child: Text(
        "내 관심 상품",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.18,
          letterSpacing: -0.32,
          color: Color(0xFF131415),
        ),
      ),
    ),
  );
}