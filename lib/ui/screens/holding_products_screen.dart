import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/widgets/holding_product_card.dart';
import 'package:flutter/material.dart';

// 이슈들
// 1. 우선 피그마에 있는 글씨 크기 데이터로 개발했는데, 글씨 크기가 너무 작은것 같음
// 2.


class HoldingProductsScreen extends StatefulWidget {
  const HoldingProductsScreen({super.key});

  @override
  State<HoldingProductsScreen> createState() => _HoldingProductsScreenState();
}

class _HoldingProductsScreenState extends State<HoldingProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
        Padding(
          padding: edgeInsetsAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '보유상품',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12,),
              HoldingProductCard(),
              HoldingProductCard(),
            ],
          ),
        )
    );
  }
}
