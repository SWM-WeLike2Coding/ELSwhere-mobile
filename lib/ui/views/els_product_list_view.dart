import 'package:elswhere/data/models/dtos/response_single_product_dto.dart';
import 'package:elswhere/data/models/dtos/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/els_product_card.dart';

class ELSProductListView<T extends ELSProductsProvider> extends StatelessWidget {
  final String type;
  bool nowComparing;
  void Function(bool, SummarizedProductDto)? checkCompare;

  ELSProductListView({super.key, this.checkCompare, required this.type, required this.nowComparing});

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
                if (!nowComparing) {
                  if (productsProvider.isLoading && productsProvider.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productsProvider.products.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        _refreshList(context);
                      },
                      child: ListView(
                        children: const [
                          Expanded(child: Center(child: Text('상품이 존재하지 않습니다.'))),
                        ],
                      ),
                    );
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
                              key: ValueKey(productsProvider.products[index].id),
                              product: productsProvider.products[index],
                              index: index,
                              checkCompare: checkCompare,
                              isOnSale: productsProvider.runtimeType == ELSOnSaleProductsProvider,
                            );
                          },
                        ),
                      ),
                    );
                  }
                } else {
                  if (productsProvider.isLoading && productsProvider.similarProducts == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productsProvider.similarProducts == null || productsProvider.similarProducts!.results.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        _refreshList(context);
                      },
                      child: ListView(
                        children: const [
                          Expanded(child: Center(child: Text('상품이 존재하지 않습니다.'))),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: productsProvider.similarProducts!.results.length,
                      itemBuilder: (context, index) {
                        return ELSProductCard(
                          key: ValueKey(productsProvider.similarProducts!.results[index].id),
                          product: productsProvider.similarProducts!.results[index],
                          index: index,
                          checkCompare: checkCompare,
                          isOnSale: productsProvider.runtimeType == ELSOnSaleProductsProvider,
                        );
                      },
                    );
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}