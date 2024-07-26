import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExplainCard extends StatelessWidget {
  const ExplainCard({
    super.key,
    required this.boxColors,
    required this.borderRadius,
  });

  final List<Color> boxColors;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double cardSize = width / 2 - 40;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        gradient: LinearGradient(
          colors: boxColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SizedBox(
        height: cardSize,
        width: cardSize,
        child: const Card(
          child: Text('hello'),
        ),
      ),
    );
  }
}
