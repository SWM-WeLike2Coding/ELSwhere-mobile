import 'dart:ui';

import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/views/detail_search_modal.dart';
import 'package:flutter/material.dart';

import '../views/alarm_setting_modal.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key});

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
      if (_focusNode.hasFocus) {
        _showModal();
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
      builder: (context) => const DetailSearchModal(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 50,
      child: TextField(
        focusNode: _focusNode,
        decoration: InputDecoration(
          focusColor: Colors.amber,
          prefixIcon: Icon(Icons.search),
          hintText: '키워드 입력',
          hintStyle: TextStyle(color: AppColors.contentGray),
          border: OutlineInputBorder(
            borderRadius: borderRadiusCircular10,
            borderSide: BorderSide.none,
          ),
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

