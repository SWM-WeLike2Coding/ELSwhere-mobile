import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/providers/issuer_provider.dart';
import 'package:elswhere/data/providers/ticker_symbol_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/data/services/dio_client.dart';
import 'package:elswhere/data/services/els_product_service.dart';
import 'package:elswhere/data/services/user_service.dart';
import 'package:elswhere/ui/screens/splash_screen.dart';
import 'package:elswhere/utils/material_color_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await initApp();
  runApp(ELSwhere());
}

Future<void> initApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");
  baseUrl = dotenv.env['ELS_BASE_URL']!;
  loginEndpoint = dotenv.env['ELS_LOGIN_ENDPOINT']!;

  storage = const FlutterSecureStorage();
  // await storage.deleteAll();
  accessToken = await storage.read(key: 'ACCESS_TOKEN') ?? '';
  refreshToken = await storage.read(key: 'REFRESH_TOKEN') ?? '';
  print(accessToken);
  print(refreshToken);
}

class ELSwhere extends StatelessWidget {
  late final ProductService _productService;
  late final UserService _userService;

  ELSwhere({super.key}) {
    dio = DioClient.createDio();
    _productService = ProductService(dio);
    _userService = UserService(dio);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ELSOnSaleProductsProvider(_productService)),
        ChangeNotifierProvider(create: (context) => ELSEndSaleProductsProvider(_productService)),
        ChangeNotifierProvider(create: (context) => ELSProductProvider(_productService, _userService)),
        ChangeNotifierProvider(create: (context) => IssuerProvider(_productService)),
        ChangeNotifierProvider(create: (context) => TickerSymbolProvider(_productService)),
        ChangeNotifierProvider(create: (context) => UserInfoProvider(_userService)),
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
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: AppColors.mainBlue,
            backgroundColor: AppColors.contentWhite,
            landscapeLayout: BottomNavigationBarLandscapeLayout.linear
          ),
          switchTheme: const SwitchThemeData(
            trackColor: WidgetStatePropertyAll(AppColors.mainBlue),
            trackOutlineColor: WidgetStatePropertyAll(AppColors.contentGray),
            thumbColor: WidgetStatePropertyAll(AppColors.contentWhite),
          )
        ),
        home: SplashScreen(),
      ),
    );
  }
}