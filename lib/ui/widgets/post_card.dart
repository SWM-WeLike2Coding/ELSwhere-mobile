import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/post/post_dto.dart';
import 'package:elswhere/ui/screens/more/investment_guide_detail_screen.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final PostDto post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvestmentGuideDetailScreen(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 18.88 / 16,
                letterSpacing: -0.02,
                color: AppColors.gray900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
