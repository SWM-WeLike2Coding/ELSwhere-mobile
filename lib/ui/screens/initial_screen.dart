import 'dart:io';

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/issuer_provider.dart';
import 'package:elswhere/data/providers/ticker_symbol_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<IssuerProvider>(context, listen: false).fetchIssuers(),
        Provider.of<TickerSymbolProvider>(context, listen: false).fetchTickers(),
        Provider.of<TickerSymbolProvider>(context, listen: false).fetchStockPrices(),
        Provider.of<UserInfoProvider>(context, listen: false).checkUser(),
        Provider.of<ELSProductProvider>(context, listen: false).fetchInterested(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.mainBlue,
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    '데이터 로딩중 입니다...',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.contentBlack,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          return MainScreen();
        }
      },
    );
  }
}
