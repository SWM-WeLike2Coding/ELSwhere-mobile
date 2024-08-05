import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/initial_screen.dart';
import 'package:elswhere/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  late final UserInfoProvider userProvider;

  SplashScreen({super.key});

  Future<void> checkUser(BuildContext context, String accessToken) async {
    if (accessToken == '') return;
    await userProvider.checkUser();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return FutureBuilder(
      future: checkUser(context, accessToken),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          FlutterNativeSplash.remove();
          if (userProvider.checkAuthenticated) {
            return const InitialScreen();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }
}
