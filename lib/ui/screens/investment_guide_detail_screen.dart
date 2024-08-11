import 'package:elswhere/data/models/dtos/post_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/app_resource.dart';

class InvestmentGuideDetailScreen extends StatelessWidget {
  final PostDto post;
  const InvestmentGuideDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(post.title, post.createdAt),
                if (post.imagePath != null)
                  _buildImage(post.imagePath),
                _buildContent(post.content),
                SizedBox(height: 24,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(72),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: AppColors.backgroundGray,
                  width: 1,
                )
            )
        ),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
            child: Align(
              alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: Text(
            "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
        ),
      ),
    );
  }

  Widget _buildTitle(String title, DateTime? createdAt) {
    String formattedDateTime = DateFormat('yyyy년 MM월 dd일').format(createdAt!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24,),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.18,
            letterSpacing: -0.36,
            color: Color(0xFF000000),
          ),
        ),
        SizedBox(height: 8,),
        Text(
          formattedDateTime,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.18,
            letterSpacing: -0.28,
            color: Color(0xFF838A8E),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String? imagePath) {
    return Column(
      children: [
        SizedBox(height: 40,),
        Container(
          width: double.infinity,
          child: Image.asset(
            imagePath!,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(String content) {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Container(
        width: double.infinity,
        child: Text(
          content,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.40,
            letterSpacing: -0.32,
            color: Color(0xFF434648),
          ),
        ),
      ),
    );
  }
}
