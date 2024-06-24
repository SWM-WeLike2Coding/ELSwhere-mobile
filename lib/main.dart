import 'package:elswhere/providers/els_product_provider.dart';
import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/services/els_product_service.dart';
import 'package:elswhere/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ELSwhere());
}

class ELSwhere extends StatelessWidget {
  const ELSwhere({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ELSProductProvider(ProductService()),
      child: MaterialApp(
        title: 'Flutter Product List Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: Assets.fontFamilyNanum,
          textTheme: textTheme,
        ),
        home: MainScreen(),
      ),
    );
  }
}
