import 'package:flutter/material.dart';

import '../../config/app_resource.dart';
import '../../data/models/dtos/els_product_for_schedule_dto.dart';

class RedemptionScheduleScreen extends StatefulWidget {
  const RedemptionScheduleScreen({super.key});

  @override
  State<RedemptionScheduleScreen> createState() => _RedemptionScheduleScreenState();
}

class _RedemptionScheduleScreenState extends State<RedemptionScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: AppColors.backgroundGray,
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
              "가입 상품 중 상환 일정",
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
        child: Text("일정이 없어요"),
      ),
    );
  }
}
