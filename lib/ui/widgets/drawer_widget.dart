import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              // image: const DecorationImage(
              //     image: AssetImage(Assets.appIconPath)),
              color: AppColors.mainBlue,
              gradient: LinearGradient(colors: [
                AppColors.mainBlue.withOpacity(0.9),
                AppColors.mainBlue.withOpacity(0.5)
              ],
                  begin: Alignment.centerLeft),
            ),
            child: null,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => SettingsPage()), // 설정 화면으로 이동합니다.
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('개발자 정보'),
            onTap: () {
              // Navigator.pop(context);
              // _showDeveloperInfoDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
