import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PriceTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function() onChanged;

  const PriceTextField({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
  });

  @override
  _PriceTextFieldState createState() => _PriceTextFieldState();
}

class _PriceTextFieldState extends State<PriceTextField> {
  late final TextEditingController _controller;
  final NumberFormat _numberFormat = NumberFormat('#,###');
  late final FocusNode _focusNode;
  bool _isZeroValue = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_formatInput);
    print(_controller.text);
    _focusNode = widget.focusNode;
  }

  @override
  void dispose() {
    _controller.removeListener(_formatInput);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _formatInput() {
    setState(() {
      final text = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
      widget.onChanged();
      if (text.isEmpty) {
        _controller.clear();
        _isZeroValue = false;
        return;
      }

      final number = int.parse(text);
      final formatted = '${_numberFormat.format(number)}원';

      // 커서 위치를 유지하면서 텍스트 포맷팅
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
          offset: formatted.length - 1, // 마지막 문자(원) 앞에 커서 위치
        ),
      );

      _isZeroValue = number == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: 10,
      maxLines: 1,
      cursorColor: AppColors.mainBlue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 11,
        ),
        hintText: '금액 입력',
        hintStyle: textTheme.labelSmall!.copyWith(
          fontSize: 14,
          color: AppColors.textGray,
        ),
        counterText: '',
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.cancel, color: Color(0xFFACB2B5)),
                onPressed: () => _controller.clear(),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
            color: _isZeroValue ? Colors.red : const Color(0xFFE6E7E8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 1, color: _isZeroValue ? Colors.red : AppColors.mainBlue),
        ),
      ),
    );
  }
}
