import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/els_products_provider.dart';
import '../views/els_product_list_view.dart';
import '../widgets/els_product_card.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ELSProductListView();
    // final productProvider = Provider.of<ELSProductsProvider>(context, listen: false);
    // productProvider.resetProducts();
    // return Expanded(
    //   child: FutureBuilder(
    //     future: productProvider.fetchProducts(),
    //     builder: (ctx, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       } else if (snapshot.hasError) {
    //         return Center(child: Text('오류가 발생했습니다'));
    //       } else {
    //         return Consumer<ELSProductsProvider>(
    //             builder: (context, productsProvider, child) {
    //           if (productsProvider.isLoading &&
    //               productsProvider.products.isEmpty) {
    //             return const Center(child: CircularProgressIndicator());
    //           }
    //           if (productsProvider.products.isEmpty) {
    //             return const Center(child: Text('상품이 존재하지 않습니다.'));
    //           }
    //           return NotificationListener<ScrollNotification>(
    //             onNotification: (ScrollNotification scrollInfo) {
    //               if (!productsProvider.isLoading &&
    //                   productsProvider.hasNext &&
    //                   scrollInfo.metrics.pixels ==
    //                       scrollInfo.metrics.maxScrollExtent) {
    //                 productsProvider.fetchProducts();
    //               }
    //               return false;
    //             },
    //             child: ListView.builder(
    //               itemCount: productsProvider.products.length,
    //               itemBuilder: (context, index) {
    //                 return ELSProductCard(
    //                     product: productsProvider.products[index]);
    //               },
    //             ),
    //           );
    //         });
    //       }
    //     },
    //   ),
    // );

    // return const Placeholder();
    return ELSProductListView();
    //
    // Center(
    //   child: ElevatedButton(
    //     onPressed: () async {
    //       productProvider.resetProducts();
    //       await productProvider.fetchProducts();
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => ELSProductListView()),
    //       );
    //     },
    //     child: const Text('ELS 상품 조회'),
    //   ),
    // );
  }
}
