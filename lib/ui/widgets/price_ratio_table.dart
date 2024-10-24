import 'package:auto_size_text/auto_size_text.dart';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/models/dtos/analysis/price_ratio_response.dart';
import 'package:elswhere/data/providers/els_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceRatioTable extends StatefulWidget {
  const PriceRatioTable({super.key});

  @override
  State<PriceRatioTable> createState() => _PriceRatioTableState();
}

class _PriceRatioTableState extends State<PriceRatioTable> {
  late ELSProductProvider productProvider;
  late PriceRatioResponse? ratioResponse;
  late List<String> indices;
  late int length;
  // final BorderSide side = BorderSide(color: AppColors.);

  @override
  void initState() {
    productProvider = Provider.of<ELSProductProvider>(context, listen: false);
    ratioResponse = productProvider.priceRatioResponse;
    length = ratioResponse?.initial.length ?? 0;
    indices = ratioResponse?.initial.keys.toList() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (length > 0) {}
    return length > 0
        ? Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1),
            },
            // border: TableBorder.all(color: AppColors.gray100, borderRadius: BorderRadius.circular(8)),
            // border: TableBorder(borderRadius: BorderRadius.circular(8)),
            // border: TableBorder.all(color: Colors.white),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              const TableRow(
                decoration: ShapeDecoration(shape: Border(bottom: BorderSide(color: AppColors.gray700, width: 1.5))),
                // BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.gray800, width: 2)), borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                children: [
                  TableCell(child: Padding(padding: edgeInsetsAll8, child: Text('기초자산', style: TextStyle(color: AppColors.gray700) /*, textAlign: TextAlign.center*/))),
                  TableCell(child: Padding(padding: edgeInsetsAll8, child: Text('기준가격', style: TextStyle(color: AppColors.gray700) /*, textAlign: TextAlign.center*/))),
                  TableCell(child: Padding(padding: edgeInsetsAll8, child: Text('현재가격', style: TextStyle(color: AppColors.gray700) /*, textAlign: TextAlign.center*/))),
                  TableCell(child: Padding(padding: edgeInsetsAll8, child: Text('변동율', style: TextStyle(color: AppColors.gray700) /*, textAlign: TextAlign.center*/))),
                ],
              ),
              ...indices.map(
                (index) {
                  final initial = ratioResponse!.initial;
                  final recent = ratioResponse!.recent;
                  final ratio = ratioResponse!.ratio;
                  return TableRow(
                    // decoration: const ShapeDecoration(shape: Border(bottom: BorderSide(color: AppColors.gray500))),
                    children: [
                      TableCell(child: Padding(padding: edgeInsetsAll8, child: AutoSizeText(index, maxLines: 1, overflow: TextOverflow.ellipsis /*, textAlign: TextAlign.center*/))),
                      TableCell(child: Padding(padding: edgeInsetsAll8, child: AutoSizeText(initial[index]!.toStringAsFixed(2), maxLines: 1 /*, textAlign: TextAlign.center*/))),
                      TableCell(child: Padding(padding: edgeInsetsAll8, child: AutoSizeText(recent[index]!.toStringAsFixed(2), maxLines: 1 /*, textAlign: TextAlign.center*/))),
                      TableCell(child: Padding(padding: edgeInsetsAll8, child: _buildPriceRatioText(ratio[index]!))),
                    ],
                  );
                },
              )
            ],
          )
        : Center(child: Text(MSG_NO_PRICERATIO, style: textTheme.R_16));
  }

  Widget _buildPriceRatioText(double ratio) {
    double now = ratio - 100;
    Color color = switch (now) {
      > 0 => AppColors.contentRed,
      < 0 => AppColors.mainBlue,
      == 0.0 => AppColors.contentBlack,
      double() => throw UnimplementedError(),
    };
    return AutoSizeText(
      '${now > 0 ? '+' : ''}${now.toStringAsFixed(2)}%',
      style: TextStyle(color: color),
      textAlign: TextAlign.center,
      maxLines: 1,
      minFontSize: 10,
    );
  }
}
