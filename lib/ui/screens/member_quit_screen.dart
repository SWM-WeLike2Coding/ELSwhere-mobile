import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/data/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/app_resource.dart';
import '../../config/config.dart';

class MemberQuitScreen extends StatefulWidget {
  const MemberQuitScreen({super.key});

  @override
  State<MemberQuitScreen> createState() => _MemberQuitScreenState();
}

class _MemberQuitScreenState extends State<MemberQuitScreen> {
  bool _isAgreeBtnChecked = false;

  @override
  void initState() {
    super.initState();
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
              "회원탈퇴",
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
              padding: edgeInsetsAll24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32,),
                  Consumer<UserInfoProvider>(
                    builder: (context, userInfoProvider, child) {
                      return Text(
                        "${userInfoProvider.getNickname()}님",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32,),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGray,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: edgeInsetsAll16,
                      child: UnorderedList([
                        "서비스에서 탈퇴되며 복구가 불가능합니다.",
                        "단, 일부 정보는 일정기간 보관 후 파기됩니다.",
                        "자세한 내용은 이용약관 및 개인정보와 연결정보를 확인해주세요."
                      ])
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                checkColor: Color(0xFFFFFFFF),
                activeColor: Color(0xFF1C6BF9),
              ),
              GestureDetector(
                onTap: _toggleCheckbox,
                child: Text(
                  "안내사항을 모두 확인하였고, 이에 동의합니다."
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Container(
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
                            backgroundColor: Color(0xFFEE5648),
                            disabledBackgroundColor: Color(0xFFEE5648),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                          ),
                          onPressed: _isAgreeBtnChecked? () async {
                            final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                            if (await userInfoProvider.quitService(context)) {
                              print("회원 탈퇴 성공");
                            } else {
                              print("회원 탈퇴 실패");
                            }

                          } : null,
                          child: Text(
                            '탈퇴하기',
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
          ),
        ],
      ),
    );
  }

  void _toggleCheckbox() {
    setState(() {
      _isAgreeBtnChecked = !_isAgreeBtnChecked;
    });
  }
}


class UnorderedList extends StatelessWidget {
  UnorderedList(this.texts);
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
      widgetList.add(SizedBox(height: 10.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "•  ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}