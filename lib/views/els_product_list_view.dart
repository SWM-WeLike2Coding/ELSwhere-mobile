import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_product_provider.dart';
import '../widgets/els_product_card.dart';

class ELSProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    productProvider.resetProducts();
    productProvider.fetchProducts();

    return Scaffold(
      appBar: AppBar(title: Text('상품 목록')),
      body: Consumer<ELSProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading && productProvider.products.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          if (productProvider.products.isEmpty) {
            return Center(child: Text('상품이 존재하지 않습니다.'));
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!productProvider.isLoading &&
                  productProvider.hasNext &&
                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                productProvider.fetchProducts();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                return ELSProductCard(product: productProvider.products[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
