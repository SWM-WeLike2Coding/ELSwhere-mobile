import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/other/initial_screen.dart';
import 'package:elswhere/ui/screens/other/login_screen.dart';
import 'package:elswhere/ui/screens/other/terms_and_conditions_consent_screen.dart';
import 'package:elswhere/ui/screens/other/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserInfoProvider userProvider;

  @override
  void initState() {
    super.initState();
    // _checkAppVersion();
  }

  Future<void> _checkUser(BuildContext context, String accessToken) async {
    if (accessToken == '') return;
    await userProvider.checkUser();
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('업데이트 필요'),
        content: const Text('최신 버전으로 업데이트 해주세요.'),
        actions: [
          TextButton(
            onPressed: () async {
              SystemNavigator.pop();
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
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              }
            },
            child: Text(
              '확인',
              style: textTheme.R_16.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  bool _checkAppVersion() {
    List<int> remote = remoteLatestVersion.split(".").map((e) => int.parse(e)).toList();
    List<int> local = localLatestVersion.split(".").map((e) => int.parse(e)).toList();

    for (int i = 0; i < 3; i++) {
      if (remote[i] > local[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    log("Splash Screen");
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    FlutterNativeSplash.remove();

    // return const TermsAndConditionsConsentScreen();
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      body: FutureBuilder(
        future: Future.wait([_checkUser(context, accessToken)]),
        builder: (context, snapshot) {
          if (!_checkAppVersion()) {
            // 앱 버전이 일치하지 않으면 다이얼로그 띄우기
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showUpdateDialog(); // 다이얼로그 표시
            });
            return const SizedBox.shrink();
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const WaitingScreen(comment: '사용자 정보를 불러오는 중입니다...');
            }
            if (accessToken != '' && userProvider.userInfo == null) {
              Fluttertoast.showToast(msg: '사용자 정보를 불러오는데 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
            }
            if (userProvider.checkAuthenticated) {
              return const InitialScreen();
            } else {
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }
}
