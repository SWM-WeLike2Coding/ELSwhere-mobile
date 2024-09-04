import 'package:elswhere/data/models/dtos/response_single_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyInvestmentStatusView extends StatelessWidget {
  ResponseSingleProductDto? product;

  MyInvestmentStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, provider, _) {
        return const Placeholder();
      },
    );
  }
}
