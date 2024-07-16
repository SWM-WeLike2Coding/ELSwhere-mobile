// import 'package:elswhere/providers/els_product_provider.dart';
// import 'package:elswhere/providers/els_products_provider.dart';
// import 'package:elswhere/resources/app_resource.dart';
// import 'package:elswhere/resources/config.dart';
// import 'package:elswhere/services/els_product_service.dart';
// import 'package:elswhere/screens/main_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// void main() {
//   initApp();
//   runApp(const ELSwhere());
// }
//
// Future<void> initApp() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
// }
//
// class ELSwhere extends StatelessWidget {
//   const ELSwhere({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ELSProductsProvider(ProductService())),
//         ChangeNotifierProvider(create: (context) => ELSProductProvider(ProductService())),
//       ],
//       child: MaterialApp(
//         localizationsDelegates: const [
//           GlobalCupertinoLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//         ],
//         supportedLocales: const [
//           Locale('en', ''),
//           Locale('ko', ''),
//         ],
//         title: appName,
//         theme: ThemeData(
//           primarySwatch: Colors.purple,
//           textTheme: textTheme,
//         ),
//         home: MainScreen(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CardListScreen()));
}

class CardListScreen extends StatefulWidget {
  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  int _selectedIndex = -1;

  void _onCardTapped(int index) {
    setState(() {
      _selectedIndex = _selectedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('애니메이션'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return CardItem(
            index: index,
            isSelected: _selectedIndex == index,
            onTap: _onCardTapped,
          );
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  const CardItem({
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Stack(
              children: [
                Positioned(
                  left: width - 165,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 100,
                    width: 165,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.grey
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey
                            ),
                            child: Center(
                              child: Text('상세보기', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(10))
                            ),
                            child:
                              Center(
                                child: Text('비교하기', style: TextStyle(color: Colors.white),),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  height: 100,
                  duration: Duration(milliseconds: 500),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  transform:
                      Matrix4.translationValues(isSelected ? -150 : 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Card $index',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
