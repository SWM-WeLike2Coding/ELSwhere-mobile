import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/services/auth_service.dart';
import 'package:elswhere/ui/screens/auth_screen.dart';
import 'package:elswhere/ui/screens/initial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.iconELSwhere),
                      const SizedBox(height: 4,),
                      Text(
                        'ELSwhere',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        )
                      ),
                      const SizedBox(height: 4,),
                      Text(
                        'ELSwhere in Everywhere',
                        style: textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF838A8E),
                        )
                      ),
                    ],
                  )
                ),
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
                    SizedBox(
                      width: width - 32,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: edgeInsetsAll12,
                          shape: const RoundedRectangleBorder(borderRadius: borderRadiusCircular10),
                          backgroundColor: AppColors.contentWhite,
                          side: const BorderSide(color: AppColors.iconGray),
                        ),
                        icon: SvgPicture.asset(
                          Assets.iconGoogle,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () async {
                          final bool result = await login();

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
      refreshToken = response.refreshToken;
      storage.write(key: 'ACCESS_TOKEN', value: accessToken);
      storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
      return true;
    }
    return false;
  }
}
