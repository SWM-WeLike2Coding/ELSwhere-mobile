import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/widgets/els_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalizedProductsListView extends StatelessWidget {
  final String type;
  late UserInfoProvider userInfoProvider;

  PersonalizedProductsListView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return Expanded(
      child: FutureBuilder(
        future: userInfoProvider.isInit ? userInfoProvider.fetchPersonalizedProducts(type) : null,
        builder: (context, snapshot) {
          return Consumer<UserInfoProvider>(
            builder: (context, userInfoProvider, child) {
              if (userInfoProvider.personalizedProducts.isEmpty) {
                return Center(
                  child: Text(
                    '아직 ${userInfoProvider.userInfo!.nickname}님에게\n 맞는 추천 상품이 없습니다.',
                    style: textTheme.M_16.copyWith(color: AppColors.gray800),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: userInfoProvider.personalizedProducts.length,
                  itemBuilder: (context, index) {
                    return ELSProductCard(
                      key: ValueKey(userInfoProvider.personalizedProducts[index].id),
                      product: userInfoProvider.personalizedProducts[index],
                      index: index,
                      showAIResult: true,
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
