import 'dart:ui';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/screens/product/search_product_screen.dart';
import 'package:elswhere/ui/views/product/detail_search_modal.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  VoidCallback? callback;
  SearchTextField({super.key, this.callback});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Add listener to show modal when the TextField gains focus
    _focusNode.addListener(() {
      // 원래의 Modal 띄우는 코드
      // if (_focusNode.hasFocus) {
      //   _showModal();
      // }

      // 2024-10-04 아예 새로운 화면을 띄워서 상품 검색하도록 바꾸기
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchProductScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _showModal() {
    _focusNode.unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DetailSearchModal(callback: widget.callback),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        focusNode: _focusNode,
        decoration: InputDecoration(
          focusColor: Colors.amber,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black.withOpacity(0.4),
          ),
          hintText: '상품 검색',
          hintStyle: const TextStyle(color: AppColors.gray600, letterSpacing: -0.02),
          border: const OutlineInputBorder(
            borderRadius: borderRadiusCircular10,
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.gray50,
          filled: true,
          // fillColor: AppColors.contentPurple,
        ),
      ),
    );

    // return TextField(
    //   focusNode: _focusNode,
    //   decoration: InputDecoration(
    //     labelText: 'Search',
    //     border: OutlineInputBorder(),
    //   ),
    // );
  }
}
