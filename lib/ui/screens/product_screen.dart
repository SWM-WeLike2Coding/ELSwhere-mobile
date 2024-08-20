import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/ui/screens/notification_screen.dart';
import 'package:elswhere/ui/widgets/els_product_card.dart';
import 'package:elswhere/ui/widgets/stock_index_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool applyTendency = false;
  int _tabIndex = 0;
  bool nowComparing = false;
  int selectedIndex = -1;
  int _count = 0;

  late final TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 300),
  );

  void checkComparing(bool isCompare, int index) {
    setState(() {
      nowComparing = isCompare;
      selectedIndex = index;
    });
  }
  
  Future<void> typeChanged(BuildContext context, String? value) async {
    //TODO: ProductProvider에 따라서 on sale end sale 구분해서 refresh 해야함
    // switch(_tabIndex) {
    //   case 0:
    //     await Provider.of<ELSOnSaleProductsProvider>(context, listen: false).refreshProducts(value!);
    //   case 1:
    //     await Provider.of<ELSEndSaleProductsProvider>(context, listen: false).refreshProducts(value!);
    // }
    setState(() {
      selectedValue = value!;
      type = widget.itemsMap[value]!;
      Provider.of<ELSOnSaleProductsProvider>(context, listen: false).sortProducts(value);
      Provider.of<ELSEndSaleProductsProvider>(context, listen: false).sortProducts(value);
    });
  }

  void _changeTendency(bool value) {
    setState(() {
      applyTendency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: edgeInsetsAll8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!nowComparing) ...[
              _buildSearchTextField(),
              _buildTabBar(),
            ],
            if (nowComparing) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '선택한 상품',
                  style: textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  )
                ),
              ),
              ELSProductCard<SummarizedProductDto>(product: Provider.of<ELSOnSaleProductsProvider>(context, listen: false).products[selectedIndex], index: selectedIndex),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: edgeInsetsAll8,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        '정렬 기준을 선택해주세요.',
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
                ),
                Padding(
                  padding: edgeInsetsAll8,
                  child: Row(
                    children: [
                      Text(
                        '투자 성향 반영',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 14,
                          color: AppColors.contentGray,
                        )
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Switch(
                            value: applyTendency,
                            onChanged: (value) => _changeTendency(value),
                            inactiveTrackColor: AppColors.contentGray,
                            trackOutlineWidth: const WidgetStatePropertyAll(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    children: [
                      ELSProductListView<ELSOnSaleProductsProvider>(type: type, nowComparing: nowComparing, checkCompare: checkComparing,),
                    ],
                  ),
                  Column(
                    children: [
                      ELSProductListView<ELSEndSaleProductsProvider>(type: type, nowComparing: nowComparing, checkCompare: checkComparing,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: nowComparing
        ? _buildFloatingButton(context)
        : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const Padding(
        padding: edgeInsetsAll8,
        child: StockIndexCardSwiper(),
      ),
      leadingWidth: double.infinity,
      actions: [
        Padding(
          padding: edgeInsetsAll8,
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 30,),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen(),)
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTextField() {
    return const Row(
      children: [
        Expanded(
          child: Padding(
            padding: edgeInsetsAll8,
            child: SearchTextField(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: edgeInsetsAll8,
      child: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: '청약 중'),
          Tab(text: '청약 종료'),
        ],
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        labelColor: AppColors.contentBlack,
        labelStyle: Theme.of(context).textTheme.displayMedium,
        unselectedLabelColor: AppColors.contentGray,
        unselectedLabelStyle: Theme.of(context).textTheme.displayMedium,
        overlayColor: const WidgetStatePropertyAll(AppColors.contentGray),
        splashBorderRadius: BorderRadius.circular(10),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
        indicatorColor: AppColors.contentBlack,
        dividerColor: const Color(0xFFE6E7E8),
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return ElevatedButton.icon(
      label: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          children: [
            const Icon(Icons.close),
            const SizedBox(width: 5),
            Text(
              '상품 비교',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.contentWhite,
                  fontSize: 15,
                  letterSpacing: -0.7
              ),
            ),
            // SizedBox(
            //   height: 20,
            //   child: FittedBox(
            //     fit: BoxFit.fitHeight,
            //     child: CircleAvatar(
            //       backgroundColor: AppColors.contentWhite,
            //       child: Text(
            //         '$_count',
            //         style: Theme.of(context).textTheme.labelMedium?.copyWith(
            //           color: Color(0xFF434648),
            //           fontSize: 30,
            //           fontWeight: FontWeight.w700,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      onPressed: () {
        checkComparing(!nowComparing, -1);
        Provider.of<ELSProductProvider>(context, listen: false).compareId.clear();
        Provider.of<ELSProductProvider>(context, listen: false).compareProducts.clear();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF434648),
      ),
    );
  }

}
