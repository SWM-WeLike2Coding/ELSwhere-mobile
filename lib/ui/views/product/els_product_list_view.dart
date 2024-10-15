import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/product/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/els_product_card.dart';

class ELSProductListView<T extends ELSProductsProvider> extends StatelessWidget {
  final String type;
  bool nowComparing;
  void Function(bool, SummarizedProductDto)? checkCompare;
  late ELSProductsProvider provider;

  ELSProductListView({super.key, this.checkCompare, required this.type, required this.nowComparing});

  void _refreshList(BuildContext context) {
    Provider.of<T>(context, listen: false).refreshProducts(type);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<T>(context, listen: false);
    print(type);
    return Expanded(
      child: FutureBuilder(
        future: provider.isInit ? provider.initProducts(type) : null,
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
                      color: AppColors.mainBlue,
                      onRefresh: () async {
                        _refreshList(context);
                      },
                      child: Stack(children: [
                        ListView(),
                        const Center(child: Text('상품이 존재하지 않습니다.')),
                      ]),
                    );
                  } else {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!productsProvider.isLoading && productsProvider.hasNext && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                          productsProvider.fetchProducts(type);
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        color: AppColors.mainBlue,
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
                    return const Center(child: Text('상품이 존재하지 않습니다.'));
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
