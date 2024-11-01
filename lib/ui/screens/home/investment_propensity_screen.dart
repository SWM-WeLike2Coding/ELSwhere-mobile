import 'package:elswhere/data/models/dtos/user/response_investment_type_dto.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../config/app_resource.dart';

class InvestmentPropensityScreen extends StatefulWidget {
  const InvestmentPropensityScreen({super.key});

  @override
  State<InvestmentPropensityScreen> createState() => _InvestmentPropensityScreenState();
}

class _InvestmentPropensityScreenState extends State<InvestmentPropensityScreen> {
  final TextEditingController _controller = TextEditingController();

  int doesUserHaveExperience = -1; // 1이 경험 있음, 0은 없음
  int ristAppetiteType = -1; // 0: 초고위험, 1: 고위험, 2: 중위험, 3: 저위험
  int preferredRedemptionPeriodType = -1; // 0이 위험 감수형, 1은 안전추구형

  bool _isAgreeBtnChecked = false;

  bool _isAllConditionSatisfied() {
    if (_isAgreeBtnChecked && doesUserHaveExperience != -1 && preferredRedemptionPeriodType != -1 && ristAppetiteType != -1) {
      return true;
    } else {
      return false;
    }
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '투자 성향 설문 화면',
      screenClass: 'InvestmentPropensityScreen',
    );
  }

  void _handleExperienceButtonPress(String text) {
    setState(() {
      if (text == "있음") {
        if (doesUserHaveExperience == 1) {
          doesUserHaveExperience = -1;
        } else {
          doesUserHaveExperience = 1;
        }
      } else {
        if (doesUserHaveExperience == 0) {
          doesUserHaveExperience = -1;
        } else {
          doesUserHaveExperience = 0;
        }
      }
    });
  }

  void _handleRiskAppetiteButtonPress(String text) {
    setState(() {
      if (text == "초고위험") {
        if (ristAppetiteType == 0) {
          ristAppetiteType = -1;
        } else {
          ristAppetiteType = 0;
        }
      } else if (text == "고위험") {
        if (ristAppetiteType == 1) {
          ristAppetiteType = -1;
        } else {
          ristAppetiteType = 1;
        }
      } else if (text == "중위험") {
        if (ristAppetiteType == 2) {
          ristAppetiteType = -1;
        } else {
          ristAppetiteType = 2;
        }
      } else if (text == "저위험") {
        if (ristAppetiteType == 3) {
          ristAppetiteType = -1;
        } else {
          ristAppetiteType = 3;
        }
      }
    });
  }

  void _handlePreferredRedemptionPeriodButtonPress(String text) {
    setState(() {
      if (text == "조기상환") {
        if (preferredRedemptionPeriodType == 0) {
          preferredRedemptionPeriodType = -1;
        } else {
          preferredRedemptionPeriodType = 0;
        }
      } else if (text == "만기상환") {
        if (preferredRedemptionPeriodType == 1) {
          preferredRedemptionPeriodType = -1;
        } else {
          preferredRedemptionPeriodType = 1;
        }
      } else {
        if (preferredRedemptionPeriodType == 2) {
          preferredRedemptionPeriodType = -1;
        } else {
          preferredRedemptionPeriodType = 2;
        }
      }
    });
  }

  void _toggleCheckbox() {
    setState(() {
      _isAgreeBtnChecked = !_isAgreeBtnChecked;
    });
  }

  @override
  void initState() {
    super.initState();
    _setCurrentScreen();
    ResponseInvestmentTypeDto? interestingProducts = Provider.of<UserInfoProvider>(context, listen: false).investmentTypeInfo;

    if (interestingProducts != null) {
      if (interestingProducts.riskTakingAbility == 'RISK_TAKING_TYPE') {
        preferredRedemptionPeriodType = 0;
      } else if (interestingProducts.riskTakingAbility == 'STABILITY_SEEKING_TYPE') {
        preferredRedemptionPeriodType = 1;
      }

      if (interestingProducts.investmentPreferredPeriod == 'LESS_THAN_A_YEAR') {
        ristAppetiteType = 0;
      } else if (interestingProducts.investmentPreferredPeriod == 'A_YEAR_OR_TWO') {
        ristAppetiteType = 1;
      } else if (interestingProducts.investmentPreferredPeriod == 'MORE_THAN_THREE_YEARS') {
        ristAppetiteType = 2;
      }

      if (interestingProducts.investmentExperience == 'YES') {
        doesUserHaveExperience = 1;
      } else if (interestingProducts.investmentExperience == 'NO') {
        doesUserHaveExperience = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildInvestmentExperienceForm(),
                  _buildRiskAppetiteForm(),
                  _buildPreferredRedemptionPeriodForm(),
                  _buildPreferredMinimumCouponForm(),
                ],
              ),
            ),
          ),
          _buildAgreementCheckbox(),
          _buildBottomButton(),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: AppColors.gray50,
                  width: 1,
                ))),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
            child: Align(
              alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: const Text(
            "투자성향",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
        ),
      ),
    );
  }

  Widget _buildCustomButton(String text, int integerFlag, int buttonType) {
    bool isPressed = false;
    if (buttonType == 1) {
      if ((text == "있음" && integerFlag == 1) || (text == "없음" && integerFlag == 0)) {
        isPressed = true;
      }
    } else if (buttonType == 2) {
      if ((text == "초고위험" && integerFlag == 0) || (text == "고위험" && integerFlag == 1) || (text == "중위험" && integerFlag == 2) || (text == "저위험" && integerFlag == 3)) {
        isPressed = true;
      }
    } else if (buttonType == 3) {
      if ((text == "조기상환" && integerFlag == 0) || (text == "만기상환" && integerFlag == 1) || (text == "상관없음" && integerFlag == 2)) {
        isPressed = true;
      }
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (buttonType == 1) {
            _handleExperienceButtonPress(text);
          } else if (buttonType == 2) {
            _handleRiskAppetiteButtonPress(text);
          } else if (buttonType == 3) {
            _handlePreferredRedemptionPeriodButtonPress(text);
          }
        },
        child: Container(
          // width: double.infinity,
          height: 33,
          decoration: BoxDecoration(
            color: isPressed ? AppColors.mainBlue : AppColors.gray50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.18,
                letterSpacing: -0.28,
                color: isPressed ? Colors.white : AppColors.gray300,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvestmentExperienceForm() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("1. ELS 상품 투자 경험"),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              _buildCustomButton("있음", doesUserHaveExperience, 1),
              const SizedBox(
                width: 12,
              ),
              _buildCustomButton("없음", doesUserHaveExperience, 1),
            ],
          ),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget _buildRiskAppetiteForm() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("2. 위험 성향"),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              _buildCustomButton("초고위험", ristAppetiteType, 2),
              const SizedBox(
                width: 8,
              ),
              _buildCustomButton("고위험", ristAppetiteType, 2),
              const SizedBox(
                width: 8,
              ),
              _buildCustomButton("중위험", ristAppetiteType, 2),
              const SizedBox(
                width: 8,
              ),
              _buildCustomButton("저위험", ristAppetiteType, 2),
            ],
          ),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget _buildPreferredRedemptionPeriodForm() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("3. 희망 상환 기간"),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              _buildCustomButton("조기상환", preferredRedemptionPeriodType, 3),
              const SizedBox(
                width: 12,
              ),
              _buildCustomButton("만기상환", preferredRedemptionPeriodType, 3),
              const SizedBox(
                width: 12,
              ),
              _buildCustomButton("상관없음", preferredRedemptionPeriodType, 3),
            ],
          ),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget _buildPreferredMinimumCouponForm() {
    const String removeIcon = "assets/icons/icon/icon_remove_all.svg";

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("4. 선호 최소 수익률"),
          const SizedBox(height: 12,),
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.gray100,
                width: 1,
              )
            ),
            child: Row(
              // alignment: Alignment.centerRight,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    showCursor: true,
                    cursorColor: AppColors.mainBlue,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'^([1-9]?[0-9]|100)$')),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      hintText: "0 - 100",
                      hintStyle: TextStyle(color: AppColors.gray400),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        removeIcon,
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _buildAgreementCheckbox() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _isAgreeBtnChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isAgreeBtnChecked = value ?? false;
                });
              },
              checkColor: Colors.white,
              activeColor: AppColors.mainBlue,
            ),
            GestureDetector(
              onTap: _toggleCheckbox,
              child: const Text("투자자 정보 제공에 동의합니다."),
            ),
          ],
        ),
        const SizedBox(height: 8,),
      ],
    );
  }

  Widget _buildBottomButton() {
    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Opacity(
                  opacity: _isAllConditionSatisfied() ? 1.0 : 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray100,
                        disabledBackgroundColor: AppColors.gray100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: _isAgreeBtnChecked
                        ? () {
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray700,
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
              child: SizedBox(
                height: double.infinity,
                child: Opacity(
                  opacity: _isAllConditionSatisfied() ? 1.0 : 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainBlue,
                        disabledBackgroundColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: _isAllConditionSatisfied()
                        ? () async {
                            if (await userInfoProvider.changeInvestmentType(doesUserHaveExperience, ristAppetiteType, preferredRedemptionPeriodType)) {
                              print("투자 타입 정보 저장 성공");
                              Fluttertoast.showToast(msg: "성공적으로 저장되었습니다");
                            } else {
                              print("투자 타입 정보 저장 실패");
                              Fluttertoast.showToast(msg: "투자 성형 정보 저장에 실패했습니다");
                            }
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text(
                      '저장하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
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
