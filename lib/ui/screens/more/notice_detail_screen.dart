import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/post_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NoticeDetailScreen extends StatefulWidget {
  const NoticeDetailScreen({super.key});

  @override
  State<NoticeDetailScreen> createState() => NoticeDetailScreenState();
}

class NoticeDetailScreenState extends State<NoticeDetailScreen> {
  final DateFormat dateFormat = DateFormat().addPattern('yyyy년 MM월 dd일');
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '공지사항 상세 보기',
      screenClass: 'NoticeDetailScreen',
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
      body: Consumer<PostProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider.singleNotice!.title, style: textTheme.SM_18),
                  const SizedBox(height: 8),
                  Text(
                    dateFormat.format(DateTime.parse(provider.singleNotice!.createdAt)),
                    style: textTheme.M_14.copyWith(color: AppColors.gray400),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    children: [
                      Text(
                        provider.singleNotice!.body,
                        style: textTheme.R_16.copyWith(color: AppColors.gray800),
                        maxLines: null,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
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
      ),
    );
  }
}
