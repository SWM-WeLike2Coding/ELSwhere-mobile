import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_products_provider.dart';
import '../widgets/els_product_card.dart';

class ELSProductListView extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('상품 목록')),
  //     body: Consumer<ELSProductsProvider>(
  //       builder: (context, productsProvider, child) {
  //         if (productsProvider.isLoading && productsProvider.products.isEmpty) {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //         if (productsProvider.products.isEmpty) {
  //           return Center(child: Text('상품이 존재하지 않습니다.'));
  //         }
  //         return NotificationListener<ScrollNotification>(
  //           onNotification: (ScrollNotification scrollInfo) {
  //             if (!productsProvider.isLoading &&
  //                 productsProvider.hasNext &&
  //                 scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
  //               productsProvider.fetchProducts();
  //             }
  //             return false;
  //           },
  //           child: ListView.builder(
  //             itemCount: productsProvider.products.length,
  //             itemBuilder: (context, index) {
  //               return ELSProductCard(product: productsProvider.products[index]);
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ELSwhere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ELS 상품',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: '키워드 입력',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: Container(
                  margin: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () {},
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.blue, // 버튼의 색상
                    // ),
                    child: const Text('검색'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '상품 목록',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
            Expanded(
              child: Consumer<ELSProductsProvider>(
                builder: (context, productsProvider, child) {
                  if (productsProvider.isLoading && productsProvider.products.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (productsProvider.products.isEmpty) {
                    return Center(child: Text('상품이 존재하지 않습니다.'));
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!productsProvider.isLoading &&
                          productsProvider.hasNext &&
                          scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        productsProvider.fetchProducts();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: productsProvider.products.length,
                      itemBuilder: (context, index) {
                        return ELSProductCard(product: productsProvider.products[index]);
                      },
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '상품',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MY',
          ),
        ],
        currentIndex: 0,
        // selectedItemColor: Colors.blue,
        onTap: (index) {},
      ),
    );
  }
}
