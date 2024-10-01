import 'dart:developer';
import 'dart:io';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/providers/hot_products_provider.dart';
import 'package:elswhere/data/providers/issuer_provider.dart';
import 'package:elswhere/data/providers/ticker_symbol_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/data/services/analysis_service.dart';
import 'package:elswhere/data/services/dio_client.dart';
import 'package:elswhere/data/services/els_product_service.dart';
import 'package:elswhere/data/services/user_service.dart';
import 'package:elswhere/data/services/yfinance_service.dart';
import 'package:elswhere/ui/screens/splash_screen.dart';
import 'package:elswhere/utils/material_color_builder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

void main() async {
  try {
    await initApp();
  } catch (e) {
    FlutterNativeSplash.remove();
    log('$e');
  }
  runApp(ELSwhere());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initApp() async {
  await dotenv.load(fileName: ".env");
  baseUrl = dotenv.env['ELS_BASE_URL']!;
  loginEndpoint = dotenv.env['ELS_LOGIN_ENDPOINT']!;
  // await storage.deleteAll();

  storage = const FlutterSecureStorage();

  try {
    accessToken = await storage.read(key: 'ACCESS_TOKEN') ?? '';
    refreshToken = await storage.read(key: 'REFRESH_TOKEN') ?? '';
  } catch (e) {
    await storage.deleteAll();
    accessToken = refreshToken = '';
    Fluttertoast.showToast(msg: '데이터가 손상되었습니다. 다시 로그인 해주세요.', toastLength: Toast.LENGTH_SHORT);
  }

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  // FirebaseMessaging.instance.onTokenRefresh
  //   .listen((fcmToken) {
  //
  //   })
  //   .onError((err) {
  //
  //   });
  // print(fcmToken);

  // await initPermissionSettings();
  // await setPermissionGranted();

  print(accessToken);
  print(refreshToken);
}

Future<void> initPermissionSettings() async {
  // Android 초기화 설정
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS 초기화 설정
  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

  // 초기화 설정 통합
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // 플러그인 초기화
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> setPermissionGranted() async {
  // Android
  final bool? grantedAndroid = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

  // iOS
  final bool? grantedIOS = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  if (Platform.isIOS) {
  } else if (Platform.isAndroid) {}
}

class ELSwhere extends StatelessWidget {
  late final ProductService _productService;
  late final UserService _userService;
  late final YFinanceService _yFinanceService;
  late final AnalysisService _analysisService;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  ELSwhere({super.key}) {
    dio = DioClient.createDio();
    _productService = ProductService(dio);
    _userService = UserService(dio);
    _yFinanceService = YFinanceService.getInstance();
    _analysisService = AnalysisService(dio);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ELSOnSaleProductsProvider(_productService)),
        ChangeNotifierProvider(create: (context) => ELSEndSaleProductsProvider(_productService)),
        ChangeNotifierProvider(create: (context) => ELSProductProvider(_productService, _userService, _yFinanceService, _analysisService)),
        ChangeNotifierProvider(create: (context) => IssuerProvider(_productService)),
        ChangeNotifierProvider(create: (context) => TickerSymbolProvider(_productService)),
        ChangeNotifierProvider(create: (context) => UserInfoProvider(_userService)),
        ChangeNotifierProvider(create: (context) => HotProductsProvider(_productService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ko', ''),
        ],
        navigatorObservers: [observer],
        title: appName,
        theme: ThemeData(
          primarySwatch: MaterialColorBuilder.createMaterialColor(AppColors.mainBlue),
          primaryColor: AppColors.mainBlue,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColorBuilder.createMaterialColor(Colors.white),
          ),
          scaffoldBackgroundColor: AppColors.contentWhite,
          textTheme: textTheme,
          buttonTheme: const ButtonThemeData(
            buttonColor: AppColors.mainBlue,
            textTheme: ButtonTextTheme.primary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.contentWhite,
          ),
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(selectedItemColor: AppColors.mainBlue, backgroundColor: AppColors.contentWhite, landscapeLayout: BottomNavigationBarLandscapeLayout.linear),
          switchTheme: const SwitchThemeData(
            trackColor: WidgetStatePropertyAll(AppColors.mainBlue),
            trackOutlineColor: WidgetStatePropertyAll(AppColors.gray400),
            thumbColor: WidgetStatePropertyAll(AppColors.contentWhite),
          ),
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
        home: SplashScreen(),
      ),
    );
  }
}
