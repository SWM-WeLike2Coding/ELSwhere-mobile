import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/widgets/rounded_text_container.dart';
import 'package:flutter/material.dart';

class TotalAttentionCard extends StatelessWidget {
  final int numProducts;


  const TotalAttentionCard({
    Key? key,
    required this.numProducts,
  }) : super(key: key);

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
                Color(0xFF99CCFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadiusCircular10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "내가 관심 등록한 상품",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444444),
                    ),
                  ),
                  SizedBox(width: 10,),
                  RoundedTextContainer(
                    numProducts: 4,
                    color: Color(0xFF99CCFF),
                  ),
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
