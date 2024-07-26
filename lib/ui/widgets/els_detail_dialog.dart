import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/response_single_product_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'explain_card.dart';

class ELSDetailDialog {
  static void show(BuildContext context, ResponseSingleProductDto product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final DateFormat dateFormat = DateFormat('yyyy년 MM월 dd일');

        return AlertDialog(
          title: Text(product.name),
          content: const SingleChildScrollView(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ExplainCard(
                        borderRadius: 10,
                        boxColors: [AppColors.contentPurple, Colors.white],
                      ),
                      SizedBox(width: 10),
                      ExplainCard(borderRadius: 10,
                        boxColors: [AppColors.contentPurple, Colors.white],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ExplainCard(
                        borderRadius: 10,
                        boxColors: [AppColors.contentPurple, Colors.white],
                      ),
                      SizedBox(width: 10),
                      ExplainCard(borderRadius: 10,
                        boxColors: [AppColors.contentPurple, Colors.white],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ExplainCard(
                        borderRadius: 10,
                        boxColors: [AppColors.contentPurple, Colors.white],
                      ),
                      SizedBox(width: 10),
                      ExplainCard(borderRadius: 10,
                        boxColors: [AppColors.contentPurple, Colors.white],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
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
