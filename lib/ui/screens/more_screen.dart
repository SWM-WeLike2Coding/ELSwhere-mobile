// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:elswhere/data/services/user_service.dart';
import 'package:elswhere/ui/screens/announcement_screen.dart';
import 'package:elswhere/ui/screens/attention_setting_screen.dart';
import 'package:elswhere/ui/screens/change_nickname_screen.dart';
import 'package:elswhere/ui/screens/investment_guide_screen.dart';
import 'package:elswhere/ui/screens/login_screen.dart';
import 'package:elswhere/ui/screens/member_quit_screen.dart';
import 'package:elswhere/ui/screens/service_agreement_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/config.dart';
import '../../data/models/dtos/response_user_info_dto.dart';
import '../../data/providers/user_info_provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isNoticeAlarmOn = false;
  bool _isRedemptionAlarmOn = false;
  bool _isDdayAlarmOn = false;

  void _showSaveConfirmation(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('저장되었습니다'),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showEditNicknameDialog(BuildContext context) {
    final TextEditingController _nicknameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('닉네임 수정'),
          content: TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              hintText: '새 닉네임 입력',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                final newNickname = _nicknameController.text;
                if (await userInfoProvider.changeNickname(newNickname)) {
                  print("닉네임 변경 성공");
                } else {
                  print("닉네임 변경 실패");
                }
                Navigator.of(context).pop();
                _showSaveConfirmation(context);
              },
              child: Text(
                '저장',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.165,
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '로그아웃 하시겠어요?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48, // 버튼 높이 조정 가능
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE6E7E8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
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
                    SizedBox(width: 8), // 버튼 사이 간격
                    Expanded(
                      child: SizedBox(
                        height: 48, // 버튼 높이 조정 가능
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1C6BF9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                            final result = await userInfoProvider.logout(context);
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                            Fluttertoast.showToast(msg: result ? '로그아웃 되었습니다.' : '로그아웃에 실패했습니다.', toastLength: Toast.LENGTH_SHORT);
                            if (result) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false,);
                            }
                          },
                          child: Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String manIcon = "assets/icons/icon_man.svg";
    final String googleFormUrl = "https://docs.google.com/forms/d/e/1FAIpQLSdTf1hcZYurHxd_IV62SUSWqDX44Nm4toFMYOFZYaEeYYOYsw/viewform?usp=sf_link";


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
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            manIcon,
                            width: 27,
                            height: 23.16,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<UserInfoProvider>(
                            builder: (context, provider, child) {
                              DateTime? createdTime = Provider.of<UserInfoProvider>(context, listen: false).userInfo?.createdAt;
                              DateTime now = DateTime.now();
                              Duration difference = now.difference(createdTime!);

                              return Text(
                                "${difference.inDays + 1}일동안 함께한",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF838A8E),
                                ),
                              );
                            },
                          ),
                          Consumer<UserInfoProvider>(
                            builder: (context, userInfoProvider, child) {
                              return Text(
                                userInfoProvider.getNickname() + '님', // 여기에서 닉네임을 받아옵니다.
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFF000000),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Color(0xFFACB2B5),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNicknameScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 8,),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttentionSettingScreen(),
                          )
                      );
                    }
                  ),

                  _buildMiddleListTile(title: "안내 및 지원"),
                  _buildLittleListTile(
                      context: context,
                      title: "공지사항",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementScreen(),
                          ),
                        );
                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "투자가이드",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvestmentGuideScreen(),
                          ),
                        );
                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "문의 및 신고",
                      onTap: () async {
                        if (await canLaunch(googleFormUrl)) {
                          await launch(googleFormUrl);
                        } else {
                          throw 'Could not launch $googleFormUrl';
                        }
                      }
                  ),

                  _buildMiddleListTile(title: "계정"),
                  _buildLittleListTile(
                      context: context,
                      title: "서비스 이용 약관",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceAgreementScreen(typeIndex: 0,),
                            )
                        );
                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "개인정보 처리방침",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceAgreementScreen(typeIndex: 1,),
                            )
                        );
                      }
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "로그아웃",
                      onTap: () {
                        _showLogoutDialog(context);
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
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.grey.withOpacity(0.1),
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
