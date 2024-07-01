import 'package:elswhere/providers/els_product_provider.dart';
import 'package:elswhere/providers/els_products_provider.dart';
import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/resources/config.dart';
import 'package:elswhere/services/els_product_service.dart';
import 'package:elswhere/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

bool temp = true;

void main() {
  runApp(const ELSwhere());
}

class ELSwhere extends StatelessWidget {
  const ELSwhere({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ELSProductsProvider(ProductService())),
        ChangeNotifierProvider(create: (context) => ELSProductProvider(ProductService())),
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
          primarySwatch: Colors.purple,
          fontFamily: Assets.fontFamilyNanum,
          textTheme: textTheme,
        ),
        home: MainScreen(),
      ),
    );
  }
}