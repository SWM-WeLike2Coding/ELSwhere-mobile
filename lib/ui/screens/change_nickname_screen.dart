import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';

import '../../config/app_resource.dart';
import '../../data/providers/user_info_provider.dart';
import '../../data/services/user_service.dart';

class ChangeNicknameScreen extends StatefulWidget {
  const ChangeNicknameScreen({super.key});

  @override
  State<ChangeNicknameScreen> createState() => _ChangeNicknameScreenState();
}

class _ChangeNicknameScreenState extends State<ChangeNicknameScreen> {
  TextEditingController _controller = TextEditingController();
  int _isThisNicknamePossible = -1;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onNicknameChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  
  void _onNicknameChanged(String value) {
    setState(() {
      _isThisNicknamePossible = -1;
    });

    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      if (value.isNotEmpty) {
        bool isAvailable = await userInfoProvider.checkNicknamePossible(value);
        setState(() {
          _isThisNicknamePossible = isAvailable ? 1 : 0;
        });
      } else {
        setState(() {
          _isThisNicknamePossible = -1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: _buildAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32,),
          _buildProfile(),
          SizedBox(height: 40,),
          _buildNicknameField(),
          if (_isThisNicknamePossible == 1)
            _buildPossibleSign(),
          if (_isThisNicknamePossible == 0)
            _buildImpossibleSign(),
        ],
      ),
      bottomNavigationBar: _buildBottomSaveButton(),
    );
  }

  PreferredSize _buildAppbar() {
    return PreferredSize(
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
            "내 프로필",
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

  Widget _buildProfile() {
    const String manIcon = "assets/icons/icon_man.svg";

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD1E0FB),
          shape: BoxShape.circle,
        ),
        height: 64,
        width: 64,
        child: Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            manIcon,
            width: 48,
            height: 41.18,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildNicknameField() {
    const String removeIcon = "assets/icons/icon_remove_all.svg";
    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      // width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "닉네임",
            style: TextStyle(
              color: Color(0xFF595E62),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.18,
              letterSpacing: -0.02,
            ),
          ),
          SizedBox(height: 12,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFFE6E7E8),
                width: 1,
              )
            ),
            height: 52,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Consumer<UserInfoProvider> (
                  builder: (context, userInfoProvider, child) {
                    return TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        hintText: userInfoProvider.getNickname(),
                      ),
                      onChanged: _onNicknameChanged,
                    );
                  },
                ),
                if (_controller.text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        removeIcon,
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildPossibleSign() {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1C6BF9),
                shape: BoxShape.circle,
              ),
              height: 18,
              width: 18,
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Color(0xFFFFFFFF),
                  size: 12,
                ),
              ),
            ),
            SizedBox(width: 8,),
              Text(
                "사용 가능한 닉네임입니다",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.18,
                  letterSpacing: -0.02,
                  color: Color(0xFF1C6BF9),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpossibleSign() {

    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFEE5648),
                shape: BoxShape.circle,
              ),
              height: 18,
              width: 18,
              child: Center(
                child: Icon(
                  Icons.clear,
                  color: Color(0xFFFFFFFF),
                  size: 12,
                ),
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "이미 사용 중인 닉네임입니다",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.18,
                letterSpacing: -0.02,
                color: Color(0xFFEE5648),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 32),
      child: SizedBox(
        width: double.infinity, // 가로로 꽉 차게 설정
        height: 50, // 버튼 높이 설정
        child: Container(
          child: ElevatedButton(
            onPressed: () async {
              if (_isThisNicknamePossible == 1) {
                final newNickname = _controller.text;
                if (await userInfoProvider.changeNickname(newNickname)) {
                  print("닉네임 변경 성공");
                  Fluttertoast.showToast(msg: "성공적으로 닉네임을 변경하였습니다");
                  Navigator.of(context).pop();
                } else {
                  print("닉네임 변경 실패");
                  Fluttertoast.showToast(msg: "닉네임 변경이 실패하였습니다");
                }
              } else {
                print("닉네임 변경 실패");
                Fluttertoast.showToast(msg: "닉네임 사용 가능한지 확인해주세요");
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF1C6BF9)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 버튼의 둥근 모서리
              )),
            ),
            child: Text(
              "저장",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.18,
                letterSpacing: -0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
