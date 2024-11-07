import 'package:elswhere/config/config.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/issuer_provider.dart';
import 'package:elswhere/data/providers/ticker_symbol_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/other/main_screen.dart';
import 'package:elswhere/ui/screens/other/waiting_screen.dart';
import 'package:elswhere/utils/utils.dart';
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
        Provider.of<UserInfoProvider>(context, listen: false).getSurveyParticipationStatus(),
        Provider.of<ELSProductProvider>(context, listen: false).fetchInterested(),
        Provider.of<UserInfoProvider>(context, listen: false).fetchHoldingProducts(),
        Provider.of<ELSProductProvider>(context, listen: false).fetchLikeProducts(),
        currentStoreVersion(packageName),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const WaitingScreen(initialComment: MSG_LOADING_DATA);
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          return const MainScreen();
        }
      },
    );
  }
}
