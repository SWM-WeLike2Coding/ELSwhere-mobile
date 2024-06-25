import 'package:elswhere/models/dtos/summarized_product_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../resources/app_resource.dart';

class ELSDetailDialog extends Dialog {
  ELSDetailDialog({super.key, required this.elsProduct});

  final SummarizedProductDto elsProduct;
  final DateFormat dateFormat = DateFormat('yyyy년 MM월 dd일');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(elsProduct.name),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('고유 ID: ${elsProduct.id}'),
            Text('기초자산명: ${elsProduct.equities}'),
            Text('연 이율(쿠폰금리): ${elsProduct.yieldIfConditionsMet}%'),
            Text('청약시작일: ${dateFormat.format(elsProduct.subscriptionStartDate.toLocal())}'),
            Text('청약마감일: ${dateFormat.format(elsProduct.subscriptionEndDate.toLocal())}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('닫기'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      surfaceTintColor: AppColors.contentPurple,
      shadowColor: Colors.black,
    );
  }
}
