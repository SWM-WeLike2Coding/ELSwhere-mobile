import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

bool isTextOverflowing(String text, double maxWidth, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.didExceedMaxLines;
}

Widget getMarqueeIfOverflow({required double maxWidth, required double height, required String text, required TextStyle style}) {
  return isTextOverflowing(text, maxWidth, style)
      ? SizedBox(
          height: height,
          width: maxWidth,
          child: Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            startAfter: const Duration(seconds: 1),
            velocity: 30.0,
            blankSpace: 100,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            fadingEdgeEndFraction: 0.7,
            decelerationCurve: Curves.linear,
          ),
        )
      : Text(
          text,
          style: style,
        );
}
