import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../../config/app_resource.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '알림 화면',
      screenClass: 'NotificationScreen',
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
      appBar: PreferredSize(
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
              "알림",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          "알림이 없어요",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.18,
            letterSpacing: -0.32,
            color: AppColors.gray500,
          ),
        ),
      ),
    );
  }
}
