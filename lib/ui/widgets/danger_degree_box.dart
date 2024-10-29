import 'package:flutter/material.dart';

class DangerDegreeBox extends StatelessWidget {
  final Map<String, dynamic> aiResult;
  final TextStyle textStyle;

  const DangerDegreeBox({super.key, required this.aiResult, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
          side: BorderSide(
            width: 1.5,
            color: aiResult['color'],
          ),
        ),
      ),
      child: Text(
        aiResult!['label'],
        style: textStyle.copyWith(color: aiResult['color']),
      ),
    );
  }
}
