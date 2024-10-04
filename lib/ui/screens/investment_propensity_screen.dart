import 'package:elswhere/data/models/dtos/response_investment_type_dto.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../config/app_resource.dart';

class InvestmentPropensityScreen extends StatefulWidget {
  const InvestmentPropensityScreen({super.key});

  @override
  State<InvestmentPropensityScreen> createState() => _InvestmentPropensityScreenState();
}

class _InvestmentPropensityScreenState extends State<InvestmentPropensityScreen> {
  int doesUserHaveExperience = -1; // 1이 경험 있음, 0은 없음
  int preferredInvestmentType = -1; // 0: 1년미만, 1: 1~2년, 2: 3년이상
  int riskTakingType = -1; // 0이 위험 감수형, 1은 안전추구형

  bool _isAgreeBtnChecked = false;

  bool _isAllConditionSatisfied() {
    if (_isAgreeBtnChecked && doesUserHaveExperience != -1 && riskTakingType != -1 && preferredInvestmentType != -1) {
      return true;
    } else {
      return false;
    }
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

  void _handleInvestmentTypeButtonPress(String text) {
    setState(() {
      if (text == "1년 미만") {
        if (preferredInvestmentType == 0) {
          preferredInvestmentType = -1;
        } else {
          preferredInvestmentType = 0;
        }
      } else if (text == "1~2년") {
        if (preferredInvestmentType == 1) {
          preferredInvestmentType = -1;
        } else {
          preferredInvestmentType = 1;
        }
      } else if (text == "3년 이상") {
        if (preferredInvestmentType == 2) {
          preferredInvestmentType = -1;
        } else {
          preferredInvestmentType = 2;
        }
      }
    });
  }

  void _handleRiskTakingAbilityButtonPress(String text) {
    setState(() {
      if (text == "위험감수형") {
        if (riskTakingType == 0) {
          riskTakingType = -1;
        } else {
          riskTakingType = 0;
        }
      } else {
        if (riskTakingType == 1) {
          riskTakingType = -1;
        } else {
          riskTakingType = 1;
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
    ResponseInvestmentTypeDto? interestingProducts = Provider.of<UserInfoProvider>(context, listen: false).investmentTypeInfo;

    if (interestingProducts != null) {
      if (interestingProducts.riskTakingAbility == 'RISK_TAKING_TYPE') {
        riskTakingType = 0;
      } else if (interestingProducts.riskTakingAbility == 'STABILITY_SEEKING_TYPE') {
        riskTakingType = 1;
      }

      if (interestingProducts.investmentPreferredPeriod == 'LESS_THAN_A_YEAR') {
        preferredInvestmentType = 0;
      } else if (interestingProducts.investmentPreferredPeriod == 'A_YEAR_OR_TWO') {
        preferredInvestmentType = 1;
      } else if (interestingProducts.investmentPreferredPeriod == 'MORE_THAN_THREE_YEARS') {
        preferredInvestmentType = 2;
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
      appBar: PreferredSize(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildInvestmentExperienceForm(),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildPreferredInvestmentPeriod(),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildRiskTakingAbilityForm(),
                ],
              ),
            ),
          ),
          _buildAgreementCheckbox(),
          const SizedBox(
            height: 8,
          ),
          _buildBottomButton(),
        ],
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
      if ((text == "1년 미만" && integerFlag == 0) || (text == "1~2년" && integerFlag == 1) || (text == "3년 이상" && integerFlag == 2)) {
        isPressed = true;
      }
    } else if (buttonType == 3) {
      if ((text == "위험감수형" && integerFlag == 0) || (text == "안전추구형" && integerFlag == 1)) {
        isPressed = true;
      }
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (buttonType == 1) {
            _handleExperienceButtonPress(text);
          } else if (buttonType == 2) {
            _handleInvestmentTypeButtonPress(text);
          } else if (buttonType == 3) {
            _handleRiskTakingAbilityButtonPress(text);
          }
        },
        child: Container(
          // width: double.infinity,
          height: 33,
          decoration: BoxDecoration(
            color: isPressed ? const Color(0xFF1C6BF9) : AppColors.gray50,
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
                color: isPressed ? const Color(0xFFFFFFFF) : const Color(0xFFACB2B5),
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
        ],
      ),
    );
  }

  Widget _buildPreferredInvestmentPeriod() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("2. 선호 투자 기간"),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              _buildCustomButton("1년 미만", preferredInvestmentType, 2),
              const SizedBox(
                width: 8,
              ),
              _buildCustomButton("1~2년", preferredInvestmentType, 2),
              const SizedBox(
                width: 8,
              ),
              _buildCustomButton("3년 이상", preferredInvestmentType, 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskTakingAbilityForm() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("3. 투자자 위험 감수 능력"),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              _buildCustomButton("위험감수형", riskTakingType, 3),
              const SizedBox(
                width: 12,
              ),
              _buildCustomButton("안전추구형", riskTakingType, 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _isAgreeBtnChecked,
          onChanged: (bool? value) {
            setState(() {
              _isAgreeBtnChecked = value ?? false;
            });
          },
          checkColor: const Color(0xFFFFFFFF),
          activeColor: const Color(0xFF1C6BF9),
        ),
        GestureDetector(
          onTap: _toggleCheckbox,
          child: const Text("투자자 정보 제공에 동의합니다."),
        ),
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
                        color: Color(0xFF4C4F53),
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
                        backgroundColor: const Color(0xFF1C6BF9),
                        disabledBackgroundColor: const Color(0xFF1C6BF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: _isAllConditionSatisfied()
                        ? () async {
                            if (await userInfoProvider.changeInvestmentType(doesUserHaveExperience, preferredInvestmentType, riskTakingType)) {
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
                        color: Color(0xFFFFFFFF),
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
