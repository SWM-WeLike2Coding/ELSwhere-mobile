import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/analysis/ai_product_provider.dart';
import 'package:elswhere/data/providers/waiting_provider.dart';
import 'package:elswhere/ui/screens/other/waiting_screen.dart';
import 'package:elswhere/ui/views/home/ai_recommendation_products_list_view.dart';
import 'package:elswhere/ui/widgets/custom_appbar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AIRecommendationProductScreen extends StatefulWidget {
  const AIRecommendationProductScreen({super.key});

  @override
  State<AIRecommendationProductScreen> createState() => _AIRecommendationProductScreenState();
}

class _AIRecommendationProductScreenState extends State<AIRecommendationProductScreen> {
  bool _isInit = true;
  late AIProductProvider _aiProductProvider;
  late WaitingProvider _waitingProvider;
  late OverlayPortalController _overlayPortalController;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    _aiProductProvider = Provider.of<AIProductProvider>(context, listen: false);
    _waitingProvider = Provider.of<WaitingProvider>(context, listen: false);
    _overlayPortalController = OverlayPortalController();
    _setCurrentScreen();
    super.initState();
  }

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: 'AI 상품 추천 화면',
      screenClass: 'AIRecommendationProductScreen',
    );
  }

  Future<void> init() async {
    await _aiProductProvider.fetchAIRecommendationProducts();
    _waitingProvider.setComment(MSG_LOADING_COMPLETE);
    _waitingProvider.setLoadingValue(1);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _isInit = false);
    _waitingProvider.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isInit ? init() : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const WaitingScreen(initialComment: MSG_LOADING_AI_PRODUCTS);
        } else {
          return Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(),
          );
        }
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTop(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16).copyWith(bottom: 12),
                child: Row(
                  children: [
                    Text('AI 추천 상품', style: textTheme.M_18),
                    const SizedBox(width: 8),
                    _buildOverlayPortal(),
                  ],
                ),
              ),
              const Divider(color: AppColors.gray100),
              const Expanded(child: AIRecommendationProductsListView()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return Container(
      padding: edgeInsetsAll24,
      color: AppColors.mainBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ELSwhere가 추천하는', style: textTheme.SM_16.copyWith(color: AppColors.gray100)),
              Text('상품들을 확인해보세요', style: textTheme.SM_18.copyWith(color: Colors.white)),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: SvgPicture.asset(
              'assets/icons/icon/icon_girl_with_coin.svg',
              height: 70,
              width: 70,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOverlayPortal() {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (context) {
        return Positioned(
          top: 30,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: edgeInsetsAll24,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.gray200),
                  borderRadius: borderRadiusCircular8,
                ),
                child: Padding(
                  padding: edgeInsetsAll16,
                  child: Builder(
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _overlayPortalController.hide,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Icon(Icons.close),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(MSG_DESCRIPTION_AI_RECOMMENDATION, style: textTheme.M_16),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        width: 20,
        height: 20,
        child: GestureDetector(
          onTap: _overlayPortalController.toggle,
          child: CircleAvatar(
            backgroundColor: AppColors.gray100,
            child: Text(
              '?',
              style: textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
