import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/widgets/holding_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HoldingProductsListView extends StatelessWidget {
  const HoldingProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<UserInfoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.holdingProducts == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.holdingProducts == null) {
            return const Center(child: Text('보유 중인 상품이 없습니다.'));
          } else {
            return ListView.builder(
              itemCount: provider.holdingProducts!.length,
              itemBuilder: (context, index) {
                return HoldingProductCard(
                  product: provider.holdingProducts![index],
                );
              },
            );
          }
        }
      ),
    );
  }
}
