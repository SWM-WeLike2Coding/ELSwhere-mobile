import 'dart:developer';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/social_type.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/data/services/auth/auth_service.dart';
import 'package:elswhere/ui/screens/other/initial_screen.dart';
import 'package:elswhere/ui/screens/other/terms_and_conditions_consent_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '로그인 화면',
      screenClass: 'LoginScreen',
    );
  }

  Future<String> _login(SocialType socialType) async {
    final authUrl = '$baseUrl$loginEndpoint/${switch (socialType) {
      SocialType.GOOGLE => 'google',
      SocialType.APPLE => 'apple',
      SocialType.KAKAO => 'kakao',
    }}/login';
    final response = await AuthService.authenticateUser(authUrl);

    if (response != null) {
      if (response.accessToken.isEmpty) {
        final signupToken = response.refreshToken; // 액세스 토큰이 없으면, 리프레시 토큰이 signup token
        log(signupToken);
        Provider.of<UserInfoProvider>(context, listen: false).signupToken = signupToken;
        return 'terms';
      } else {
        accessToken = response.accessToken;
        refreshToken = response.refreshToken;
        storage.write(key: 'ACCESS_TOKEN', value: accessToken);
        storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
        return 'success';
      }
    }
    return 'failed';
  }

  void _onTapLoginButton(BuildContext context, SocialType socialType) async {
    final String result = await _login(socialType);

    switch (result) {
      case 'success':
        {
          log(accessToken);
          log(refreshToken);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const InitialScreen()),
            (route) => false,
          );
        }
      case 'failed':
        Fluttertoast.showToast(msg: '로그인에 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
      case 'terms':
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TermsAndConditionsConsentScreen()),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentScreen();
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;

          return Padding(
            padding: edgeInsetsAll16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 96, right: 96),
                      child: SvgPicture.asset(Assets.logoELSwhere),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text('ELSwhere in Everywhere',
                        style: textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          color: AppColors.gray400,
                        )),
                  ],
                )),
                // Expanded(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       const Icon(Icons.ac_unit_rounded),
                //       const SizedBox(width: 15),
                //       Text(
                //         'ELSwhere',
                //         style: Theme.of(context)
                //             .textTheme
                //             .titleLarge
                //             ?.copyWith(fontSize: 30),
                //       ),
                //     ],
                //   ),
                // ),
                Column(
                  children: [
                    _buildGoogleLoginButton(context),
                    const SizedBox(height: 12),
                    _buildAppleLoginButton(context),
                    const SizedBox(height: 30),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: edgeInsetsAll12,
                shape: const RoundedRectangleBorder(borderRadius: borderRadiusCircular10),
                backgroundColor: AppColors.contentWhite,
                side: const BorderSide(color: AppColors.gray200),
              ),
              icon: SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  Assets.iconGoogle,
                ),
              ),
              onPressed: () => _onTapLoginButton(context, SocialType.GOOGLE),
              label: Text(
                '구글로 계속하기',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.contentBlack,
                      fontSize: 16,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppleLoginButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: edgeInsetsAll12,
                shape: const RoundedRectangleBorder(borderRadius: borderRadiusCircular10),
                backgroundColor: AppColors.contentBlack,
              ),
              icon: SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  Assets.iconApple,
                ),
              ),
              onPressed: () => _onTapLoginButton(context, SocialType.APPLE),
              label: Text(
                '애플로 계속하기',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.contentWhite,
                      fontSize: 16,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
