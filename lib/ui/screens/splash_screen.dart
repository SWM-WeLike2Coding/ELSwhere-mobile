import 'dart:developer';

import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/initial_screen.dart';
import 'package:elswhere/ui/screens/login_screen.dart';
import 'package:elswhere/ui/screens/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  late UserInfoProvider userProvider;

  SplashScreen({super.key});

  Future<void> checkUser(BuildContext context, String accessToken) async {
    if (accessToken == '') return;
    await userProvider.checkUser();
  }

  @override
  Widget build(BuildContext context) {
    log("Splash Screen");
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return FutureBuilder(
      future: checkUser(context, accessToken),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const WaitingScreen(comment: '사용자 정보를 불러오는 중입니다...');
        }
        FlutterNativeSplash.remove();
        if (accessToken != '' && userProvider.userInfo == null) {
          Fluttertoast.showToast(msg: '사용자 정보를 불러오는데 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
        } 
        if (userProvider.checkAuthenticated) {
          return const InitialScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
