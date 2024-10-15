import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/views/home/alarm_setting_modal.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AttentionSettingScreen extends StatefulWidget {
  const AttentionSettingScreen({super.key});

  @override
  State<AttentionSettingScreen> createState() => _AttentionSettingScreenState();
}

class _AttentionSettingScreenState extends State<AttentionSettingScreen> {

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '관심 상품 설정 화면',
      screenClass: 'AttentionSettingScreen',
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
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 72,
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "관심 상품 알림 설정",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.gray950,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.gray50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      size: 27,
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(msg: '추후 업데이트를 통해 제공할 예정입니다.', toastLength: Toast.LENGTH_SHORT);
                      // showModalBottomSheet(
                      //     context: context,
                      //     isScrollControlled: true,
                      //     useSafeArea: true,
                      //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      //     builder: (context) => SizedBox(
                      //           height: MediaQuery.of(context).size.height,
                      //           child: const AlarmSettingModal(),
                      //         ));
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('추후 업데이트를 통해 제공할 예정입니다.'),
            ),
          ),
        ],
      ),
    ));
  }
}
