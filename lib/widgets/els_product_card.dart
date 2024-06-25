import 'package:elswhere/widgets/els_detail_dialog.dart';
import 'package:flutter/material.dart';
import '../models/dtos/summarized_product_dto.dart';

class ELSProductCard extends StatelessWidget {
  final SummarizedProductDto product;

  ELSProductCard({required this.product});

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ELSDetailDialog(elsProduct: product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        onTap: () {
          _showDialog(context);
        },
      ),
    );
  }
}
