// import 'dart:developer';
// import 'dart:ui' as ui;

// import 'package:elswhere/config/app_resource.dart';
// import 'package:elswhere/config/config.dart';
// import 'package:elswhere/data/models/dtos/product/summarized_product_dto.dart';
// import 'package:elswhere/data/providers/els_product_provider.dart';
// import 'package:elswhere/data/providers/els_products_provider.dart';
// import 'package:elswhere/data/providers/user_info_provider.dart';
// import 'package:elswhere/ui/screens/product/compare_product_screen.dart';
// import 'package:elswhere/ui/screens/product/els_product_detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:marquee/marquee.dart';
// import 'package:provider/provider.dart';

// class ELSProductCard<T extends SummarizedProductDto> extends StatefulWidget {
//   final T product;
//   final int index;
//   bool isOnSale = false;
//   void Function(bool, SummarizedProductDto)? checkCompare;

//   ELSProductCard({super.key, required this.product, required this.index, this.checkCompare, this.isOnSale = false});

//   @override
//   State<ELSProductCard> createState() => _ELSProductCardState();
// }

// class _ELSProductCardState extends State<ELSProductCard> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   bool isSelected = false;
//   bool nowComparing = false;
//   final cardHeight = 105.0;
//   bool isOnSale = false;

//   late SummarizedProductDto product;
//   late ELSProductProvider productProvider;
//   late ELSProductsProvider productsProvider;
//   late UserInfoProvider userProvider;

//   @override
//   void initState() {
//     super.initState();
//     isOnSale = widget.isOnSale;
//     product = widget.product;
//     productProvider = Provider.of<ELSProductProvider>(context, listen: false);
//     productsProvider = Provider.of<ELSOnSaleProductsProvider>(context, listen: false);
//     userProvider = Provider.of<UserInfoProvider>(context, listen: false);
//   }

//   void onItemTapped() {
//     productsProvider.setSelectedIndex(widget.index);
//     // setState(() {
//     //   isSelected = productsProvider.selectedIndex == widget.index;
//     //   //   isSelected = !isSelected;
//     // });
//   }

//   void onDetailButtonTapped() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );

//     await productProvider.fetchProduct(product.id);
//     await productProvider.fetchStockPrices();
//     await productProvider.fetchMonteCarloResponse(product.id);
//     final result = productProvider.checkisHeld(userProvider.holdingProducts ?? []);

//     // 로딩 다이얼로그 닫기
//     Navigator.of(context).pop();

