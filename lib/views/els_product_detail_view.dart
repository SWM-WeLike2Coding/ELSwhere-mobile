import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/els_product_provider.dart';
import '../resources/app_resource.dart';

class ELSProductDetailView extends StatelessWidget {
  final BoxConstraints constraints;

  const ELSProductDetailView({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading &&
            productProvider.product == null) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (productProvider.product == null) {
          return const Center(child: Text('상품이 존재하지 않습니다.'));
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('발행 회사'),
                      _buildCompanyCard(context, issuer: productProvider.product!.issuer),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('상품명'),
                    _buildCompanyCard(context),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('기초 자산'),
                      _buildCompanyCard(context),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('상품 유형'),
                    _buildCompanyCard(context),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('연 수익률'),
                      _buildCompanyCard(context),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('청약 마감 D-Day'),
                    _buildCompanyCard(context),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('청약 시작/마감일'),
                      _buildCompanyCard(context),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('발행/만기일'),
                    _buildCompanyCard(context),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }
    );
  }

  Widget _buildCompanyCard(BuildContext context, {String issuer = 'Hello'}) {
    final height = constraints.maxHeight;
    final width = constraints.maxWidth;

    final cardHeight = height / 6;
    final cardWidth = width / 2 - 30;
    return SizedBox(
      height: cardHeight,
      width: cardWidth,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular10),
        color: AppColors.blues2,
        child: Container(
          padding: edgeInsetsAll16,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Text(
                  issuer,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.contentWhite,
                  ),
                ),
              ),
              Positioned(
                bottom: cardHeight,
                right: cardWidth,
                child: Text(
                  'alksdjfklasjfl',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.contentWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}