import 'package:elswhere/data/models/dtos/post_dto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/app_resource.dart';

class InvestmentGuideDetailScreen extends StatelessWidget {
  final PostDto post;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '투자가이드 상세 화면',
      screenClass: 'InvestmentGuideDetailScreen',
    );
  }

  InvestmentGuideDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    _setCurrentScreen();
    return Scaffold(
      appBar: _buildAppbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(post.title, post.createdAt),
                if (post.imagePath != null) _buildImage(post.imagePath),
                _buildContent(post.content),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppbar(BuildContext context) {
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
        const SizedBox(
          height: 24,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.18,
            letterSpacing: -0.36,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          formattedDateTime,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.18,
            letterSpacing: -0.28,
            color: AppColors.gray400,
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String? imagePath) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        SizedBox(
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
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          content,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.40,
            letterSpacing: -0.32,
            color: AppColors.gray800,
          ),
        ),
      ),
    );
  }
}
