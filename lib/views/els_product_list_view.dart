import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_products_provider.dart';
import '../widgets/els_product_card.dart';

class ELSProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상품 목록')),
      body: Consumer<ELSProductsProvider>(
        builder: (context, productsProvider, child) {
          if (productsProvider.isLoading && productsProvider.products.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          if (productsProvider.products.isEmpty) {
            return Center(child: Text('상품이 존재하지 않습니다.'));
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!productsProvider.isLoading &&
                  productsProvider.hasNext &&
                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                productsProvider.fetchProducts();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: productsProvider.products.length,
              itemBuilder: (context, index) {
                return ELSProductCard(product: productsProvider.products[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
