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

  static const String iconELSwhere = "assets/icons/icon_elswhere.svg";

  static const String iconGoogle = "assets/icons/icon_google.svg";

  static const String iconBNK = "assets/icons/company/bnk.svg";
  static const String iconKyoBo = "assets/icons/company/교보.svg";
  static const String iconKookMin = "assets/icons/company/국민.svg";
  static const String iconIBK = "assets/icons/company/ibk.svg";
  static const String iconNH = "assets/icons/company/nh.svg";
  static const String iconUnion = "assets/icons/company/유니온.svg";
  static const String iconYuanta = "assets/icons/company/유안타.svg";
  static const String iconEugene = "assets/icons/company/유진.svg";
  static const String iconEBest = "assets/icons/company/이베스트.svg";
  static const String iconJeokSok = "assets/icons/company/저축.svg";
  static const String iconDiners = "assets/icons/company/다이너스.svg";
  static const String iconDaeGu = "assets/icons/company/대구.svg";
  static const String iconDaeShin = "assets/icons/company/대신.svg";
  static const String iconDeutsch = "assets/icons/company/도이치.svg";
  static const String iconDB = "assets/icons/company/db.svg";
  static const String iconDiscover = "assets/icons/company/디스커버.svg";
  static const String iconJeonBukGwangJu = "assets/icons/company/전북광주.svg";
  static const String iconChinaConstruction = "assets/icons/company/중국건설.svg";
  static const String iconChinaIndustry = "assets/icons/company/중국공산.svg";
  static const String iconKakao = "assets/icons/company/kakao.svg";
  static const String iconKBank = "assets/icons/company/kbank.svg";
  static const String iconCape = "assets/icons/company/케이프.svg";
  static const String iconLotte = "assets/icons/company/롯데.svg";
  static const String iconMeritz = "assets/icons/company/메리츠.svg";
  static const String iconMiraeAsset = "assets/icons/company/미래에셋.svg";
  static const String iconBOA = "assets/icons/company/boa.svg";
  static const String iconBuKuk = "assets/icons/company/부국.svg";
  static const String iconKiwoom = "assets/icons/company/키움.svg";
  static const String iconToss = "assets/icons/company/토스.svg";
  static const String iconPayco = "assets/icons/company/페이코.svg";
  static const String iconHana = "assets/icons/company/하나.svg";
  static const String iconKoreaInvestment = "assets/icons/company/한국투자.svg";
  static const String iconKoreaPost = "assets/icons/company/한국포스.svg";
  static const String iconIndustry = "assets/icons/company/산업.svg";
  static const String iconSamsung = "assets/icons/company/삼성.svg";
  static const String iconSaeMaeulGeumGo = "assets/icons/company/새마을금고.svg";
  static const String iconSH = "assets/icons/company/sh.svg";
  static const String iconHanwha = "assets/icons/company/한화.svg";
  static const String iconHyundaiCar = "assets/icons/company/현대차.svg";
  static const String iconHyundaiCard = "assets/icons/company/현대카드.svg";
  static const String iconBC = "assets/icons/company/bc.svg";
  static const String iconBNPParibas = "assets/icons/company/bnp파리바.svg";
  static const String iconHSBC = "assets/icons/company/hsbc.svg";
  static const String iconCity = "assets/icons/company/시티.svg";
  static const String iconShinYoung = "assets/icons/company/신영.svg";
  static const String iconShinHan = "assets/icons/company/신한.svg";
  static const String iconShinHyup = "assets/icons/company/신협.svg";
  static const String iconAMEX = "assets/icons/company/아멕스.svg";
  static const String iconWoori = "assets/icons/company/우리.svg";
  static const String iconJCB = "assets/icons/company/jcb.svg";
  static const String iconJPChase = "assets/icons/company/jp모간체이스.svg";
  static const String iconKTB = "assets/icons/company/ktb.svg";
  static const String iconMaster = "assets/icons/company/마스터.svg";
  static const String iconSCFirst = "assets/icons/company/sc제일.svg";
  static const String iconSK = "assets/icons/company/sk.svg";
  static const String iconVisa = "assets/icons/company/visa.svg";


  static const Map<String, String> issuerIconMap = {
    "DB금융투자": "assets/icons/company/db.svg",
    "IBK투자증권": "assets/icons/company/ibk.svg",
    "NH투자증권": "assets/icons/company/nh.svg",
    "SK증권": "assets/icons/company/sk.svg",
    "KB증권": "assets/icons/company/국민.svg",
    "교보증권": "assets/icons/company/교보.svg",
    "다이와증권캐피탈마켓코리아": "assets/icons/company/다이와.svg",
    "대신증권": "assets/icons/company/대신.svg",
    "도이치증권": "assets/icons/company/도이치.svg",
    "메리츠증권": "assets/icons/company/메리츠.svg",
    "미래에셋증권": "assets/icons/company/미래에셋.svg",
    "부국증권": "assets/icons/company/부국.svg",
    "삼성증권": "assets/icons/company/삼성.svg",
    "신영증권": "assets/icons/company/신영.svg",
    "신한투자증권": "assets/icons/company/신한.svg",
    "유안타증권": "assets/icons/company/유안타.svg",
    "유진투자증권": "assets/icons/company/유진.svg",
    "케이프투자증권": "assets/icons/company/케이프.svg",
    "키움증권": "assets/icons/company/키움.svg",
    "토스증권": "assets/icons/company/토스.svg",
    "하나증권": "assets/icons/company/하나.svg",
    "한국투자증권": "assets/icons/company/한국투자.svg",
    "한국포스증권": "assets/icons/company/한국포스.svg",
    "한화투자증권": "assets/icons/company/한화.svg",
    "현대차증권": "assets/icons/company/현대차.svg",
  };
}

sealed class AppColors {
  static const Color contentRed = Color(0xFFEE5648);
  static const Color contentYellow = Color(0xFFF3972C);
  static const Color contentGray = Color(0xFF838A8E);
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

  static const Color backgroundGray = Color(0xFFF5F6F6);
  static const Color iconGray = Color(0xFFCFD2D3);
  static const Color textGray = Color(0xFF595E62);
  static const Color titleGray = Color(0xFF4C4F53);
}

const textTheme = TextTheme(
  bodyLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02),
  bodyMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02),
  bodySmall: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02),
  displayLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontSize: 24, fontWeight: FontWeight.w700),
  displayMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontSize: 18),
  displaySmall: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontSize: 12),
  headlineLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontWeight: FontWeight.w700),
  headlineMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02),
  headlineSmall: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontSize: 16, fontWeight: FontWeight.w500),
  labelLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontSize: 24, color: AppColors.contentBlack, fontWeight: FontWeight.w600),
  labelMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontSize: 17, fontWeight: FontWeight.w500),
  labelSmall: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontSize: 12, fontWeight: FontWeight.w500),
  titleLarge: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02, fontWeight: FontWeight.w600),
  titleMedium: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02),
  titleSmall: TextStyle(fontFamily: Assets.fontFamilyPretendard, letterSpacing: -0.02),
);

const edgeInsetsZero = EdgeInsets.zero;
const edgeInsetsAll4 = EdgeInsets.all(4);
const edgeInsetsAll8 = EdgeInsets.all(8);
const edgeInsetsAll12 = EdgeInsets.all(12);
const edgeInsetsAll16 = EdgeInsets.all(16);
const edgeInsetsAll24 = EdgeInsets.all(24);

const borderRadiusCircular10 = BorderRadius.all(Radius.circular(10));

late final FlutterSecureStorage storage;