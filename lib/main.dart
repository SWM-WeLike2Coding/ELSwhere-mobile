import 'package:dio/dio.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/services/els_product_service.dart';
import 'package:elswhere/ui/screens/login_screen.dart';
import 'package:elswhere/ui/screens/main_screen.dart';
import 'package:elswhere/ui/screens/more_screen.dart';
import 'package:elswhere/utils/material_color_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await initApp();
  runApp(ELSwhere());
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  baseUrl = dotenv.env['ELS_BASE_URL']!;
  accessToken = dotenv.env['ACCESS_TOKEN']!;
  loginEndpoint = dotenv.env['ELS_LOGIN_ENDPOINT']!;
}

class ELSwhere extends StatelessWidget {
  final Dio _dio = Dio();
  late final ProductService _productService;

  ELSwhere({super.key}) {
    _productService = ProductService(_dio);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ELSOnSaleProductsProvider(_productService)),
        ChangeNotifierProvider(create: (context) => ELSEndSaleProductsProvider(_productService)),
        ChangeNotifierProvider(create: (context) => ELSProductProvider(_productService)),
      ],
      child: MaterialApp(
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
          textTheme: textTheme,
          buttonTheme: ButtonThemeData(
            buttonColor: AppColors.mainBlue,
            textTheme: ButtonTextTheme.primary,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: AppColors.mainBlue
          ),
          switchTheme: SwitchThemeData(
            trackColor: WidgetStatePropertyAll(AppColors.mainBlue),
          )
        ),
        home: const LoginScreen(),
      ),
    );
  }
}