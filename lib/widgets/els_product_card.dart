import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/views/els_product_detail_view.dart';
import 'package:elswhere/widgets/els_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dtos/summarized_product_dto.dart';
import '../providers/els_product_provider.dart';

class ELSProductCard extends StatelessWidget {
  final SummarizedProductDto product;

  const ELSProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ELSProductProvider>(context, listen: false);

    return Card(
      elevation: 3,
      child: InkWell(
        child: Container(
          padding: edgeInsetsAll12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.contentPurple,
                AppColors.contentPurple.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadiusCircular10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.contentWhite,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.equities,
                      style: const TextStyle(color: AppColors.contentWhite),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.subscriptionStartDate}',
                      style: const TextStyle(color: AppColors.contentWhite),
                    ),
                  ],
                ),
              ),
              Text(
                '${product.yieldIfConditionsMet}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.contentWhite,
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          await productProvider.fetchProduct(product.id);

          // 로딩 다이얼로그 닫기
          Navigator.of(context).pop();

          if (productProvider.product != null) {
            // ELSDetailDialog.show(context, productProvider.product!);
            MaterialPageRoute(builder: (context) => ELSProductDetailView());
          }
        },
      ),
    );
  }
}
