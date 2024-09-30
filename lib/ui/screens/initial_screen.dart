import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/issuer_provider.dart';
import 'package:elswhere/data/providers/ticker_symbol_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/main_screen.dart';
import 'package:elswhere/ui/screens/waiting_screen.dart';
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
        Provider.of<UserInfoProvider>(context, listen: false).checkMyInvestmentType(),
        Provider.of<ELSProductProvider>(context, listen: false).fetchInterested(),
        Provider.of<UserInfoProvider>(context, listen: false).fetchHoldingProducts(),
        Provider.of<ELSProductProvider>(context, listen: false).fetchLikeProducts(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const WaitingScreen(comment: '데이터 로딩중 입니다...');
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          return const MainScreen();
        }
      },
    );
  }
}
