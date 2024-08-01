import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class Assets {
  static const String fontFamilyPretendard = "Pretendard";
  static const String pretendardThin = "assets/fonts/pretendard/Pretendard-Thin.ttf";
  static const String pretendardExtraLight = "assets/fonts/pretendard/Pretendard-ExtraLight.ttf";
  static const String pretendardLight = "assets/fonts/pretendard/Pretendard-Light.ttf";
  static const String pretendardRegular = "assets/fonts/pretendard/Pretendard-Regular.ttf";
  static const String pretendardMedium = "assets/fonts/pretendard/Pretendard-Medium.ttf";
  static const String pretendardSemiBold = "assets/fonts/pretendard/Pretendard-SemiBold.ttf";
  static const String pretendardBold = "assets/fonts/pretendard/Pretendard-Bold.ttf";
  static const String pretendardExtraBold = "assets/fonts/pretendard/Pretendard-ExtraBold.ttf";
  static const String pretendardBlack = "assets/fonts/pretendard/Pretendard-Black.ttf";

  static const String iconHana = "assets/icons/icon_hana.png";
}

sealed class AppColors {
  static const Color contentRed = Color(0xFFEE5648);
  static const Color contentGray = Color(0xFFBABABA);
  static const Color contentBlack = Color(0xFF000000);
  static const Color contentWhite = Color(0xFFFFFFFF);
  static const Color textFieldWhite = Color(0xFFF3F3F3);

  static const Color cornflowerBlues1 = Color(0xFF7499FF); // 첫 번째 색상
  static const Color cornflowerBlues2 = Color(0xFF7FA8FF); // 두 번째 색상
  static const Color cornflowerBlues3 = Color(0xFFA4C1FF); // 세 번째 색상
  static const Color cornflowerBlues4 = Color(0xFFC4D7FF); // 네 번째 색상
  static const Color cornflowerBlues5 = Color(0xFFE0EAFF); // 다섯 번째 색상

  static const Color blues1 = Color(0xFF3366FF); // 여섯 번째 색상
  static const Color blues2 = Color(0xFF5588FF); // 일곱 번째 색상
  static const Color blues3 = Color(0xFFBBEEFF); // 여덟 번째 색상
  static const Color blues4 = Color(0xFF99CCFF); // 아홉 번째 색상
  static const Color blues5 = Color(0xFF77AAFF); // 열 번째 색상

  static const Color mainBlue = Color(0xFF1C6BF9); // 메인 색상
}

const textTheme = TextTheme(
  bodyLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  bodyMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  bodySmall: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  displayLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, fontSize: 24, fontWeight: FontWeight.w700),
  displayMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard, fontSize: 18),
  displaySmall: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  headlineLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, fontWeight: FontWeight.w700),
  headlineMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  headlineSmall: TextStyle(fontFamily: Assets.fontFamilyPretendard, fontSize: 16, fontWeight: FontWeight.w500),
  labelLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  labelMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  labelSmall: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  titleLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, fontWeight: FontWeight.w600),
  titleMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard),
  titleSmall: TextStyle(fontFamily: Assets.fontFamilyPretendard),
);

const edgeInsetsZero = EdgeInsets.zero;
const edgeInsetsAll4 = EdgeInsets.all(4);
const edgeInsetsAll8 = EdgeInsets.all(8);
const edgeInsetsAll12 = EdgeInsets.all(12);
const edgeInsetsAll16 = EdgeInsets.all(16);
const edgeInsetsAll24 = EdgeInsets.all(24);

const borderRadiusCircular10 = BorderRadius.all(Radius.circular(10));

late final FlutterSecureStorage storage;