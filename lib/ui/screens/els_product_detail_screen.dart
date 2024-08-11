import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/ui/views/els_product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/models/dtos/response_single_product_dto.dart';


class ELSProductDetailScreen extends StatefulWidget {
  const ELSProductDetailScreen({super.key});

  @override
  State<ELSProductDetailScreen> createState() => _ELSProductDetailScreenState();
}

class _ELSProductDetailScreenState extends State<ELSProductDetailScreen> {
  bool isLiked = false;

  void changeLiked() => setState(() => isLiked = !isLiked);
  // void changeBookmarked() => setState(() => isBookmarked = !isBookmarked);
  void changeBookmarked() {
    final productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    ResponseSingleProductDto? product = productProvider.product;
    int? interestedId = productProvider.interestedId;
    bool isBookmarked = productProvider.isBookmarked;
    // print(interestedId);
    if (isBookmarked == false) {
      print("관심 등록합니다.");
      // print(product!.id);
      productProvider.registerInterested(product!.id);
    } else {
      print("관심 해지합니다.");
      productProvider.deleteFromInterested();
    }

    setState(() {
      isBookmarked = productProvider.isBookmarked;
      // isBookmarked = !isBookmarked;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, productProvider, child) {
        final isBookmarked = productProvider.isBookmarked;

        return Scaffold(
          backgroundColor: AppColors.backgroundGray,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: Padding(
              padding: edgeInsetsAll8,
              child: AppBar(
                backgroundColor: AppColors.backgroundGray,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: AppColors.contentWhite,
                      child: isLiked
                          ? const Icon(Icons.favorite, color: AppColors.contentRed)
                          : const Icon(Icons.favorite_border_outlined),
                    ),
                    onPressed: changeLiked,
                  ),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: AppColors.contentWhite,
                      child: isBookmarked
                          ? const Icon(Icons.bookmark, color: AppColors.contentYellow)
                          : const Icon(Icons.bookmark_border_outlined),
                    ),
                    onPressed: changeBookmarked,
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: AppColors.contentWhite,
                      child: const Icon(Icons.add),
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(msg: '추후 업데이트를 통해 제공될 예정입니다.', toastLength: Toast.LENGTH_SHORT);
                    },
                  ),
                ],
              ),
            ),
          ),
          body: ELSProductDetailView(),
        );
      },
    );

    // return Scaffold(
    //   backgroundColor: AppColors.backgroundGray,
    //   appBar: PreferredSize(
    //     preferredSize: const Size.fromHeight(72),
    //     child: Padding(
    //       padding: edgeInsetsAll8,
    //       child: AppBar(
    //         backgroundColor: AppColors.backgroundGray,
    //         leading: IconButton(
    //           icon: const Icon(Icons.arrow_back_rounded),
    //           onPressed: () => Navigator.pop(context),
    //         ),
    //         actions: [
    //           IconButton(
    //             icon: CircleAvatar(
    //               backgroundColor: AppColors.contentWhite,
    //               child: isLiked
    //                   ? const Icon(Icons.favorite, color: AppColors.contentRed)
    //                   : const Icon(Icons.favorite_border_outlined),
    //             ),
    //             onPressed: changeLiked,
    //           ),
    //           IconButton(
    //             icon: CircleAvatar(
    //               backgroundColor: AppColors.contentWhite,
    //               child: isBookmarked
    //                   ? const Icon(Icons.bookmark, color: AppColors.contentYellow)
    //                   : const Icon(Icons.bookmark_border_outlined),
    //             ),
    //             onPressed: changeBookmarked,
    //           ),
    //           IconButton(
    //             icon: const CircleAvatar(
    //               backgroundColor: AppColors.contentWhite,
    //               child: const Icon(Icons.add),
    //             ),
    //             onPressed: () {},
    //           ),
    //
    //         ],
    //       ),
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     child: ELSProductDetailView(),
    //   ),
    // );
  }

  Widget _buildCompanyCard(BoxConstraints constraints) {
    final height = constraints.maxHeight;
    final width = constraints.maxWidth;
    return SizedBox(
      height: height / 6,
      width: width / 2 - 30,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular10),
        color: AppColors.blues2,
        child: Container(
          padding: edgeInsetsAll16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Hello'),
            ],
          ),
        ),
      ),
    );
  }
}
