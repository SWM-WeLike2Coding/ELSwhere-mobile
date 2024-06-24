import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_product_provider.dart';
import 'els_product_list_view.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ELSProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('임시 메인')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await productProvider.fetchProducts();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ELSProductListView()),
            );
          },
          child: Text('ELS 상품 조회'),
        ),
      ),
    );
  }
}
