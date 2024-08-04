import 'package:flutter/material.dart';

import '../../config/app_resource.dart';

class InvestmentPropensityScreen extends StatefulWidget {
  const InvestmentPropensityScreen({super.key});

  @override
  State<InvestmentPropensityScreen> createState() => _InvestmentPropensityScreenState();
}

class _InvestmentPropensityScreenState extends State<InvestmentPropensityScreen> {
  int doesUserHaveExperience = -1;     // 1이 경험 있음, 0은 없음
  int preferredInvestmentType = -1;    // 0: 1년미만, 1: 1~2년, 2: 3년이상
  int riskTakingType = -1;             // 0이 위험 감수형, 1은 안전추구형

  bool _isAgreeBtnChecked = false;

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
      } else if (text == "1~2년"){
        if (preferredInvestmentType == 1) {
          preferredInvestmentType = -1;
        } else {
          preferredInvestmentType = 1;
        }
      } else if (text == "3년 이상"){
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: AppColors.backgroundGray,
                    width: 1,
                  )
              )
          ),
          child: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
              child: Align(
                alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            title: Text(
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
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildInvestmentExperienceForm(),
                  SizedBox(height: 24,),
                  _buildPreferredInvestmentPeriod(),
                  SizedBox(height: 24,),
                  _buildRiskTakingAbilityForm(),
                ],
              ),
            ),
          ),
          _buildAgreementCheckbox(),
          SizedBox(height: 8,),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildCustomButton(String text, int integerFlag, int buttonType) {
    bool _isPressed = false;
    if (buttonType == 1) {
      if ((text == "있음" && integerFlag == 1) || (text == "없음" && integerFlag == 0)) {
        _isPressed = true;
      }
    } else if (buttonType == 2) {
      if ((text == "1년 미만" && integerFlag == 0) || (text == "1~2년" && integerFlag == 1) || (text == "3년 이상" && integerFlag == 2)) {
        _isPressed = true;
      }
    } else if (buttonType == 3) {
      if ((text == "위험감수형" && integerFlag == 0) || (text == "안전추구형" && integerFlag == 1)) {
        _isPressed = true;
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
            color: _isPressed
                ? Color(0xFF1C6BF9)
                : Color(0xFFF5F6F6),
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
                color: _isPressed
                    ? Color(0xFFFFFFFF)
                    : Color(0xFFACB2B5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvestmentExperienceForm() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "1. ELS 상품 투자 경험"
          ),
          SizedBox(height: 12,),
          Row(
            children: [
              _buildCustomButton("있음", doesUserHaveExperience, 1),
              SizedBox(width: 12,),
              _buildCustomButton("없음", doesUserHaveExperience, 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferredInvestmentPeriod() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "2. 선호 투자 기간"
          ),
          SizedBox(height: 12,),
          Row(
            children: [
              _buildCustomButton("1년 미만", preferredInvestmentType, 2),
              SizedBox(width: 8,),
              _buildCustomButton("1~2년", preferredInvestmentType, 2),
              SizedBox(width: 8,),
              _buildCustomButton("3년 이상", preferredInvestmentType, 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskTakingAbilityForm() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "3. 투자자 위험 감수 능력"
          ),
          SizedBox(height: 12,),
          Row(
            children: [
              _buildCustomButton("위험감수형", riskTakingType, 3),
              SizedBox(width: 12,),
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
          checkColor: Color(0xFFFFFFFF),
          activeColor: Color(0xFF1C6BF9),
        ),
        GestureDetector(
          onTap: _toggleCheckbox,
          child: Text(
              "투자자 정보 제공에 동의합니다."
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      height: 100,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Opacity(
                  opacity: _isAgreeBtnChecked ? 1.0 : 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE6E7E8),
                        disabledBackgroundColor: Color(0xFFE6E7E8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )
                    ),
                    onPressed: _isAgreeBtnChecked? () {
                      Navigator.pop(context);
                    } : null,
                    child: Text(
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
            SizedBox(width: 4,),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Opacity(
                  opacity: _isAgreeBtnChecked ? 1.0 : 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1C6BF9),
                        disabledBackgroundColor: Color(0xFF1C6BF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )
                    ),
                    onPressed: () {

                    },
                    child: Text(
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

