import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elswhere/ui/views/home/personalized_products_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_resource.dart';
import '../../../config/config.dart';
import '../../../data/providers/user_info_provider.dart';
import 'investment_propensity_screen.dart';

class PersonalizedProductsScreen extends StatefulWidget {
  const PersonalizedProductsScreen({super.key});

  @override
  State<PersonalizedProductsScreen> createState() => _PersonalizedProductsScreenState();
}

class _PersonalizedProductsScreenState extends State<PersonalizedProductsScreen> {
  String type = 'latest';
  String selectedValue = '최신순';

  Future<void> typeChanged(BuildContext context, String? value) async {
    setState(() {
      selectedValue = value!;
      type = itemsMap[value]!;
      Provider.of<UserInfoProvider>(context, listen: false).sortPeronalizedProducts(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPersonalizedProductsStringAndFilter(),
          PersonalizedProductsListView(type: type,),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: AppColors.gray50,
                  width: 1,
                ))),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
            child: Align(
              alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: const Text(
            "나에게 딱 맞는 상품 추천",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 24),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F6),
                  borderRadius: BorderRadius.circular(600),
                ),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  iconSize: 24,
                  color: Color(0xFF595E62),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvestmentPropensityScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizedProductsStringAndFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
      child: Row(
        children: [
          Text(
            "내 투자 성향에 맞는 상품",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.18,
              letterSpacing: -0.32,
              color: AppColors.gray950,
            ),
          ),
          const Spacer(),
          Expanded(
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
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) async {
                  await typeChanged(context, value);
                },
                buttonStyleData: const ButtonStyleData(
                  height: 40,
                  width: 30,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}