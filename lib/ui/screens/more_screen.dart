// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'dart:ui';

import 'package:elswhere/ui/screens/member_quit_screen.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isNoticeAlarmOn = false;
  bool _isRedemptionAlarmOn = false;
  bool _isDdayAlarmOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                padding: EdgeInsets.only(left: 24.0), // 왼쪽 패딩 추가
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                child: Text(
                  '더보기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF131415),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFE6E7E8),
                      width: 1.0,
                    )
                  ),
                  height: 70,
                  child: Row(
                    children: [
                      SizedBox(width: 16,),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(0xFFD1E0FB),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.ac_unit_rounded,
                          size: 27,
                        ),
                      ),
                      SizedBox(width: 16,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "32일동안 함께한",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF838A8E),
                            ),
                          ),
                          Text(
                            "증권사과장님",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.create_rounded,
                        size: 18,
                        color: Color(0xFFACB2B5),
                      ),
                      SizedBox(width: 25,),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  _buildMiddleListTile(
                    title: "알림",
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Container(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "공지사항 알림",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 38,
                                height: 22,
                                child: Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    value: _isNoticeAlarmOn,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isNoticeAlarmOn = value;
                                      });
                                    },
                                    activeColor: Color(0xFFFFFFFF),
                                    inactiveThumbColor: Color(0xFFFFFFFF),
                                    inactiveTrackColor: Color(0xFFE6E7E8),
                                    activeTrackColor: Color(0xFF1C6BF9),
                                    trackOutlineColor: WidgetStatePropertyAll(Color(0xFFE6E7E8)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Container(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "내가 가입한 상품 상환 알림",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 38,
                                height: 22,
                                child: Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    value: _isRedemptionAlarmOn,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isRedemptionAlarmOn = value;
                                      });
                                    },
                                    activeColor: Color(0xFFFFFFFF),
                                    inactiveThumbColor: Color(0xFFFFFFFF),
                                    inactiveTrackColor: Color(0xFFE6E7E8),
                                    activeTrackColor: Color(0xFF1C6BF9),
                                    trackOutlineColor: WidgetStatePropertyAll(Color(0xFFE6E7E8)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Container(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "관심 상품 청약 마감 D-1 알림",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 38,
                                height: 22,
                                child: Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    value: _isDdayAlarmOn,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isDdayAlarmOn = value;
                                      });
                                    },
                                    activeColor: Color(0xFFFFFFFF),
                                    inactiveThumbColor: Color(0xFFFFFFFF),
                                    inactiveTrackColor: Color(0xFFE6E7E8),
                                    activeTrackColor: Color(0xFF1C6BF9),
                                    trackOutlineColor: WidgetStatePropertyAll(Color(0xFFE6E7E8)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  _buildLittleListTile(
                    context: context,
                    title: "관심 상품 알림 설정",
                    onTap: () {

                    }
                  ),

                  _buildMiddleListTile(title: "안내 및 지원"),
                  _buildLittleListTile(
                      context: context,
                      title: "공지사항",
                      onTap: () {

                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "투자가이드",
                      onTap: () {

                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "문의 및 신고",
                      onTap: () {

                      }
                  ),

                  _buildMiddleListTile(title: "계정"),
                  _buildLittleListTile(
                      context: context,
                      title: "서비스 이용 약관",
                      onTap: () {

                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "개인정보 처리방침",
                      onTap: () {

                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "로그아웃",
                      onTap: () {

                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "회원탈퇴",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberQuitScreen(),
                          )
                        );
                      },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleListTile({
    required String title,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24, left: 16),
          child: Container(
            height: 60,
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF131415),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLittleListTile({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 60,
              child: ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: title == "회원탈퇴" ? Color(0xFFEE5648) : Color(0xFF3B3D3F),
                  ),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.arrow_forward_ios, size: 16)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
