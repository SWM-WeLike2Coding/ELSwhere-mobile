import 'dart:ui';

import 'package:elswhere/resources/app_resource.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: const TextField(
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
  }
}
