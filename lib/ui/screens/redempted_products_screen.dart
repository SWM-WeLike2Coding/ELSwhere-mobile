import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/widgets/holding_product_card.dart';
import 'package:flutter/material.dart';


class RedemptedProductsScreen extends StatefulWidget {
  const RedemptedProductsScreen({super.key});

  @override
  State<RedemptedProductsScreen> createState() => _RedemptedProductsScreenState();
}

class _RedemptedProductsScreenState extends State<RedemptedProductsScreen> {
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
                '상환완료 상품',
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
