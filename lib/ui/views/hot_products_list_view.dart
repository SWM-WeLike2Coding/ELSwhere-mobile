import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/hot_products_provider.dart';
import 'package:elswhere/ui/widgets/hot_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HotProductsListView extends StatelessWidget {
  const HotProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<HotProductsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.hotProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (!provider.isLoading && provider.hotProducts.isEmpty) {
            return const Center(child: Text(MSG_NO_HOT_PRODUCTS));
          } else {
            return ListView.builder(
              itemCount: provider.hotProducts.length,
              itemBuilder: (context, index) {
                return HotProductCard(
                  key: ValueKey(provider.hotProducts[index]),
                  rank: index + 1,
                  product: provider.hotProducts[index],
                );
              },
            );
          }
        },
      ),
    );
  }
}
