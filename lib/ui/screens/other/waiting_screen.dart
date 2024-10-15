import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  final String comment;

  const WaitingScreen({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.mainBlue,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              comment,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.contentBlack,
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
