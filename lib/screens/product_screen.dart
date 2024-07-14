import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/els_products_provider.dart';
import '../views/els_product_list_view.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Future<Widget> build(BuildContext context) async {
    final productProvider = Provider.of<ELSProductsProvider>(context, listen: false);
    productProvider.resetProducts();
    FutureBuilder(
        future: productProvider.fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<ELSProductsProvider>(
              builder: (ctx, productProvider, child) => ListView.builder(
                itemCount: productProvider.products.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(productProvider.products[index].name),
                ),
              ),
            );
          }
        },

    return ELSProductListView();

    Center(
      child: ElevatedButton(
        onPressed: () async {
          productProvider.resetProducts();
          await productProvider.fetchProducts();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ELSProductListView()),
          );
        },
        child: const Text('ELS 상품 조회'),
      ),
    );
  }
}
