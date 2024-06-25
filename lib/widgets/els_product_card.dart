import 'package:elswhere/widgets/els_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dtos/summarized_product_dto.dart';
import '../providers/els_product_provider.dart';

class ELSProductCard extends StatelessWidget {
  final SummarizedProductDto product;

  ELSProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ELSProductProvider>(context, listen: false);

    return Card(
      child: InkWell(
        child: ListTile(
          title: Text(
            product.name,
            style: const TextStyle(
              letterSpacing: 0.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'ID: ${product.id}\n기초자산명: ${product.equities}',
            style: const TextStyle(letterSpacing: 0.1),
          ),
          trailing: Text(
            '${product.yieldIfConditionsMet}%',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.circle),
        ),
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          await productProvider.fetchProduct(product.id);

          // 로딩 다이얼로그 닫기
          Navigator.of(context).pop();

          if (productProvider.product != null) {
            ELSDetailDialog.show(context, productProvider.product!);
          }
        },
      ),
    );
  }
}
