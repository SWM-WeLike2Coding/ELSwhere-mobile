import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/hot_products_provider.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/attention_products_screen.dart';
import 'package:elswhere/ui/screens/attention_subscription_schedule_screen.dart';
import 'package:elswhere/ui/screens/holding_products_screen.dart';
import 'package:elswhere/ui/screens/hot_products_screen.dart';
import 'package:elswhere/ui/screens/investment_propensity_screen.dart';
import 'package:elswhere/ui/screens/notification_screen.dart';
import 'package:elswhere/ui/widgets/stock_index_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/app_resource.dart';
import '../../data/models/dtos/els_product_for_schedule_dto.dart';
import '../../data/models/dtos/response_interesting_product_dto.dart';
import '../../data/models/dtos/summarized_product_dto.dart';
import '../../data/providers/els_product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ElsProductForScheduleDto convertInterestingProductToProductForSchedule(ResponseInterestingProductDto interestingProduct) {
    return ElsProductForScheduleDto(
      isHolding: false,
      productId: interestingProduct.productId,
      issuer: interestingProduct.issuer,
      name: interestingProduct.name,
      productType: interestingProduct.productType,
      equities: interestingProduct.equities,
      yieldIfConditionsMet: interestingProduct.yieldIfConditionsMet,
      subscriptionStartDate: interestingProduct.subscriptionStartDate,
      subscriptionEndDate: interestingProduct.subscriptionEndDate,
    );
  }

  SummarizedProductDto convertProductForScheduleToSummarized(ElsProductForScheduleDto product) {
    return SummarizedProductDto(
      id: product.productId,
      issuer: product.issuer,
      name: product.name,
      productType: product.productType,
      equities: product.equities,
      yieldIfConditionsMet: product.yieldIfConditionsMet,
      subscriptionStartDate: product.subscriptionStartDate,
      subscriptionEndDate: product.subscriptionEndDate,
    );
  }

  bool isTodayOrFuture(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isAfter(today) || targetDate.isAtSameMomentAs(today);
  }

  final decimalFormat = NumberFormat.decimalPattern('ko');
  late final UserInfoProvider userProvider;

  @override
  void initState() {
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(builder: (context, value, _) {
      return Container(
        color: const Color(0xFFF5F6F6),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F6F6),
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInvestmentTasteTestWidget(context),
                  _buildHoldingProductAssetWidget(context),
                  _buildHotAndAttentionProductWidget(context),
                  _buildAttentionScheduleWidget(context),
                  _buildIndexWidget(),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<ElsProductForScheduleDto> getTodayAndFutureProducts(Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap, int maxItems) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    List<ElsProductForScheduleDto> selectedProducts = [];

    for (var entry in scheduleMap.entries) {
      DateTime date = entry.key;
      if (date.isAfter(today) || date.isAtSameMomentAs(today)) {
        for (var product in entry.value) {
          if (selectedProducts.length < maxItems) {
            selectedProducts.add(product);
          } else {
            break;
          }
        }
        if (selectedProducts.length >= maxItems) {
          break;
        }
      }
    }
    return selectedProducts;
  }

  AppBar _buildAppBar(BuildContext context) {
    const String tempIcon = "assets/icons/icon_elswhere_home.svg";

    return AppBar(
      backgroundColor: const Color(0xFFF5F6F6),
      leading: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          children: [
            SvgPicture.asset(
              tempIcon,
              height: 30,
            ),
          ],
        ),
      ),
      leadingWidth: double.infinity,
      actions: [
        Padding(
          padding: edgeInsetsAll8,
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentTasteTestWidget(BuildContext context) {
    const String profileIcon = "assets/icons/icon_profile.svg";
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InvestmentPropensityScreen(),
              ));
        },
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12), boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
              spreadRadius: 0, // 확산 반경
              blurRadius: 16, // 블러 반경
              offset: Offset(0, 0), // 그림자의 x, y 오프셋
            ),
          ]),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "나에게 딱 맞는 상품 추천",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF838A8E),
                      ),
                    ),
                    Text(
                      "나의 투자 성향을 진단하기",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SvgPicture.asset(
                  profileIcon,
                  height: 36,
                  width: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoldingProductAssetWidget(BuildContext context) {
    final totalHoldingPrice = userProvider.totalHoldingPrice;
    final profitAndLossPrice = userProvider.profitAndLossPrice;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: GestureDetector(
        onTap: () async {
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (BuildContext context) {
          //     return const Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   },
          // );

          // final result = await Provider.of<UserInfoProvider>(context, listen: false).fetchHoldingProducts();

          // Navigator.pop(context);

          // if (result) {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const HoldingProductsScreen(),
          //       ));
          // } else {
          //   Fluttertoast.showToast(msg: '오류가 발생했습니다. 다시 시도해주세요.', toastLength: Toast.LENGTH_SHORT);
          // }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HoldingProductsScreen(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12), boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
              spreadRadius: 0, // 확산 반경
              blurRadius: 16, // 블러 반경
              offset: Offset(0, 0), // 그림자의 x, y 오프셋
            ),
          ]),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      // "보유 상품 가치",
                      "총 투자 금액",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.18, // 118% line-height
                        letterSpacing: -0.28,
                        color: Color(0xFF838A8E),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${decimalFormat.format(totalHoldingPrice)}원',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 1.30, // 118% line-height
                        letterSpacing: -0.44,
                        color: Color(0xFF000000),
                      ),
                    ),
                    // const SizedBox(height: 4,),
                    // Text(
                    //   '${profitAndLossPrice > 0 ? '+' : ''}${decimalFormat.format(profitAndLossPrice)}원',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //     height: 1.18, // 118% line-height
                    //     letterSpacing: -0.28,
                    //     color: profitAndLossPrice == 0
                    //       ? AppColors.gray400
                    //       : profitAndLossPrice > 0
                    //         ? AppColors.contentRed
                    //         : AppColors.mainBlue,
                    //   ),
                    // ),
                  ],
                ),
                const Icon(Icons.keyboard_arrow_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotAndAttentionProductWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      child: Row(
        children: [
          Expanded(child: _buildHotProductButton()),
          const SizedBox(
            width: 8,
          ),
          Expanded(child: _buildAttentionProductButton(context)),
        ],
      ),
    );
  }

  Widget _buildHotProductButton() {
    const String hotIcon = "assets/icons/icon_hot.svg";
    return GestureDetector(
      onTap: _navigateToHotProductsScreen,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
              spreadRadius: 0, // 확산 반경
              blurRadius: 16, // 블러 반경
              offset: Offset(0, 0), // 그림자의 x, y 오프셋
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                hotIcon,
                height: 24,
                width: 17.86,
              ),
              // SizedBox(height: 19,),
              const Text(
                "가장 핫한 상품",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.18,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttentionProductButton(BuildContext context) {
    const String attentionIcon = "assets/icons/icon_attention.svg";
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttentionProductsScreen(),
            ));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
              spreadRadius: 0, // 확산 반경
              blurRadius: 16, // 블러 반경
              offset: Offset(0, 0), // 그림자의 x, y 오프셋
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                attentionIcon,
                height: 32,
                width: 32,
              ),
              // SizedBox(height: 19,),
              const Text(
                "내 관심 상품",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.18,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOneScheduleCard(BuildContext context, ElsProductForScheduleDto? product) {
    int calculateDDay(DateTime? subscriptionEndDate) {
      if (subscriptionEndDate == null) {
        return 0;
      }
      DateTime now = DateTime.now();
      return subscriptionEndDate.difference(now).inDays;
    }

    if (product == null) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF5F6F6),
              ),
              width: 36,
              height: 36,
              child: const Icon(
                Icons.more_horiz,
                size: 20,
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Text(
              "나의 일정 보기",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 16.52 / 14,
                letterSpacing: -0.02,
                color: Color(0xFF000000),
              ),
            )
          ],
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6F6),
                    shape: BoxShape.circle,
                  ),
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: Assets.issuerIconMap[product.issuer] != null ? SvgPicture.asset(Assets.issuerIconMap[product.issuer]!) : const Icon(Icons.question_mark, color: AppColors.contentBlack),
                ),
                const SizedBox(
                  width: 12,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 16.52 / 14,
                          letterSpacing: -0.02,
                          color: Color(0xFF000000),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        product.equities.replaceAll('/', '·'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 14.16 / 12,
                          letterSpacing: -0.02,
                          color: Color(0xFFACB2B5),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0x1AEE5648),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                    child: Text(
                      "D-${calculateDDay(product.subscriptionEndDate)}",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 11.8 / 10,
                        letterSpacing: -0.02,
                        color: Color(0xFFEE5648),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    }
  }

  Widget _buildScheduleCards(BuildContext context, Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap) {
    List<ElsProductForScheduleDto> selectedProducts = getTodayAndFutureProducts(scheduleMap, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: selectedProducts.map((product) {
        return _buildOneScheduleCard(context, product);
      }).toList(),
    );
  }

  Widget _buildAttentionScheduleWidget(BuildContext context) {
    return Consumer<ELSProductProvider>(
      builder: (context, provider, child) {
        var interestingProducts = Provider.of<ELSProductProvider>(context, listen: false).interestingProducts;
        Map<DateTime, List<ElsProductForScheduleDto>> tempScheduleMap = {};

        for (int i = 0; i < interestingProducts.length; i++) {
          if (tempScheduleMap.containsKey(interestingProducts[i].subscriptionEndDate)) {
            tempScheduleMap[interestingProducts[i].subscriptionEndDate]!.add(convertInterestingProductToProductForSchedule(interestingProducts[i]));
          } else {
            tempScheduleMap[interestingProducts[i].subscriptionEndDate] = [convertInterestingProductToProductForSchedule(interestingProducts[i])];
          }
        }

        // 나중에 여기에 보유 상품 관련 정보들도 DTO 변환해서 tempScheduleMap에 넣어줘야함!!!

        List<DateTime> sortedDates = tempScheduleMap.keys.toList()..sort();
        Map<DateTime, List<ElsProductForScheduleDto>> scheduleMap = {for (var key in sortedDates) key: tempScheduleMap[key]!};

        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttentionSubscriptionScheduleScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12), boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
                  spreadRadius: 0, // 확산 반경
                  blurRadius: 16, // 블러 반경
                  offset: Offset(0, 0), // 그림자의 x, y 오프셋
                ),
              ]),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "관심 청약 일정",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.18,
                        letterSpacing: -0.32,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "곧 다가오는 청약 상품 일정이에요.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.18,
                        letterSpacing: -0.24,
                        color: Color(0xFF838A8E),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildScheduleCards(context, scheduleMap),
                    _buildOneScheduleCard(context, null),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndexWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12), boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04), // 그림자 색상
            spreadRadius: 0, // 확산 반경
            blurRadius: 16, // 블러 반경
            offset: Offset(0, 0), // 그림자의 x, y 오프셋
          ),
        ]),
        width: double.infinity,
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "전일 주가 지수",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.18,
                  letterSpacing: -0.32,
                  color: Color(0xFF000000),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              StockIndexList(),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHotProductsScreen() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    bool result = await Provider.of<HotProductsProvider>(context, listen: false).fetchDailyHotProducts();

    Navigator.pop(context);

    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HotProductsScreen()),
      );
    } else {
      Fluttertoast.showToast(msg: MSG_ERR_FETCH, toastLength: Toast.LENGTH_SHORT);
    }
  }
}
