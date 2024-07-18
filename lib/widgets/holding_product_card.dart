import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/widgets/rounded_text_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HoldingProductCard extends StatelessWidget {

  const HoldingProductCard({Key? key,}) : super(key: key);

  String formatCurrency(int value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    int dummyLeftDays = 153;
    String dummyProductName = "키움증권 ELS 3041회";
    int dummyAsset = 1000000;
    double dummyInterest = 5.4;

    return Card(
      elevation: 3,
      child: InkWell(
        child: Container(
          padding: edgeInsetsAll12,
          decoration: BoxDecoration(
            color: Color(0xFF99CCFF),
            borderRadius: borderRadiusCircular10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                      Icons.ac_unit
                  ),
                  SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${dummyProductName}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      Text(
                        "${formatCurrency(dummyAsset)}원",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "평가손익",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9A9A9A),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 1.0,
                            height: 12,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "+${formatCurrency((dummyAsset * dummyInterest / 100).toInt())}원(+${dummyInterest}%)",
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
                ],
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "다음상환 평가일",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    TextSpan(
                      text: "D-${dummyLeftDays}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
