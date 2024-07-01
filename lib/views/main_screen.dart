import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_products_provider.dart';
import 'els_product_list_view.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ELSProductsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('임시 메인')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            productProvider.resetProducts();
            await productProvider.fetchProducts();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ELSProductListView()),
            );
          },
          child: const Text('ELS 상품 조회'),
        ),
      ),
    );
  }
}
