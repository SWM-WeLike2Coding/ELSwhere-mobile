import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/views/alarm_setting_modal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AttentionSettingScreen extends StatefulWidget {
  const AttentionSettingScreen({super.key});

  @override
  State<AttentionSettingScreen> createState() => _AttentionSettingScreenState();
}

class _AttentionSettingScreenState extends State<AttentionSettingScreen> {
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
                    color: Color(0xFF131415),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundGray,
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
