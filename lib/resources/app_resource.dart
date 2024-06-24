import 'package:flutter/material.dart';

const String appName = "ELSwhere";

sealed class Assets {
  static String fontFamilyNanum = "NanumBarunGothic";
  static String nanum = "assets/fonts/NanumBarunGothic.ttf";
  static String nanumBold = "assets/fonts/NanumBarunGothicBold.ttf";
  static String nanumLight = "assets/fonts/NanumBarunGothicLight.ttf";
  static String nanumUltraLight = "assets/fonts/NanumBarunGothicUltraLight.ttf";
}

final textTheme = TextTheme(
  bodyLarge: TextStyle(fontFamily: Assets.fontFamilyNanum),
  bodyMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displayLarge: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displayMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  displaySmall: TextStyle(fontFamily: Assets.fontFamilyNanum),
  headlineMedium: TextStyle(fontFamily: Assets.fontFamilyNanum),
  headlineSmall: TextStyle(fontFamily: Assets.fontFamilyNanum),
  titleLarge: TextStyle(fontFamily: Assets.fontFamilyNanum),
);
