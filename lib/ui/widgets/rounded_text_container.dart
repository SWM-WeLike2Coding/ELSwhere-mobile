import 'package:flutter/material.dart';


class RoundedTextContainer extends StatelessWidget {
  final int numProducts;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;

  RoundedTextContainer({
    required this.numProducts,
    required this.color,
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        numProducts.toString(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}