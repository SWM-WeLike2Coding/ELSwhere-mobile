import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_products_provider.dart';
import '../widgets/els_product_card.dart';

class HoldingProductListView extends StatelessWidget {
  const HoldingProductListView({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: Provider.of<ELSProductsProvider>(context, listen: false).refreshProducts(type),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return Consumer<ELSProductsProvider>(
              builder: (context, productsProvider, child) {
                Widget body;
                if (productsProvider.isLoading &&
                    productsProvider.products.isEmpty) {
                  body = const Center(child: CircularProgressIndicator());
                }
                else if (productsProvider.products.isEmpty) {
                  body = const Center(child: Text('상품이 존재하지 않습니다.'));
                }
                else {
                  body = NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!productsProvider.isLoading &&
                          productsProvider.hasNext &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        productsProvider.fetchProducts(type);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: productsProvider.products.length,
                      itemBuilder: (context, index) {
                        return ELSProductCard(
                          product: productsProvider.products[index],
                          index: index,
                        );
                      },
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    productsProvider.refreshProducts(type);
                  },
                  child: body,
                );
              },
            );
          }
        },
      ),
    );
  }
}