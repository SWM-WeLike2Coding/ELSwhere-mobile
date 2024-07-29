import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';


class AlarmSettingModal extends StatefulWidget {
  const AlarmSettingModal({super.key});

  @override
  State<AlarmSettingModal> createState() => _AlarmSettingModalState();
}

class _AlarmSettingModalState extends State<AlarmSettingModal> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerKIB = TextEditingController();
  final TextEditingController _controllerCoupon = TextEditingController();

  int _selectedTypeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24,),
                  _buildSearchInput(),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFF5F6F6),
                              width: 1,
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "검색필터",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF595E62),
                            ),
                          ),
                          SizedBox(height: 12,),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controllerKIB,
                                  decoration: InputDecoration(
                                    labelText: "최대 KI 낙인배리어",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFFACB2B5),
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color(0xFFF5F6F6),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12,),
                              Expanded(
                                child: TextField(
                                  controller: _controllerCoupon,
                                  decoration: InputDecoration(
                                    labelText: "최수 수익률",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFFACB2B5),
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color(0xFFF5F6F6),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "상품종류",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF595E62),
                            ),
                          ),
                          SizedBox(height: 12,),
                          SizedBox(
                            height: 86,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 5, // 버튼의 가로:세로 비율을 조정하세요
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () => _onButtonPressed(index),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    backgroundColor: _selectedTypeIndex == index ? Color(0xFF1C6BF9) : Color(0xFFF5F6F6),
                                  ),
                                  child: Text(
                                    _getButtonText(index),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _selectedTypeIndex == index ? Color(0xFFFFFFFF) : Color(0xFFACB2B5)
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  // _buildCheckboxes(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // 저장 버튼 기능 구현
          },
          child: Text(
            '관심 상품 알림 저장',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color(0xFF1C6BF9),
          ),
        ),
      ),
    );
  }

  String _getButtonText(int index) {
    switch (index) {
      case 0:
        return '스텝다운형';
      case 1:
        return '낙아웃형';
      case 2:
        return '월지급형';
      case 3:
        return '리자드형';
      default:
        return '';
    }
  }

  void _onButtonPressed(int index) {
    setState(() {
      _selectedTypeIndex = index; // 선택된 버튼의 인덱스를 업데이트
    });
  }

  Widget _buildSearchInput() {
    return Row(
      children: [
        SizedBox(width: 8,),
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '기초자산명을 검색해보세요',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF838A8E),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        SizedBox(width: 8,),
        // ElevatedButton(
        //   onPressed: () {
        //     _addChip();
        //     print("hello");
        //   },
        //   child: Text('추가'),
        // ),
      ],
    );
  }
}
