import 'dart:developer';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/screens/home/ai_recommendation_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AiRecommendationProductCard extends StatefulWidget {
  const AiRecommendationProductCard({super.key});

  @override
  State<AiRecommendationProductCard> createState() => _AiRecommendationProductCardState();
}

class _AiRecommendationProductCardState extends State<AiRecommendationProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AIRecommendationProductScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: borderRadiusCircular10,
            color: AppColors.mainBlue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Lottie.asset(
                  'assets/animations/animation_ai.json',
                  height: 35,
                  width: 35,
                  controller: _lottieController,
                  frameRate: const FrameRate(120),
                  repeat: true,
                  onLoaded: (composition) {
                    _lottieController
                      ..duration = composition.duration
                      ..repeat();
                  },
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '스마트한 상품 선택을 위한',
                    style: textTheme.M_14.copyWith(color: AppColors.gray50),
                  ),
                  Text(
                    'AI가 추천하는 상품 보기',
                    style: textTheme.SM_16.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
