import 'package:elswhere/config/app_resource.dart';
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
        body: SafeArea(
          child: Column(
              children: [
                Container(
                  height: 72,
                  child: Row(
                    children: [
                      SizedBox(width: 24,),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 8,),
                      Text(
                        "관심 상품 알림 설정",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF131415),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGray,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 27,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              builder: (context) => Container(
                                height: MediaQuery.of(context).size.height,
                                child: const AlarmSettingModal(),
                              )
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ),
                      SizedBox(width: 24,),
                    ],
                  ),
                )
              ],
            ),
        )
    );
  }
}
