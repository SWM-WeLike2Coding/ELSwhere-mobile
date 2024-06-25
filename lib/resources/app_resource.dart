import 'package:flutter/material.dart';

sealed class Assets {
  static String fontFamilyNanum = "NanumBarunGothic";
  static String nanum = "assets/fonts/NanumBarunGothic.ttf";
  static String nanumBold = "assets/fonts/NanumBarunGothicBold.ttf";
  static String nanumLight = "assets/fonts/NanumBarunGothicLight.ttf";
  static String nanumUltraLight = "assets/fonts/NanumBarunGothicUltraLight.ttf";
}

sealed class AppColors {
  static Color contentPurple = const Color(0xFF5D63FF);
  static Color contentGray = const Color(0xFFBABABA);
  static Color contentBlack = const Color(0xFF000000);
  static Color contentWhite = const Color(0xFFFFFFFF);
}

final textTheme = TextTheme(
  bodyLarge: TextStyle(fontFamily: Assets.fontFamilyNanum, fontWeight: FontWeight.bold),
  bodyMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displayLarge: TextStyle(fontFamily: Assets.fontFamilyNanum, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displaySmall: TextStyle(fontFamily: Assets.fontFamilyNanum),
  headlineMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  headlineSmall: TextStyle(fontFamily: Assets.fontFamilyNanum),
  titleLarge: TextStyle(fontFamily: Assets.fontFamilyNanum, fontWeight: FontWeight.bold),
);
