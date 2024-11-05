import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/waiting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingScreen extends StatelessWidget {
  final String initialComment;
  final double initialValue;
  const WaitingScreen({super.key, required this.initialComment, this.initialValue = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: edgeInsetsAll16,
        child: Center(
          child: Consumer<WaitingProvider>(
            builder: (context, provider, child) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                        provider.comment ?? initialComment,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppColors.contentBlack,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: LinearProgressIndicator(
                    color: AppColors.mainBlue,
                    backgroundColor: AppColors.gray200,
                    value: provider.loadingValue ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
