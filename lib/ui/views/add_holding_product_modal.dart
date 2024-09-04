import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/request_create_holding_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/widgets/price_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddHoldingProductModal extends StatefulWidget {
  const AddHoldingProductModal({super.key});

  @override
  State<AddHoldingProductModal> createState() => _AddHoldingProductModalState();
}

class _AddHoldingProductModalState extends State<AddHoldingProductModal> {
  ELSProductProvider? productProvider;
  UserInfoProvider? userProvider;
  final TextEditingController _textEditingController = TextEditingController();
  bool disabled = true;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    disabled = _textEditingController.text.isEmpty || _textEditingController.text == '0';
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  void onTapOutside(FocusNode focusNode) {
    focusNode.unfocus();
  }

  void onChanged() {
    setState(() {
      disabled = _textEditingController.text.isEmpty || _textEditingController.text == '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTapOutside(focusNode),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModalTitle(),
              _buildModalBody(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: PriceTextField(focusNode: focusNode, controller: _textEditingController, onChanged: onChanged),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: disabled
                        ? () => Fluttertoast.showToast(msg: '올바른 금액을 입력해주세요.', toastLength: Toast.LENGTH_SHORT)
                        : null,
                      child: ElevatedButton(
                        onPressed: disabled
                          ? null
                          : () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              final result = await userProvider!.addHoldingProduct(
                                RequestCreateHoldingDto(
                                  productId: productProvider!.product!.id,
                                  price: double.parse(_textEditingController.text.replaceAll(RegExp(r'[^0-9]'), '')),
                                )
                              );

                              Navigator.pop(context);

                              if (result) {
                                Fluttertoast.showToast(msg: '저장되었습니다.', toastLength: Toast.LENGTH_SHORT);
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(msg: '저장에 실패했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
                              }
                            }
                        ,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.mainBlue,
                          disabledBackgroundColor: const Color(0xFFE6E7E8),
                          padding: edgeInsetsAll16,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          '저장',
                          style: textTheme.labelSmall!.copyWith(
                            color: disabled
                              ? const Color(0xFFACB2B5)
                              : AppColors.contentWhite,
                            fontWeight: FontWeight.w600,
                          )
                        )
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              '상품 추가',
              style: textTheme.headlineMedium
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Color(0xFFACB2B5),),
          ),
        ],
      )
    );
  }

  Widget _buildModalBody() {
    final productName = productProvider!.product!.name;

    return LayoutBuilder(
      builder: (context, constraints) {
        final Widget textWidget = _checkTextOverflow(productName, constraints.maxWidth - 48);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget,
              const SizedBox(height: 4,),
              Text(
                '얼마나 투자하셨나요?',
                style: textTheme.labelMedium!.copyWith(
                  color: AppColors.textGray,
                ),
              )
            ],
          )
        );
      }
    );
  }

  Widget _checkTextOverflow(String text, double maxWidth) {
    // 텍스트가 공간을 초과하는지 계산
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '$text 상품에',
        style: textTheme.labelMedium,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    // 오버플로우가 발생하면 '...' 추가
    final isOverflowing = textPainter.didExceedMaxLines;
    String displayedText = '';

    if (textPainter.didExceedMaxLines) {
      int endIndex = text.length;
      while (textPainter.didExceedMaxLines && endIndex > 0) {
        endIndex--;
        displayedText = '${text.substring(0, endIndex)}...';
        textPainter.text = TextSpan(
          text: '$displayedText 상품에',
          style: textTheme.labelMedium,
        );
        textPainter.layout(maxWidth: maxWidth);
      }
    }

    return Row(
      children: [
        Text(
          isOverflowing
            ? displayedText
            : productProvider!.product!.name,
          style: textTheme.labelMedium!.copyWith(
            color: AppColors.mainBlue,
          ),
        ),
        Text(
          ' 상품에',
          style: textTheme.labelMedium!.copyWith(
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }
}
