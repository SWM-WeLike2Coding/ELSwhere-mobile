import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/analysis/ai_product_provider.dart';
import 'package:elswhere/ui/widgets/hot_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AIRecommendationProductsListView extends StatelessWidget {
  const AIRecommendationProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AIProductProvider>(
      builder: (context, provider, child) {
        final items = provider.aiRecommendationProducts;
        if (items.isEmpty) {
          // return Center(child: Text('현재 추천 상품이 없습니다.', style: textTheme.M_16.copyWith(color: AppColors.gray700)));
          return Stack(children: [
            ListView(),
            Center(child: Text('현재 추천 상품이 없습니다.\n', style: textTheme.M_16.copyWith(color: AppColors.gray700))),
          ]);
        } else {
          return ListView.builder(
            itemCount: provider.aiRecommendationProducts.length,
            itemBuilder: (context, index) {
              return HotProductCard(rank: index + 1, product: items[index]);
            },
          );
        }
      },
    );
  }
}
