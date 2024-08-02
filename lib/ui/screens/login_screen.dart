import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/services/auth_service.dart';
import 'package:elswhere/ui/screens/initial_screen.dart';
import 'package:elswhere/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.ac_unit_rounded),
                      const SizedBox(width: 15),
                      Text(
                        'ELSwhere',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: width - 32,
                      child: OutlinedButton.icon(
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(edgeInsetsAll12),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: borderRadiusCircular10)),
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.contentWhite),
                        ),
                        icon: SvgPicture.asset(
                          googleIconPath,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () async {
                          final result = await login();

                          if (result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => InitialScreen()), (route) => false,
                              // MaterialPageRoute(builder: (context) => AuthScreen(authUrl: authUrl)),
                            );
                          } else {
                            Fluttertoast.showToast(msg: '로그인에 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
                          }
                        },
                        label: Text(
                          '구글로 계속하기',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.contentBlack,
                            fontSize: 16,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
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

  Future<bool> login() async {
    final authUrl = baseUrl + loginEndpoint;
    final response = await AuthService.authenticateUser(authUrl);
    if (response != null) {
      accessToken = response.accessToken;
      storage.write(key: 'ACCESS_TOKEN', value: accessToken);
      storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
      print(accessToken);
      print(refreshToken);
      return true;
    }
    return false;
  }
}
