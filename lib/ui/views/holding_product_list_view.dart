import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                if (productsProvider.isLoading &&
                    productsProvider.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (productsProvider.products.isEmpty) {
                  return const Center(child: Text('상품이 존재하지 않습니다.'));
                }
                else {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!productsProvider.isLoading &&
                          productsProvider.hasNext &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        productsProvider.fetchProducts(type);
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      color: AppColors.mainBlue,
                      onRefresh: () async {
                        productsProvider.refreshProducts(type);
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
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}