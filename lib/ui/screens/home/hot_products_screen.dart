import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/ui/views/home/hot_products_list_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotProductsScreen extends StatefulWidget {
  const HotProductsScreen({super.key});

  @override
  State<HotProductsScreen> createState() => _HotProductsScreenState();
}

class _HotProductsScreenState extends State<HotProductsScreen> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '인기 상품 화면',
      screenClass: 'HotProductsScreen',
    );
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTitleText(),
          const HotProductsListView(),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        centerTitle: false,
        title: Text(
          'HOT 상품',
          style: textTheme.SM_18.copyWith(color: AppColors.gray950),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    DateFormat dateFormat = DateFormat().addPattern('yyyy년 MM월 dd일');

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '일일 HOT 상품',
            style: textTheme.SM_16.copyWith(color: AppColors.gray950),
          ),
          Row(
            children: [
              Text(
                '${dateFormat.format(DateTime.now())} 00:00 기준',
                style: textTheme.M_14.copyWith(color: AppColors.gray400),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _showDialog,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.gray100,
                  child: Text(
                    '?',
                    style: pretendard.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierLabel: 'Hello',
      builder: (context) {
        return Dialog(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: edgeInsetsAll24,
                child: Wrap(
                  children: [
                    Text(
                      MSG_DESCRIBE_HOT_PRODUCTS,
                      maxLines: null,
                      style: textTheme.SM_16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
