import 'package:flutter/material.dart';

sealed class Assets {
  static const String fontFamilyNanum = "NanumBarunGothic";
  static const String nanum = "assets/fonts/NanumBarunGothic.ttf";
  static const String nanumBold = "assets/fonts/NanumBarunGothicBold.ttf";
  static const String nanumLight = "assets/fonts/NanumBarunGothicLight.ttf";
  static const String nanumUltraLight = "assets/fonts/NanumBarunGothicUltraLight.ttf";
}

sealed class AppColors {
  static const Color contentPurple = Color(0xFF5D63FF);
  static const Color contentGray = Color(0xFFBABABA);
  static const Color contentBlack = Color(0xFF000000);
  static const Color contentWhite = Color(0xFFFFFFFF);
  static const Color textFieldWhite = Color(0xFFF3F3F3);
}

const textTheme = TextTheme(
  bodyLarge: TextStyle(fontFamily: Assets.fontFamilyNanum),
  bodyMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displayLarge: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displayMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displaySmall: TextStyle(fontFamily: Assets.fontFamilyNanum),
  headlineMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  headlineSmall: TextStyle(fontFamily: Assets.fontFamilyNanum),
  titleLarge: TextStyle(fontFamily: Assets.fontFamilyNanum),
);

const edgeInsetsAll4 = EdgeInsets.all(4);
const edgeInsetsAll8 = EdgeInsets.all(8);
const edgeInsetsAll12 = EdgeInsets.all(12);
const edgeInsetsAll16 = EdgeInsets.all(16);

const borderRadiusCircular10 = BorderRadius.all(Radius.circular(10));