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
          return Consumer<UserInfoProvider> (
            builder: (context, userInfoProvider, child) {
                return ListView.builder(
                  itemCount: userInfoProvider.personalizedProducts.length,
                  itemBuilder: (context, index) {
                    return ELSProductCard(
                      key: ValueKey(userInfoProvider.personalizedProducts[index].id),
                      product: userInfoProvider.personalizedProducts[index],
                      index: index,
                    );
                  },
                );
            },
          );
        },
      ),
    );
  }
}
