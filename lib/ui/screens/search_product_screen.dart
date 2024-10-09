import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/detail_search_modal.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory(String searchQuery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? existingHistory = prefs.getStringList("searchHistory");

    existingHistory ??= [];

    if (!existingHistory.contains(searchQuery)) {
      existingHistory.add(searchQuery);
      await prefs.setStringList('searchHistory', existingHistory);
      _searchHistory = existingHistory;
    } else {
      existingHistory.remove(searchQuery);
      existingHistory.add(searchQuery);
      await prefs.setStringList('searchHistory', existingHistory);
      _searchHistory = existingHistory;
    }
  }

  Future<void> _saveSearchHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', _searchHistory);
    setState(() {}); // UI 업데이트
  }

  void _onSearch(String query) async {
    if (query.isNotEmpty) {
      _saveSearchHistory(query); // 검색 기록 저장
      _searchController.clear(); // 검색창 비우기

      await Provider.of<ELSOnSaleProductsProvider>(context, listen: false).fetchProductByNumber(int.parse(query));
      await Provider.of<ELSEndSaleProductsProvider>(context, listen: false).fetchProductByNumber(int.parse(query));

      Navigator.pop(context);
      setState(() {}); // UI 업데이트
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchInput(),
            _buildLatestSearchText(),
            Expanded(child: _buildLatestSearchHistoryList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: AppColors.gray50,
            width: 1,
          ))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // SizedBox(width: 16,),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '회차 번호로 검색해보세요',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // 숫자만 허용
                        ],
                        onSubmitted: _onSearch,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        size: 24,
                        color: AppColors.gray400,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) => DetailSearchModal(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLatestSearchText() {
    return const Padding(
      padding: EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Text(
        "최근 검색",
        style: TextStyle(color: AppColors.gray600, fontSize: 14, fontWeight: FontWeight.w600, height: 1.18, letterSpacing: -0.28),
      ),
    );
  }

  Widget _buildLatestSearchHistoryList() {
    return ListView.builder(
      itemCount: _searchHistory.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 4,
            left: 24,
            right: 24,
          ),
          child: _buildOneHistoryCard(_searchHistory[_searchHistory.length - 1 - index]),
        );
      },
    );
  }

  Widget _buildOneHistoryCard(String historyString) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(600),
              border: Border.all(
                color: AppColors.gray50,
                width: 1,
              )),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.access_time,
              color: AppColors.gray300,
              size: 18,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        GestureDetector(
          onTap: () {
            print(historyString);
            _onSearch(historyString);
          },
          child: Text(
            historyString,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.18,
              letterSpacing: -0.28,
            ),
          ),
        ),
        Expanded(child: Container()),
        IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.gray400,
            size: 24,
          ),
          onPressed: () {
            _searchHistory.remove(historyString);
            _saveSearchHistoryList();
          },
        ),
      ],
    );
  }
}
