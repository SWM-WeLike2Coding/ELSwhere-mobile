import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/other/initial_screen.dart';
import 'package:elswhere/ui/screens/other/login_screen.dart';
import 'package:elswhere/ui/screens/other/waiting_screen.dart';
import 'package:elswhere/utils/utils.dart';
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

  Future<void> _getAnalysisResult() async {
    log('분석 결과 불러오기');

    // Base64 문자열 디코딩 함수
    String fixBase64Padding(String base64String) {
      // 길이가 4의 배수가 아닐 때 패딩 문자를 추가하여 문제 해결
      int paddingLength = (4 - base64String.length % 4) % 4;
      return base64String + ('=' * paddingLength);
    }

    // AI 파일 로드
    try {
      final base64ContentsAI = await rootBundle.loadString('assets/data/ai_result.txt');
      log('AI 파일 로드 성공');

      // Base64 디코딩 및 JSON 변환
      final decodedJsonStringAI = utf8.decode(base64Decode(fixBase64Padding(base64ContentsAI)));
      final List<Map<String, dynamic>> jsonMapAI = List<Map<String, dynamic>>.from(jsonDecode(decodedJsonStringAI));
      aiData = jsonMapAI;
    } catch (e) {
      log('AI 파일 로드 오류: $e');
    }

    // MCS 파일 로드
    try {
      final base64ContentsMCS = await rootBundle.loadString('assets/data/mcs_result.txt');
      log('MCS 파일 로드 성공');

      // Base64 디코딩 및 JSON 변환
      final decodedJsonStringMCS = utf8.decode(base64Decode(fixBase64Padding(base64ContentsMCS)));
      final List<Map<String, dynamic>> jsonMapMCS = List<Map<String, dynamic>>.from(jsonDecode(decodedJsonStringMCS));
      mcsData = jsonMapMCS;
    } catch (e) {
      log('MCS 파일 로드 오류: $e');
    }
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
        future: Future.wait([
          _checkUser(context, accessToken),
          _getAnalysisResult(),
        ]),
        builder: (context, snapshot) {
          if (!checkAppVersion(remoteLatestVersion)) {
            // 앱 버전이 일치하지 않으면 다이얼로그 띄우기
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showUpdateDialog(); // 다이얼로그 표시
            });
            return const SizedBox.shrink();
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const WaitingScreen(initialComment: MSG_LOADING_USER_INFO);
            }
            if (accessToken != '' && userProvider.userInfo == null) {
              Fluttertoast.showToast(msg: MSG_ERR_FETCH_USER_INFO, toastLength: Toast.LENGTH_SHORT);
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
