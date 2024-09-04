import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/product_screen.dart';
import 'package:elswhere/ui/widgets/holding_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HoldingProductsListView extends StatelessWidget {
  HoldingProductsListView({super.key});

  late ELSOnSaleProductsProvider onSaleProductsProvider;
  late ELSEndSaleProductsProvider endSaleProductsProvider;

  void _onTapButton(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return const Center(child: CircularProgressIndicator.adaptive());
        });

    await onSaleProductsProvider.fetchProducts('latest');
    await endSaleProductsProvider.fetchProducts('latest');

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    onSaleProductsProvider = Provider.of<ELSOnSaleProductsProvider>(context, listen: false);
    endSaleProductsProvider = Provider.of<ELSEndSaleProductsProvider>(context, listen: false);

    return Expanded(
      child: Consumer<UserInfoProvider>(builder: (context, provider, _) {
        if (provider.isLoading && provider.holdingProducts == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.holdingProducts != null && provider.holdingProducts!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 6),
              Text(
                '보유 중인 상품이 없어요',
                style: textTheme.headlineSmall!.copyWith(color: const Color(0xFF434648)),
              ),
              const SizedBox(height: 12),
              Text(
                '상품을 골라 추가해 보세요',
                style: textTheme.bodySmall!.copyWith(color: AppColors.contentGray),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => _onTapButton(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: AppColors.backgroundGray,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Text(
                      '상품 보기',
                      style: textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ],
          );
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
      }),
    );
  }
}
