import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/els_product_card.dart';

class ELSProductListView<T extends ELSProductsProvider> extends StatelessWidget {
  const ELSProductListView({super.key, required this.type});

  final String type;

  void _refreshList(BuildContext context) {
    Provider.of<T>(context, listen: false).refreshProducts(type);
  }

  @override
  Widget build(BuildContext context) {
    print(type);
    return Expanded(
      child: FutureBuilder(
        future: Provider.of<T>(context, listen: false).initProducts(type),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return Consumer<T>(
              builder: (context, productsProvider, child) {
                if (productsProvider.isLoading && productsProvider.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productsProvider.products.isEmpty) {
                  return const Center(child: Text('상품이 존재하지 않습니다.'));
                } else {
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
                      onRefresh: () async {
                        _refreshList(context);
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