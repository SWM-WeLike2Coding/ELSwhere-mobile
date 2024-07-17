import 'dart:ui';

import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/widgets/rounded_text_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class TotalOutcomeCard extends StatelessWidget {
  final bool isHoldingNow;
  final int numProducts;
  final int sumOfProperty;
  final double interestRate;

  const TotalOutcomeCard({
    Key? key,
    required this.isHoldingNow,
    required this.numProducts,
    required this.sumOfProperty,
    required this.interestRate,
  }) : super(key: key);

  String formatCurrency(int value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 3,
      child: InkWell(
        child: Container(
          padding: edgeInsetsAll12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFA4C1FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadiusCircular10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isHoldingNow ? "보유상품" : "상환완료 상품",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10,),
                      RoundedTextContainer(
                        numProducts: 4,
                        color: Color(0xFFA4C1FF),
                      ),
                    ],
                  ),
                  Text(
                    "${formatCurrency(sumOfProperty as int)}원",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444444),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "평가손익",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB5B5B5),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 1.0,
                        height: 14,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "+${formatCurrency((sumOfProperty * interestRate / 100).toInt())}원(+${interestRate}%)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D63FF),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  ">",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF3F3F3),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
