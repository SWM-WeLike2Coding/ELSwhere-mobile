import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/views/detail_search_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_products_provider.dart';
import '../widgets/els_product_card.dart';
import '../widgets/search_text_field.dart';

class ELSProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsetsAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ELS 상품',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: SearchTextField()),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: borderRadiusCircular10),
                    fixedSize: const Size(50, 50),
                    foregroundColor: AppColors.contentWhite,
                    backgroundColor: AppColors.contentPurple,
                  ),
                  child: const FittedBox(
                    fit: BoxFit.none,
                    child: Text(
                      '검색',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '상품 목록',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                icon: const Icon(Icons.filter_list),
                label: const Text(
                  '필터링',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.contentBlack,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      // constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height*0.8),
                      builder: (context) => const DetailSearchModal());
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<ELSProductsProvider>(context, listen: false).fetchProducts(),
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
                      if (productsProvider.products.isEmpty) {
                        return const Center(child: Text('상품이 존재하지 않습니다.'));
                      }
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!productsProvider.isLoading &&
                              productsProvider.hasNext &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            productsProvider.fetchProducts();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: productsProvider.products.length,
                          itemBuilder: (context, index) {
                            return ELSProductCard(
                                product: productsProvider.products[index]);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
