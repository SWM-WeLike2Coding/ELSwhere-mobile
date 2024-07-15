import 'package:flutter/material.dart';
import '../resources/app_resource.dart';
import '../views/detail_search_modal.dart';
import '../views/els_product_list_view.dart';
import '../widgets/search_text_field.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String type = 'latest';

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
                      builder: (context) => const DetailSearchModal(),
                  );
                },
              ),
            ],
          ),
          ELSProductListView(type: type),
        ],
      ),
    );
  }
}
