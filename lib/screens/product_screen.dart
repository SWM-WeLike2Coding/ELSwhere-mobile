import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_products_provider.dart';
import '../resources/app_resource.dart';
import '../views/detail_search_modal.dart';
import '../views/els_product_list_view.dart';
import '../widgets/search_text_field.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({super.key});

  final List<String> items = [
    '최신순',
    '낙인순',
    '수익률순',
  ];

  final Map<String, String> itemsMap = {
    '최신순': 'latest',
    '낙인순': 'knock-in',
    '수익률순': 'profit',
  };

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String type = 'latest';
  String selectedValue = '최신순';

  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _initializeProducts();
    print('Hello: $_productsFuture');
  }

  Future<void> _initializeProducts() async {
    await Provider.of<ELSProductsProvider>(context, listen: false).refreshProducts(type);
  }

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
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: widget.items.map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  )).toList(),
                  value: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                      type = widget.itemsMap[value]!;
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    height: 40,
                    width: 90,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                ),
              ),
              // TextButton.icon(
              //   icon: const Icon(Icons.filter_list),
              //   label: const Text(
              //     '필터링',
              //     style: TextStyle(fontWeight: FontWeight.w600),
              //   ),
              //   style: TextButton.styleFrom(
              //     foregroundColor: AppColors.contentBlack,
              //   ),
              //   onPressed: () {
              //     showModalBottomSheet(
              //         context: context,
              //         isScrollControlled: true,
              //         useSafeArea: true,
              //         builder: (context) => const DetailSearchModal(),
              //     );
              //   },
              // ),
            ],
          ),
          ELSProductListView(type: type),
        ],
      ),
    );
  }
}
