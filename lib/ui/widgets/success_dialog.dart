import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key});

  @override
  _SuccessDialogState createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> with SingleTickerProviderStateMixin {
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
              width: 100,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Lottie.asset(
                  'assets/animations/check_success.json', // Lottie 애니메이션 경로
                  controller: _lottieController,
                  frameRate: const FrameRate(120),
                  repeat: false,
                  onLoaded: (composition) {
                    // 애니메이션의 길이에 맞춰 AnimationController를 설정
                    _lottieController
                      ..duration = composition.duration ~/ 2
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
              '저장이 완료되었습니다!',
              style: textTheme.displayLarge!.copyWith(color: Colors.black, decoration: TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return const SuccessDialog();
    },
  );
}
