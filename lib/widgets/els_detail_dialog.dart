import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dtos/response_single_product_dto.dart';

class ELSDetailDialog {
  static void show(BuildContext context, ResponseSingleProductDto product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final DateFormat dateFormat = DateFormat('yyyy년 MM월 dd일');

        return AlertDialog(
          title: Text(product.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('상품 ID: ${product.id}'),
                Text('기초자산명: ${product.equities}'),
                Text('발행일: ${dateFormat.format(product.issuedDate)}'),
                Text('만기일: ${dateFormat.format(product.maturityDate)}'),
                Text('조건충족시 이율: ${product.yieldIfConditionsMet}%'),
                Text('최대손실률: ${product.maximumLossRate}%'),
                Text('청약시작일: ${dateFormat.format(product.subscriptionStartDate)}'),
                Text('청약마감일: ${dateFormat.format(product.subscriptionEndDate)}'),
                Text('상품 종류: ${product.type}'),
                Text('상품 링크: ${product.link}'),
                Text('비고: ${product.remarks}'),
                Text('간이투자설명서: ${product.summaryInvestmentProspectusLink ?? ''}'),
                Text('자동조기상환평가일: ${product.earlyRepaymentEvaluationDates ?? ''}'),
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
        );
      },
    );
  }
}
