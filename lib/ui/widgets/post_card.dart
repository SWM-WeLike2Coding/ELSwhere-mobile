import 'package:elswhere/data/models/dtos/post_dto.dart';
import 'package:elswhere/ui/screens/investment_guide_detail_screen.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final PostDto post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          padding: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              post.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 18.88 / 16,
                letterSpacing: -0.02,
                color: Color(0xFF3B3D3F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
