import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/els_products_provider.dart';
import '../resources/app_resource.dart';
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

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin {
  String type = 'latest';
  String selectedValue = '최신순';
  int _tabIndex = 0;

  late final TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 300),
  );
  
  Future<void> typeChanged(BuildContext context, String? value) async {
    //TODO: ProductProvider에 따라서 on sale end sale 구분해서 refresh 해야함
    // switch(_tabIndex) {
      // case 0:
        await Provider.of<ELSOnSaleProductsProvider>(context, listen: false).refreshProducts(value!);
      // case 1:
        await Provider.of<ELSEndSaleProductsProvider>(context, listen: false).refreshProducts(value!);
    // }
    setState(() {
      selectedValue = value!;
      type = widget.itemsMap[value]!;
    });
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
                  onChanged: (String? value) async {
                    await typeChanged(context, value);
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
            ],
          ),
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: '청약 중'),
              Tab(text: '청약 종료'),
            ],
            labelColor: AppColors.contentBlack,
            labelStyle: Theme.of(context).textTheme.displayMedium,
            unselectedLabelColor: AppColors.contentGray,
            unselectedLabelStyle: Theme.of(context).textTheme.displayMedium,
            overlayColor: WidgetStatePropertyAll(AppColors.contentGray),
            splashBorderRadius: BorderRadius.circular(10),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
            indicatorColor: AppColors.contentBlack,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    ELSProductListView<ELSOnSaleProductsProvider>(type: type),
                  ],
                ),
                Column(
                  children: [
                    ELSProductListView<ELSEndSaleProductsProvider>(type: type),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
