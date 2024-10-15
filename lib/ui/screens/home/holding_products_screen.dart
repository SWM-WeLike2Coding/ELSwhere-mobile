import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/views/home/holding_products_list_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class HoldingProductsScreen extends StatefulWidget {
  const HoldingProductsScreen({super.key});

  @override
  State<HoldingProductsScreen> createState() => _HoldingProductsScreenState();
}

class _HoldingProductsScreenState extends State<HoldingProductsScreen> {
  String type = 'latest';
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '보유 상품 화면',
      screenClass: 'HoldingProductsScreen',
    );
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.gray50,
                width: 1,
              ),
            ),
          ),
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
              "보유 상품",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHoldingProductsString(),
          HoldingProductsListView(),
        ],
      ),
    );
  }
}

Widget _buildHoldingProductsString() {
  return const Padding(
    padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        "투자 중인 상품",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.18,
          letterSpacing: -0.32,
          color: AppColors.gray950,
        ),
      ),
    ),
  );
}
