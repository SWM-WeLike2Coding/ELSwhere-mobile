import 'dart:ui' as ui;

import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/views/els_product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import '../models/dtos/summarized_product_dto.dart';
import '../providers/els_product_provider.dart';

class ELSProductCard extends StatelessWidget {
  final SummarizedProductDto product;

  const ELSProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ELSProductProvider>(context, listen: false);
    final format = DateFormat('yyyy년 MM월 dd일');

    return Card(
      elevation: 3,
      child: InkWell(
        child: Container(
          padding: edgeInsetsAll12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.contentPurple,
                AppColors.contentPurple.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadiusCircular10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.contentWhite,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    SizedBox(
                      height: 16,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final textPainter = TextPainter(
                            text: TextSpan(
                              text: product.equities,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            maxLines: 1,
                            textDirection: ui.TextDirection.ltr,
                          )..layout(maxWidth: constraints.maxWidth);

                          final isOverflowing = textPainter.didExceedMaxLines;

                          return isOverflowing
                              ? Marquee(
                                  text: product.equities,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  startAfter: const Duration(seconds: 1),
                                  velocity: 30.0,
                                  pauseAfterRound: const Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: const Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  fadingEdgeEndFraction: 0.7,
                                  decelerationDuration: const Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                )
                              : Text(
                                  product.equities,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '${format.format(product.subscriptionStartDate)}',
                      style: const TextStyle(color: AppColors.contentWhite),
                    ),
                  ],
                ),
              ),
              Text(
                '${product.yieldIfConditionsMet}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.contentWhite,
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          await productProvider.fetchProduct(product.id);

          // 로딩 다이얼로그 닫기
          Navigator.of(context).pop();

          if (productProvider.product != null) {
            // ELSDetailDialog.show(context, productProvider.product!);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ELSProductDetailView())
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(home: CardListScreen()));
// }
//
// class CardListScreen extends StatefulWidget {
//   @override
//   _CardListScreenState createState() => _CardListScreenState();
// }
//
// class _CardListScreenState extends State<CardListScreen> {
//   int _selectedIndex = -1;
//
//   void _onCardTapped(int index) {
//     setState(() {
//       _selectedIndex = _selectedIndex == index ? -1 : index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Card List with Animation'),
//       ),
//       body: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return CardItem(
//             index: index,
//             isSelected: _selectedIndex == index,
//             onTap: _onCardTapped,
//           );
//         },
//       ),
//     );
//   }
// }
//
// class CardItem extends StatelessWidget {
//   final int index;
//   final bool isSelected;
//   final Function(int) onTap;
//
//   const CardItem({
//     required this.index,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: Stack(
//         children: [
//           AnimatedContainer(
//             curve: Curves.fastOutSlowIn,
//             duration: Duration(milliseconds: 500),
//             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             transform: Matrix4.translationValues(isSelected ? 150 : 0, 0, 0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Card $index',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 if (isSelected)
//                   Icon(
//                     Icons.arrow_forward,
//                     color: Colors.white,
//                   ),
//               ],
//             ),
//           ),
//           AnimatedContainer(
//             curve: Curves.fastOutSlowIn,
//             duration: Duration(milliseconds: 500),
//             transform: Matrix4.translationValues(isSelected ? 0 : -150, 0, 0),
//             child: Container(
//               height: 70,
//               width: 150,
//               color: Colors.red,
//               child: Center(
//                 child: Text(
//                   'Additional Menu',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