//     if (productProvider.product != null && result) {
//       // ELSDetailDialog.show(context, productProvider.product!);
//       Navigator.push(context, MaterialPageRoute(builder: (context) => const ELSProductDetailScreen()));
//       onItemTapped();
//     } else {
//       Fluttertoast.showToast(msg: '상품을 불러오는데 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return Consumer<ELSOnSaleProductsProvider>(
//       builder: (context, value, child) {
//         isSelected = productsProvider.selectedIndex == widget.index;
//         return LayoutBuilder(builder: (context, constraints) {
//           // final width = constraints.maxWidth;
//           return GestureDetector(
//             onTap: () => onItemTapped(),
//             child: Stack(
//               children: [
//                 _buildHiddenButtons(),
//                 _buildItemCard(),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   Widget _buildHiddenButtons() {
//     return Positioned(
//       right: 0,
//       child: SizedBox(
//         height: cardHeight,
//         width: 190 - (isOnSale ? 0 : 91),
//         child: Row(
//           children: [
//             Padding(
//               padding: edgeInsetsAll8,
//               child: GestureDetector(
//                 onTap: onDetailButtonTapped,
//                 child: Container(
//                   width: 75,
//                   decoration: const BoxDecoration(
//                     borderRadius: borderRadiusCircular10,
//                     color: AppColors.gray50,
//                   ),
//                   child: Padding(
//                     padding: edgeInsetsAll16,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.arrow_right_alt,
//                           color: AppColors.gray600,
//                         ),
//                         Text(
//                           '자세히',
//                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                 color: AppColors.gray600,
//                               ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             if (isOnSale)
//               Padding(
//                 padding: edgeInsetsAll8,
//                 child: GestureDetector(
//                   child: Container(
//                     width: 75,
//                     decoration: const BoxDecoration(
//                       borderRadius: borderRadiusCircular10,
//                       color: AppColors.gray800,
//                     ),
//                     child: Padding(
//                       padding: edgeInsetsAll16,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.add,
//                             color: AppColors.contentWhite,
//                           ),
//                           Text(
//                             '비교',
//                             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                   color: AppColors.contentWhite,
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   onTap: () async {
//                     productProvider.compareId.add(widget.product.id);
//                     if (productProvider.compareId.length == 2) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => CompareProductScreen()),
//                       );
//                     } else {
//                       setState(() {
//                         nowComparing = !nowComparing;
//                         if (widget.checkCompare != null) {
//                           widget.checkCompare!(nowComparing, widget.product);
//                         }
//                       });
//                       final result = await productsProvider.fetchSimilarProducts(widget.product.id);
//                       if (!result) {
//                         Fluttertoast.showToast(msg: '제품을 불러오는데 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
//                       }
//                     }
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildItemCard() {
//     final dayDifference = widget.product.subscriptionEndDate.difference(DateTime.now()).inDays;

//     return AnimatedContainer(
//       curve: Curves.fastOutSlowIn,
//       duration: const Duration(milliseconds: 500),
//       transform: Matrix4.translationValues(isSelected ? (isOnSale ? -200 : -100) : 0, 0, 0),
//       child: Container(
//         height: cardHeight,
//         padding: edgeInsetsAll16,
//         decoration: BoxDecoration(color: AppColors.contentWhite, borderRadius: borderRadiusCircular10, border: Border.all(color: isSelected ? AppColors.gray50 : AppColors.contentWhite)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Consumer<ELSProductProvider>(
//               builder: (context, provider, child) {
//                 return Column(
//                   children: [
//                     Stack(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: AppColors.gray50,
//                           child: Padding(
//                             padding: edgeInsetsAll4,
//                             child:
//                                 Assets.issuerIconMap[product.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[product.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack),
//                           ),
//                         ),
//                         if (provider.likeProducts.any((e) => e.id == product.id))
//                           const Positioned(
//                             right: 0,
//                             bottom: 0,
//                             child: Icon(
//                               Icons.favorite,
//                               color: AppColors.contentRed,
//                               size: 16,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 );
//               },
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.product.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: AppColors.contentBlack,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                       // const SizedBox(height: 8),
//                       SizedBox(
//                         height: 16,
//                         child: LayoutBuilder(
//                           builder: (context, constraints) {
//                             final textPainter = TextPainter(
//                               text: TextSpan(
//                                 text: widget.product.equities,
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                               maxLines: 1,
//                               textDirection: ui.TextDirection.ltr,
//                             )..layout(maxWidth: constraints.maxWidth);

//                             final isOverflowing = textPainter.didExceedMaxLines;

//                             return isOverflowing
//                                 ? Marquee(
//                                     text: widget.product.equities,
//                                     style: const TextStyle(color: AppColors.gray400, fontSize: 14),
//                                     scrollAxis: Axis.horizontal,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     startAfter: const Duration(seconds: 1),
//                                     blankSpace: 30,
//                                     velocity: 30.0,
//                                     accelerationDuration: const Duration(seconds: 1),
//                                     accelerationCurve: Curves.linear,
//                                     fadingEdgeEndFraction: 0.7,
//                                     decelerationDuration: const Duration(milliseconds: 500),
//                                     decelerationCurve: Curves.easeOut,
//                                   )
//                                 : Text(
//                                     widget.product.equities,
//                                     style: const TextStyle(color: AppColors.gray400, fontSize: 14),
//                                   );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     '${productType[widget.product.productType]!}형',
//                     style: const TextStyle(color: AppColors.mainBlue),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '연 ${widget.product.yieldIfConditionsMet}%',
//                   style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: -0.02,
//                         fontSize: 18,
//                         color: AppColors.contentRed,
//                       ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   '${dayDifference != 0 ? '${dayDifference.abs()}일 ${dayDifference < 0 ? '전' : '후'}' : '오늘'} 마감',
//                   style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                         fontSize: 14,
//                         color: AppColors.gray600,
//                       ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/product/summarized_product_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/product/compare_product_screen.dart';
import 'package:elswhere/ui/screens/product/els_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class ELSProductCard<T extends SummarizedProductDto> extends StatefulWidget {
  final T product;
  final int index;
  bool isOnSale = false;
  void Function(bool, SummarizedProductDto)? checkCompare;

  ELSProductCard({
    super.key,
    required this.product,
    required this.index,
    this.checkCompare,
    this.isOnSale = false,
  });

  @override
  State<ELSProductCard> createState() => _ELSProductCardState();
}

class _ELSProductCardState extends State<ELSProductCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isSelected = false;
  bool nowComparing = false;
  bool isOnSale = false;
  late SummarizedProductDto product;
  late ELSProductProvider productProvider;
  late ELSProductsProvider productsProvider;
  late UserInfoProvider userProvider;

  final double cardHeight = 105.0;

  @override
  void initState() {
    super.initState();
    isOnSale = widget.isOnSale;
    product = widget.product;
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    productsProvider = Provider.of<ELSOnSaleProductsProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  void onItemTapped() {
    // productsProvider.setSelectedIndex(widget.index);
    setState(() {
      isSelected = !isSelected;
    });
  }

  Future<void> onDetailButtonTapped() async {
    _showLoadingDialog();

    await productProvider.fetchProduct(product.id);
    await productProvider.fetchStockPrices();
    await productProvider.fetchMonteCarloResponse(product.id);
    final result = productProvider.checkisHeld(userProvider.holdingProducts ?? []);

    Navigator.of(context).pop(); // 로딩 다이얼로그 닫기

    if (productProvider.product != null && result) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ELSProductDetailScreen()),
      );
      onItemTapped();
    } else {
      Fluttertoast.showToast(msg: '상품을 불러오는데 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void onCompareTapped() async {
    productProvider.compareId.add(widget.product.id);
    if (productProvider.compareId.length == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompareProductScreen()),
      );
    } else {
      setState(() => nowComparing = !nowComparing);
      widget.checkCompare?.call(nowComparing, widget.product);
      final result = await productsProvider.fetchSimilarProducts(widget.product.id);
      if (!result) {
        Fluttertoast.showToast(msg: '제품을 불러오는데 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ELSOnSaleProductsProvider>(
      builder: (context, value, child) {
        // isSelected = productsProvider.selectedIndex == widget.index;
        return LayoutBuilder(builder: (context, constraints) {
          return GestureDetector(
            onTap: onItemTapped,
            child: Stack(
              children: [
                _buildHiddenButtons(),
                _buildItemCard(),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildHiddenButtons() {
    return Positioned(
      right: 0,
      child: SizedBox(
        height: cardHeight,
        width: isOnSale ? 190 : 99,
        child: Row(
          children: [
            _buildActionButton(
              icon: Icons.arrow_right_alt,
              label: '자세히',
              color: AppColors.gray50,
              textColor: AppColors.gray600,
              onTap: onDetailButtonTapped,
            ),
            if (isOnSale)
              _buildActionButton(
                icon: Icons.add,
                label: '비교',
                color: AppColors.gray800,
                textColor: AppColors.contentWhite,
                onTap: onCompareTapped,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: edgeInsetsAll8,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 75,
          decoration: BoxDecoration(
            borderRadius: borderRadiusCircular10,
            color: color,
          ),
          child: Padding(
            padding: edgeInsetsAll16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: textColor),
                Text(
                  label,
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard() {
    final dayDifference = widget.product.subscriptionEndDate.difference(DateTime.now()).inDays;
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      transform: Matrix4.translationValues(isSelected ? (isOnSale ? -200 : -100) : 0, 0, 0),
      child: Container(
        height: cardHeight,
        padding: edgeInsetsAll16,
        decoration: BoxDecoration(
          color: AppColors.contentWhite,
          borderRadius: borderRadiusCircular10,
          border: Border.all(color: isSelected ? AppColors.gray50 : AppColors.contentWhite),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProductIcon(),
            const SizedBox(width: 16),
            Expanded(child: _buildProductDetails(dayDifference)),
            const SizedBox(width: 8),
            _buildYieldInfo(dayDifference),
          ],
        ),
      ),
    );
  }

  Widget _buildProductIcon() {
    return Consumer<ELSProductProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.gray50,
                  child: Padding(
                    padding: edgeInsetsAll4,
                    child: Assets.issuerIconMap[product.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[product.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack),
                  ),
                ),
                if (provider.likeProducts.any((e) => e.id == product.id))
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(Icons.favorite, color: AppColors.contentRed, size: 16),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductDetails(int dayDifference) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.contentBlack,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            // const SizedBox(height: 8),
            SizedBox(
              height: 16,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isOverflowing = _isTextOverflowing(widget.product.equities, constraints.maxWidth);
                  return isOverflowing
                      ? Marquee(
                          text: widget.product.equities,
                          style: const TextStyle(color: AppColors.gray400, fontSize: 14),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          startAfter: const Duration(seconds: 1),
                          blankSpace: 30,
                          velocity: 30.0,
                          fadingEdgeEndFraction: 0.7,
                        )
                      : Text(
                          widget.product.equities,
                          style: const TextStyle(color: AppColors.gray400, fontSize: 14),
                        );
                },
              ),
            ),
          ],
        ),
        Text(
          '${productType[widget.product.productType]!}형',
          style: const TextStyle(color: AppColors.mainBlue),
        ),
      ],
    );
  }

  Widget _buildYieldInfo(int dayDifference) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '연 ${widget.product.yieldIfConditionsMet}%',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.02,
                fontSize: 18,
                color: AppColors.contentRed,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          '${dayDifference != 0 ? '${dayDifference.abs()}일 ${dayDifference < 0 ? '전' : '후'}' : '오늘'} 마감',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 14,
                color: AppColors.gray600,
              ),
        ),
      ],
    );
  }

  bool _isTextOverflowing(String text, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 14)),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }
}
