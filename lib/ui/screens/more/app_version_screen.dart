import 'dart:developer';
import 'dart:io';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/ui/widgets/custom_appbar.dart';
import 'package:elswhere/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionScreen extends StatelessWidget {
  const AppVersionScreen({super.key});

  void _onTap() async {
    final storeUri = Platform.isAndroid ? Uri.https('play.google.com', '/store/apps/details', {"id": packageName}) : Uri.https('apps.apple.com', '/app/id$appleAppId');
    try {
      if (await canLaunchUrl(storeUri)) {
        log('$storeUri');
        launchUrl(storeUri);
      } else {
        throw Exception('Play Store/App Store 실행 실패');
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool needUpdate = !checkAppVersion(storeVersion);
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('앱 버전', style: textTheme.SM_18),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                children: [
                  ClipRRect(
                    child: Image.asset(Assets.logoELSwhereWhite, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray500),
                      borderRadius: borderRadiusCircular8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('현재 버전: $localLatestVersion', style: textTheme.M_16.copyWith(color: AppColors.gray800)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (needUpdate) ...[
                  CircleAvatar(
                    backgroundColor: AppColors.contentOrange,
                    radius: 9,
                    child: Text('N', style: textTheme.SM_12.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                ],
                Text('스토어 최신 버전: $storeVersion', style: textTheme.M_16.copyWith(color: AppColors.gray800)),
              ],
            ),
            const SizedBox(height: 8),
            if (needUpdate)
              ElevatedButton(
                onPressed: _onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gray50,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: borderRadiusCircular8),
                ),
                child: Text('업데이트 하러 가기', style: textTheme.M_14.copyWith(color: Colors.black)),
              ),
            if (!needUpdate)
              Text(
                '현재 앱이 최신 버전입니다.',
                style: textTheme.M_16.copyWith(color: AppColors.mainBlue),
              )
          ],
        ),
      ),
    );
  }
}
