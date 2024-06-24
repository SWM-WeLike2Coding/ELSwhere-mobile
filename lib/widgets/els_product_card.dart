import 'package:flutter/material.dart';
import '../models/dtos/summarized_product_dto.dart';

class ELSProductCard extends StatelessWidget {
  final SummarizedProductDto product;

  ELSProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('연이율: ${product.yieldIfConditionsMet}%\n기초자산명: ${product.equities}'),
        trailing: Text('ID: ${product.id}'),
      ),
    );
  }
}
