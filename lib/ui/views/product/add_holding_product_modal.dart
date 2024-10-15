import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/user/request_create_holding_dto.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/widgets/price_text_field.dart';
import 'package:elswhere/ui/widgets/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddHoldingProductModal extends StatefulWidget {
  double? initValue;
  bool isUpdate = false;
  int holdingId = -1;

  AddHoldingProductModal({super.key, this.initValue, this.isUpdate = false, this.holdingId = -1});

  @override
  State<AddHoldingProductModal> createState() => _AddHoldingProductModalState();
}

class _AddHoldingProductModalState extends State<AddHoldingProductModal> {
  late ELSProductProvider productProvider;
  late UserInfoProvider userProvider;
  final TextEditingController _textEditingController = TextEditingController();
  bool disabled = true;
  bool isUpdate = false;
  int holdingId = -1;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    isUpdate = widget.isUpdate;
    holdingId = widget.holdingId;
    _textEditingController.text = widget.initValue?.toInt().toString() ?? '';
    disabled = _textEditingController.text.isEmpty || _textEditingController.text == '0';
  }

  void onTapOutside(FocusNode focusNode) {
    focusNode.unfocus();
  }

  void onChanged() {
    setState(() {
      disabled = _textEditingController.text.isEmpty || _textEditingController.text == '0';
    });
  }

  void onTapSaveButton() async {
    bool result;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (isUpdate) {
      result = await userProvider.updateHoldindProduct(
        holdingId,
        double.parse(_textEditingController.text.replaceAll(RegExp(r'[^0-9]'), '')).toInt(),
      );
    } else {
      result = await userProvider.addHoldingProduct(RequestCreateHoldingDto(
        productId: productProvider.product!.id,
        price: double.parse(_textEditingController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      ));
    }

    if (mounted) Navigator.pop(context);

    if (result) {
      // Fluttertoast.showToast(msg: '저장되었습니다.', toastLength: Toast.LENGTH_SHORT);
      final holdingProducts = userProvider.holdingProducts ?? [];
      productProvider.checkisHeld(holdingProducts);
      if (mounted) {
        Navigator.pop(context);
        showSuccessDialog(context);
      }
    } else {
      Fluttertoast.showToast(msg: '저장에 실패했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
    }
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
              _buildTextField(),
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
            Text('상품 추가', style: textTheme.headlineMedium),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                color: AppColors.gray300,
              ),
            ),
          ],
        ));
  }

  Widget _buildModalBody() {
    final productName = productProvider.product!.name;

    return LayoutBuilder(builder: (context, constraints) {
      final Widget textWidget = _checkTextOverflow(productName, constraints.maxWidth - 48);
      return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget,
              const SizedBox(
                height: 4,
              ),
              Text(
                '얼마나 투자하셨나요?',
                style: textTheme.labelMedium!.copyWith(
                  color: AppColors.gray600,
                ),
              )
            ],
          ));
    });
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: PriceTextField(focusNode: focusNode, controller: _textEditingController, onChanged: onChanged),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: disabled ? () => Fluttertoast.showToast(msg: '올바른 금액을 입력해주세요.', toastLength: Toast.LENGTH_SHORT) : null,
            child: ElevatedButton(
              onPressed: disabled ? null : onTapSaveButton,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.mainBlue,
                disabledBackgroundColor: AppColors.gray100,
                padding: edgeInsetsAll16,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                '저장',
                style: textTheme.labelSmall!.copyWith(
                  color: disabled ? AppColors.gray300 : AppColors.contentWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
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
          isOverflowing ? displayedText : productProvider.product!.name,
          style: textTheme.labelMedium!.copyWith(
            color: AppColors.mainBlue,
          ),
        ),
        Text(
          ' 상품에',
          style: textTheme.labelMedium!.copyWith(
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }
}
