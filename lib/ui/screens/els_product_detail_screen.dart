import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/views/add_holding_product_modal.dart';
import 'package:elswhere/ui/views/els_product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../data/models/dtos/response_single_product_dto.dart';

class ELSProductDetailScreen extends StatefulWidget {
  const ELSProductDetailScreen({super.key});

  @override
  State<ELSProductDetailScreen> createState() => _ELSProductDetailScreenState();
}

class _ELSProductDetailScreenState extends State<ELSProductDetailScreen> {
  late UserInfoProvider userProvider;
  late ELSProductProvider productProvider;
  bool isLiked = false;
  bool isBookmarked = false;
  bool isHeld = false;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
  }

  void changeLiked() async {
    ResponseSingleProductDto? product = productProvider.product;
    isLiked = productProvider.isLiked;
    bool result;
    if (isLiked == false) {
      result = await productProvider.postProductLike(product!.id);
    } else {
      result = await productProvider.deleteProductLike(product!.id);
    }

    setState(() {
      isLiked = productProvider.isLiked;
    });
    if (result) {
      Fluttertoast.showToast(msg: isLiked ? '좋아요를 추가했습니다.' : '좋아요를 취소했습니다.', toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: '좋아요에 실패했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
    }
  }

  // void changeBookmarked() => setState(() => isBookmarked = !isBookmarked);
  void changeBookmarked() async {
    ResponseSingleProductDto? product = productProvider.product;
    bool isBookmarked = productProvider.isBookmarked;
    bool result;
    if (isBookmarked == false) {
      result = await productProvider.registerInterested(product!.id);
    } else {
      result = await productProvider.deleteFromInterested();
    }

    setState(() {
      isBookmarked = productProvider.isBookmarked;
    });
    if (result) {
      Fluttertoast.showToast(msg: isBookmarked ? '관심 상품에 등록했습니다.' : '관심 상품에서 제거했습니다.', toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: '관심 설정에 실패했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _checkIsHeld() {
    List<SummarizedUserHoldingDto> holdingProducts = userProvider.holdingProducts ?? [];
    productProvider.checkisHeld(holdingProducts);
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddHoldingProductModal(),
    );
  }

  void _changeHeld() {
    final isHeld = productProvider.isHeld;
    if (!isHeld) {
      _showModalBottomSheet();
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => _buildcheckDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, productProvider, child) {
        isLiked = productProvider.isLiked;
        isBookmarked = productProvider.isBookmarked;
        isHeld = productProvider.isHeld;

        return Scaffold(
          backgroundColor: AppColors.backgroundGray,
          appBar: _buildAppBar(),
          body: const ELSProductDetailView(),
        );
      },
    );
  }

  Dialog _buildcheckDialog() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 140,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '투자 정보를 삭제하시겠어요?',
                style: textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: ShapeDecoration(
                          color: AppColors.gray100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '취소',
                            style: textTheme.headlineSmall!.copyWith(
                              color: AppColors.titleGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        final result = await userProvider.deleteHoldingProduct(productProvider.holdingId!);

                        if (mounted) Navigator.pop(context);

                        if (result) {
                          Fluttertoast.showToast(msg: '상품이 삭제되었습니다.', toastLength: Toast.LENGTH_SHORT);
                          final holdingProducts = userProvider.holdingProducts ?? [];
                          productProvider.checkisHeld(holdingProducts);
                        } else {
                          Fluttertoast.showToast(msg: '문제가 발생했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: ShapeDecoration(
                          color: AppColors.contentRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: textTheme.headlineSmall!.copyWith(
                              color: AppColors.contentWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
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
                child: isLiked ? const Icon(Icons.favorite, color: AppColors.contentRed) : const Icon(Icons.favorite_border_outlined),
              ),
              onPressed: changeLiked,
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundColor: AppColors.contentWhite,
                child: isBookmarked ? const Icon(Icons.bookmark, color: AppColors.contentYellow) : const Icon(Icons.bookmark_border_outlined),
              ),
              onPressed: changeBookmarked,
            ),
            IconButton(
              onPressed: _changeHeld,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                switchInCurve: Curves.fastLinearToSlowEaseIn,
                switchOutCurve: Curves.fastLinearToSlowEaseIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: child.key == const ValueKey('add') ? Tween<double>(begin: 1, end: 0.75).animate(animation) : Tween<double>(begin: 0.75, end: 1).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: CircleAvatar(
                  key: ValueKey(isHeld ? 'check' : 'add'),
                  backgroundColor: isHeld ? AppColors.mainBlue : Colors.white,
                  child: Icon(
                    isHeld ? Icons.check : Icons.add,
                    color: isHeld ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
