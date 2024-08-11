import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/widgets/holding_product_card.dart';
import 'package:flutter/material.dart';

import '../../data/providers/els_products_provider.dart';
import '../views/els_product_list_view.dart';

class HoldingProductsScreen extends StatefulWidget {
  const HoldingProductsScreen({super.key});

  @override
  State<HoldingProductsScreen> createState() => _HoldingProductsScreenState();
}

class _HoldingProductsScreenState extends State<HoldingProductsScreen> {
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
          ELSProductListView<ELSOnSaleProductsProvider>(type: type, nowComparing: false,),
        ],
      ),
    );
  }
}

Widget _buildHoldingProductsString() {
  return Padding(
    padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
    child: Container(
      width: double.infinity,
      child: Text(
        "투자 중인 상품",
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

