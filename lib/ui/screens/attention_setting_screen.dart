import 'package:elswhere/ui/views/alarm_setting_modal.dart';
import 'package:flutter/material.dart';

class AttentionSettingScreen extends StatefulWidget {
  const AttentionSettingScreen({super.key});

  @override
  State<AttentionSettingScreen> createState() => _AttentionSettingScreenState();
}

class _AttentionSettingScreenState extends State<AttentionSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("관심상품 알림설정"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const AlarmSettingModal(),
                );
              },
            ),
          ],
        ),
        body:
          SizedBox(height: 10,),
    );
  }
}
