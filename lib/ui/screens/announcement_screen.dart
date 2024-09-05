import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopContent(),
          _buildAnnouncementList(),
        ],
      ),
    );
  }

  PreferredSize _buildAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Color(0xFFF5F6F6),
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
            "공지사항",
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

  Widget _buildTopContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
      child: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF06B23),
            ),
            width: 18,
            height: 18,
            child: const Center(
              child: Text(
                "N",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                  height: 16.52 / 14,
                  letterSpacing: -0.02,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const Text(
            "새로운 소식",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 18.88 / 16,
              letterSpacing: -0.02,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAnnouncementList() {
    return const Expanded(child: Center(child: Text('공지사항이 없습니다.')));
  }
}
