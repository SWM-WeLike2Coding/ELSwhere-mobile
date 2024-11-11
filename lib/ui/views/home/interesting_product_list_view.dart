import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/product/summarized_product_dto.dart';
import 'package:elswhere/data/providers/product/els_product_provider.dart';
import 'package:elswhere/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/dtos/user/response_interesting_product_dto.dart';
import '../../widgets/els_product_card.dart';

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
      knockIn: interestingProduct.knockIn,
      subscriptionStartDate: interestingProduct.subscriptionStartDate,
      subscriptionEndDate: interestingProduct.subscriptionEndDate,
      safetyScore: interestingProduct.safetyScore,
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
                      if (!productProvider.isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        productProvider.fetchInterested();
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      color: AppColors.mainBlue,
                      onRefresh: () async {
                        _refreshList(context);
                      },
                      child: ListView.builder(
                        itemCount: productProvider.interestingProducts.length,
                        itemBuilder: (context, index) {
                          final product = productProvider.interestingProducts[index];
                          final date = product.subscriptionEndDate;
                          final isOnSale = isDateAfterOrSame(date);
                          return ELSProductCard(
                            key: ValueKey(product.productId),
                            product: convertToSummarizedProduct(product),
                            index: index,
                            isOnSale: isOnSale,
                            showAIResult: isOnSale,
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
