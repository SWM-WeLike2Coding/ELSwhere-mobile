import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignupSuccessDialog extends StatefulWidget {
  const SignupSuccessDialog({super.key});

  @override
  _SignupSuccessDialogState createState() => _SignupSuccessDialogState();
}

class _SignupSuccessDialogState extends State<SignupSuccessDialog> with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 130,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Lottie.asset(
                  'assets/animations/signup_success.json', // Lottie 애니메이션 경로
                  controller: _lottieController,
                  frameRate: const FrameRate(120),
                  repeat: false,
                  onLoaded: (composition) {
                    // 애니메이션의 길이에 맞춰 AnimationController를 설정
                    _lottieController
                      ..duration = composition.duration
                      ..forward().whenComplete(() {
                        // 애니메이션이 끝난 후 자동으로 다이얼로그 닫기
                        Navigator.of(context).pop();
                      });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '회원가입을 완료했어요!',
              style: textTheme.displayLarge!.copyWith(color: Colors.black, decoration: TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showSignupSuccessDialog(BuildContext context) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return const SignupSuccessDialog();
    },
  );
}
