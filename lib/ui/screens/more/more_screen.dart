import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/post_provider.dart';
import 'package:elswhere/ui/screens/more/announcement_screen.dart';
import 'package:elswhere/ui/screens/more/change_nickname_screen.dart';
import 'package:elswhere/ui/screens/more/investment_guide_screen.dart';
import 'package:elswhere/ui/screens/other/login_screen.dart';
import 'package:elswhere/ui/screens/more/member_quit_screen.dart';
import 'package:elswhere/ui/screens/more/terms_and_conditions_display_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/providers/user_info_provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final bool _isNoticeAlarmOn = false;
  final bool _isRedemptionAlarmOn = false;
  final bool _isDdayAlarmOn = false;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  late PostProvider _postProvider;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '더보기 화면',
      screenClass: 'MoreScreen',
    );
  }

  @override
  void initState() {
    _setCurrentScreen();
    _postProvider = Provider.of<PostProvider>(context, listen: false);
    super.initState();
  }

  void _showSaveConfirmation(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('저장되었습니다'),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showEditNicknameDialog(BuildContext context) {
    final TextEditingController nicknameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('닉네임 수정'),
          content: TextField(
            controller: nicknameController,
            decoration: const InputDecoration(
              hintText: '새 닉네임 입력',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                final newNickname = nicknameController.text;
                if (await userInfoProvider.changeNickname(newNickname)) {
                  print("닉네임 변경 성공");
                } else {
                  print("닉네임 변경 실패");
                }
                Navigator.of(context).pop();
                _showSaveConfirmation(context);
              },
              child: const Text(
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
            padding: edgeInsetsAll16,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '로그아웃 하시겠어요?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48, // 버튼 높이 조정 가능
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gray100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
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
                    const SizedBox(width: 8), // 버튼 사이 간격
                    Expanded(
                      child: SizedBox(
                        height: 48, // 버튼 높이 조정 가능
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainBlue,
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
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                                (route) => false,
                              );
                            }
                          },
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
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
  Widget build(BuildContext context) {
    const String manIcon = "assets/icons/icon/icon_man.svg";
    const String googleFormUrl = "https://docs.google.com/forms/d/e/1FAIpQLScZr3KWFVD82FepPi2KPUsEF3sKV2YApyTMv75ku35-KvsZ1A/viewform?usp=sf_link";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.only(left: 24.0), // 왼쪽 패딩 추가
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                child: const Text(
                  '더보기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray950,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.gray100,
                        width: 1.0,
                      )),
                  height: 70,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundProfile,
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
                      const SizedBox(
                        width: 16,
                      ),
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.gray400,
                                ),
                              );
                            },
                          ),
                          Consumer<UserInfoProvider>(
                            builder: (context, userInfoProvider, child) {
                              return Text(
                                '${userInfoProvider.getNickname()}님', // 여기에서 닉네임을 받아옵니다.
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: AppColors.gray300,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangeNicknameScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  // _buildMiddleListTile(
                  //   title: "알림",
                  // ),
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 16),
                  //       child: SizedBox(
                  //         height: 60,
                  //         child: ListTile(
                  //           title: const Text(
                  //             "공지사항 알림",
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //           trailing: Padding(
                  //             padding: const EdgeInsets.only(right: 8),
                  //             child: SizedBox(
                  //               width: 38,
                  //               height: 22,
                  //               child: Transform.scale(
                  //                 scale: 0.9,
                  //                 child: Switch(
                  //                   value: _isNoticeAlarmOn,
                  //                   onChanged: (bool value) {
                  //                     setState(() {
                  //                       _isNoticeAlarmOn = value;
                  //                     });
                  //                   },
                  //                   activeColor: Colors.white,
                  //                   inactiveThumbColor: Colors.white,
                  //                   inactiveTrackColor: AppColors.gray100,
                  //                   activeTrackColor: AppColors.mainBlue,
                  //                   trackOutlineColor: const WidgetStatePropertyAll(AppColors.gray100),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 16),
                  //       child: SizedBox(
                  //         height: 60,
                  //         child: ListTile(
                  //           title: const Text(
                  //             "내가 가입한 상품 상환 알림",
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //           trailing: Padding(
                  //             padding: const EdgeInsets.only(right: 8),
                  //             child: SizedBox(
                  //               width: 38,
                  //               height: 22,
                  //               child: Transform.scale(
                  //                 scale: 0.9,
                  //                 child: Switch(
                  //                   value: _isRedemptionAlarmOn,
                  //                   onChanged: (bool value) {
                  //                     setState(() {
                  //                       _isRedemptionAlarmOn = value;
                  //                     });
                  //                   },
                  //                   activeColor: Colors.white,
                  //                   inactiveThumbColor: Colors.white,
                  //                   inactiveTrackColor: AppColors.gray100,
                  //                   activeTrackColor: AppColors.mainBlue,
                  //                   trackOutlineColor: const WidgetStatePropertyAll(AppColors.gray100),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 16),
                  //       child: SizedBox(
                  //         height: 60,
                  //         child: ListTile(
                  //           title: const Text(
                  //             "관심 상품 청약 마감 D-1 알림",
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //           trailing: Padding(
                  //             padding: const EdgeInsets.only(right: 8),
                  //             child: SizedBox(
                  //               width: 38,
                  //               height: 22,
                  //               child: Transform.scale(
                  //                 scale: 0.9,
                  //                 child: Switch(
                  //                   value: _isDdayAlarmOn,
                  //                   onChanged: (bool value) {
                  //                     setState(() {
                  //                       _isDdayAlarmOn = value;
                  //                     });
                  //                   },
                  //                   activeColor: Colors.white,
                  //                   inactiveThumbColor: Colors.white,
                  //                   inactiveTrackColor: AppColors.gray100,
                  //                   activeTrackColor: AppColors.mainBlue,
                  //                   trackOutlineColor: const WidgetStatePropertyAll(AppColors.gray100),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //
                  // _buildLittleListTile(
                  //   context: context,
                  //   title: "관심 상품 알림 설정",
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const AttentionSettingScreen(),
                  //         )
                  //     );
                  //   }
                  // ),

                  _buildMiddleListTile(title: "안내 및 지원"),
                  _buildLittleListTile(
                    context: context,
                    title: "공지사항",
                    onTap: _onTapAnnouncementButton,
                  ),
                  _buildLittleListTile(
                      context: context,
                      title: "투자가이드",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InvestmentGuideScreen(),
                          ),
                        );
                      }),
                  _buildLittleListTile(
                      context: context,
                      title: "문의 및 신고",
                      onTap: () async {
                        if (await canLaunch(googleFormUrl)) {
                          await launch(googleFormUrl);
                        } else {
                          throw 'Could not launch $googleFormUrl';
                        }
                      }),

                  _buildMiddleListTile(title: "계정"),
                  _buildLittleListTile(
                      context: context,
                      title: "서비스 이용 약관",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsAndConditionsDisplayScreen(
                                typeIndex: 0,
                              ),
                            ));
                      }),
                  _buildLittleListTile(
                      context: context,
                      title: "개인정보 처리방침",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsAndConditionsDisplayScreen(
                                typeIndex: 1,
                              ),
                            ));
                      }),
                  _buildLittleListTile(
                      context: context,
                      title: "로그아웃",
                      onTap: () {
                        _showLogoutDialog(context);
                      }),
                  _buildLittleListTile(
                    context: context,
                    title: "회원탈퇴",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemberQuitScreen(),
                          ));
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
          padding: const EdgeInsets.only(top: 24, left: 16),
          child: SizedBox(
            height: 60,
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray950,
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
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.grey.withOpacity(0.1),
            child: SizedBox(
              height: 60,
              child: ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: title == "회원탈퇴" ? AppColors.contentRed : AppColors.gray900,
                  ),
                ),
                trailing: const Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.arrow_forward_ios, size: 16)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onTapAnnouncementButton() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );

    final result = await _postProvider.fetchNotices();

    if (mounted) Navigator.pop(context);

    if (result) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnnouncementScreen()),
        );
      }
    } else {
      Fluttertoast.showToast(msg: MSG_ERR_FETCH_NOTICES, toastLength: Toast.LENGTH_SHORT);
    }
  }
}
