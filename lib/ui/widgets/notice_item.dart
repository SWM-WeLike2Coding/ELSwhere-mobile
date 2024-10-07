import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/post-service/summarized_generic_post_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeItem extends StatelessWidget {
  final SummarizedGenericPostDto notice;
  final DateFormat dateFormat = DateFormat().addPattern('yyyy년 MM월 dd일');

  NoticeItem({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: edgeInsetsAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice.title,
              style: textTheme.M_18.copyWith(color: AppColors.gray900),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(DateTime.parse(notice.createdAt)),
              style: textTheme.M_14.copyWith(color: AppColors.gray400),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
