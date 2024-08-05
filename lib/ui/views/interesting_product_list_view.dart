import 'package:elswhere/data/models/dtos/response_interesting_product_dto.dart';
import 'package:elswhere/data/models/dtos/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/els_product_card.dart';

class InterestingProductListView extends StatelessWidget {
  const InterestingProductListView({super.key});

  void _refreshList(BuildContext context) {
    Provider.of<ELSProductProvider>(context, listen: false).fetchInterested();
  }

  SummarizedProductDto convertToSummarizedProduct(ResponseInterestingProductDto interestingProduct) {
    return SummarizedProductDto(
      id: interestingProduct.productId,
      issuer: interestingProduct.issuer,
      name: interestingProduct.name,
      productType: interestingProduct.productType,
      equities: interestingProduct.equities,
      yieldIfConditionsMet: interestingProduct.yieldIfConditionsMet,
      subscriptionStartDate: DateTime.parse(interestingProduct.subscriptionStartDate),
      subscriptionEndDate: DateTime.parse(interestingProduct.subscriptionEndDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: Provider.of<ELSProductProvider>(context, listen: false).fetchInterested(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return Consumer<ELSProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading && productProvider.interestingProducts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productProvider.interestingProducts.isEmpty) {
                  return const Center(child: Text('관심 상품이 존재하지 않습니다.'));
                } else {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!productProvider.isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        productProvider.fetchInterested();
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _refreshList(context);
                      },
                      child: ListView.builder(
                        itemCount: productProvider.interestingProducts.length,
                        itemBuilder: (context, index) {
                          return ELSProductCard(
                            product: convertToSummarizedProduct(productProvider.interestingProducts[index]),
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
