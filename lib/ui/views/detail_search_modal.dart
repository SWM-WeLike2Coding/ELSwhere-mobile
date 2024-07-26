import 'dart:convert';
import 'package:elswhere/data/models/dtos/request_product_search_dto.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';


class DetailSearchModal extends StatefulWidget {
  const DetailSearchModal({super.key});

  @override
  State<DetailSearchModal> createState() => _DetailSearchModalState();
}

class _DetailSearchModalState extends State<DetailSearchModal> {
  static final String _baseUrl = dotenv.env['ELS_BASE_URL']!;
  final TextEditingController _equityController = TextEditingController();
  final TextEditingController _KIController = TextEditingController();
  final TextEditingController _yieldController = TextEditingController();
  final TextEditingController _firstBarrierController = TextEditingController();
  final TextEditingController _lastBarrierController = TextEditingController();
  final List<String> _chips = [];

  int? _equityCount;
  int? _maxKnockIn;
  double? _minYield;
  int? _initialRedemptionBarrier;
  int? _maturityRedemptionBarrier;
  int? _subscriptionPeriod;
  int? _redemptionInterval;
  bool _isIndex = false;
  bool _isStock = false;
  int _selectedTypeIndex = -1;
  List<String> _buttonLabels = ["스텝다운형", "리자드형", "월지급형", "기타"];
  Map<int, String> _selectedDates = {};

  Future<void> _getFilteredData() async {
    String? equityType = null;
    if (_isStock && _isIndex) {
      equityType = "MIX";
    } else if (_isIndex) {
      equityType = "INDEX";
    } else if (_isStock) {
      equityType = "STOCK";
    } else {
      equityType = null;  // 이거 바꿔줘야함
    }

    List<String> typeList = ["STEP_DOWN", "LIZARD", "MONTHLY_PAYMENT", "ETC"];
    String? type;
    if (_selectedTypeIndex != -1) {
      type = typeList[_selectedTypeIndex];
    }
    String? subscriptionStartDate = _selectedDates[0];
    String? subscriptionEndDate = _selectedDates[1];

    Map<String, dynamic> body = {};

    if (_chips.isNotEmpty) body['equityNames'] = _chips;
    if (_equityCount != null) body['equityCount'] = _equityCount;
    if (_maxKnockIn != null) body['maxKnockIn'] = _maxKnockIn;
    if (_minYield != null) body['minYieldIfConditionsMet'] = _minYield;
    if (_initialRedemptionBarrier != null) body['initialRedemptionBarrier'] = _initialRedemptionBarrier;
    if (_maturityRedemptionBarrier != null) body['maturityRedemptionBarrier'] = _maturityRedemptionBarrier;
    if (_subscriptionPeriod != null) body['subscriptionPeriod'] = _subscriptionPeriod;
    if (_redemptionInterval != null) body['redemptionInterval'] = _redemptionInterval;
    if (equityType != null) body['equityType'] = equityType;
    if (type != null) body['type'] = type;
    if (subscriptionStartDate != null) body['subscriptionStartDate'] = subscriptionStartDate;
    if (subscriptionEndDate != null) body['subscriptionEndDate'] = subscriptionEndDate;

    // String jsonBody = jsonEncode(body);
    final requestBody = RequestProductSearchDto.fromJson(body);
    await Provider.of<ELSOnSaleProductsProvider>(context, listen: false).fetchFilteredProducts(requestBody);
    await Provider.of<ELSEndSaleProductsProvider>(context, listen: false).fetchFilteredProducts(requestBody);
  }

  void _addChip() {
    if (_equityController.text.isNotEmpty) {
      setState(() {
        _chips.add(_equityController.text);
        _equityController.clear();
      });
    }
  }

  void _deleteChip(String chip) {
    setState(() {
      _chips.remove(chip);
    });
  }

  void _updateKIValue(String value) {
    final int? parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue >= 0 && parsedValue <= 100) {
      setState(() {
        _maxKnockIn = parsedValue;
      });
    } else {
      setState(() {
        _maxKnockIn = null; // Or you can set it to a default value like 0 if needed
      });
    }
  }

  void _updateYieldValue(String value) {
    final double? parsedValue = double.tryParse(value);
    if (parsedValue != null && parsedValue >= 0 && parsedValue <= 100) {
      setState(() {
        _minYield = parsedValue;
      });
    } else {
      setState(() {
        _minYield = null; // Or you can set it to a default value like 0 if needed
      });
    }
  }

  void _updateFirstBarrier(String value) {
    final int? parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue >= 0 && parsedValue <= 100) {
      setState(() {
        _initialRedemptionBarrier = parsedValue;
      });
    } else {
      setState(() {
        _initialRedemptionBarrier = null; // Or you can set it to a default value like 0 if needed
      });
    }
  }

  void _updateLastBarrier(String value) {
    final int? parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue >= 0 && parsedValue <= 100) {
      setState(() {
        _maturityRedemptionBarrier = parsedValue;
      });
    } else {
      setState(() {
        _maturityRedemptionBarrier = null; // Or you can set it to a default value like 0 if needed
      });
    }
  }

  void _handleButtonTap(int index) {
    setState(() {
      _selectedTypeIndex = index;
    });
  }

  Future<void> _handleDateSelection(BuildContext context, int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        // 선택된 날짜를 저장하고 라벨을 업데이트
        _selectedDates[index] = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '조건등록',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "기초자산명",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildSearchInput(),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _chips.map((chip) => InputChip(
                          label: Text(chip),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () => _deleteChip(chip),
                        )).toList(),
                      ),
                      SizedBox(height: 16),
                      _buildDropDowns(),
                      SizedBox(height: 16),
                      _buildCheckboxes(),
                      SizedBox(height: 16),
                      _buildDateButtons(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildConfirmButton(context),
            ),
          ],
        ),
      ),
    );


  }

  Widget _buildSearchInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _equityController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '키워드 입력',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        SizedBox(width: 8,),
        ElevatedButton(
          onPressed: () {
            _addChip();
          },
          child: Text('추가'),
        ),
      ],
    );
  }

  Widget _buildDropDowns() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "기초자산수",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Icon(Icons.search),
                      // SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: _equityCount == null ? Text("선택") : Text("${_equityCount!}개"),
                          items: ['1개', '2개', '3개'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _equityCount = int.parse(newValue!.split('개')[0]);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 40,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "발행회사",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Icon(Icons.search),
                      // SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("선택"),
                          items: ['선택1', '선택2', '선택3'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "최대 KI(낙인 배리어)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _KIController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '입력',
                            // contentPadding: EdgeInsets.only(bottom: 20),
                            // focusedBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.purpleAccent), // 포커스 시 밑줄 색상
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!), // 기본 상태의 밑줄 색상
                            ),
                            // border: InputBorder.none, // InputDecorator에서 테두리를 설정했으므로, 내부 테두리는 제거
                          ),
                          // isDense: true,
                          onChanged: _updateKIValue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 40,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "최소수익률",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _yieldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '입력',
                            // contentPadding: EdgeInsets.only(bottom: 20),
                            // focusedBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.purpleAccent), // 포커스 시 밑줄 색상
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!), // 기본 상태의 밑줄 색상
                            ),
                            // border: InputBorder.none, // InputDecorator에서 테두리를 설정했으므로, 내부 테두리는 제거
                          ),
                          // isDense: true,
                          onChanged: _updateYieldValue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1차상환 배리어",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstBarrierController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '입력',
                            // contentPadding: EdgeInsets.only(bottom: 20),
                            // focusedBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.purpleAccent), // 포커스 시 밑줄 색상
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!), // 기본 상태의 밑줄 색상
                            ),
                            // border: InputBorder.none, // InputDecorator에서 테두리를 설정했으므로, 내부 테두리는 제거
                          ),
                          // isDense: true,
                          onChanged: _updateFirstBarrier,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 40,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "만기상환 배리어",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _lastBarrierController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '입력',
                            // contentPadding: EdgeInsets.only(bottom: 20),
                            // focusedBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.purpleAccent), // 포커스 시 밑줄 색상
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!), // 기본 상태의 밑줄 색상
                            ),
                            // border: InputBorder.none, // InputDecorator에서 테두리를 설정했으므로, 내부 테두리는 제거
                          ),
                          // isDense: true,
                          onChanged: _updateLastBarrier,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "상품가입기간",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Icon(Icons.search),
                      // SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: _subscriptionPeriod == null ? Text("선택") : Text("${_subscriptionPeriod!}년"),
                          items: ['1년', '2년', '3년'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _subscriptionPeriod = int.parse(newValue!.split('년')[0]);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 40,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "상환일간격",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Icon(Icons.search),
                      // SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: _redemptionInterval == null ? Text("선택") : Text("${_redemptionInterval!}개월"),
                          items: ['3개월', '4개월', '6개월'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _redemptionInterval = int.parse(newValue!.split('개월')[0]);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownWithIcon(String title, String hint) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${title}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              // Icon(Icons.search),
              // SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(hint),
                  items: ['선택1', '선택2', '선택3'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "종목유형",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _isIndex ? Colors.blue : Colors.grey[300],
                  ),
                  onPressed: () {
                    setState(() {
                      _isIndex = !_isIndex;
                    });
                  },
                  child: Text(
                    "지수형",
                    style: TextStyle(
                      color: _isIndex ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _isStock ? Colors.blue : Colors.grey[300],
                  ),
                  onPressed: () {
                    setState(() {
                      _isStock = !_isStock;
                    });
                  },
                  child: Text(
                    "종목형",
                    style: TextStyle(
                      color: _isStock ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 6,),
        Text(
          "상품종류",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            _buildCheckboxButton(_buttonLabels[0], 0),
            _buildCheckboxButton(_buttonLabels[1], 1),
          ],
        ),
        Row(
          children: [
            _buildCheckboxButton(_buttonLabels[2], 2),
            _buildCheckboxButton(_buttonLabels[3], 3),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxButton(String label, int index) {
    bool isChecked = _selectedTypeIndex == index;
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: isChecked ? Colors.blue : Colors.grey[300],
          ),
          onPressed: () {
            _handleButtonTap(index);
          },
          child: Text(
            label,
            style: TextStyle(
              color: isChecked ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildCheckboxButton(String label, {bool isChecked = false}) {
  //   return Expanded(
  //     child: Container(
  //       margin: EdgeInsets.all(4),
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           padding: EdgeInsets.symmetric(vertical: 16),
  //           backgroundColor: isChecked ? Colors.blue : Colors.grey[300],
  //         ),
  //         onPressed: () {
  //           // 여기에 선택 로직을 구현하세요
  //         },
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             color: isChecked ? Colors.white : Colors.black,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDateButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "발행일",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            _buildDateButton(context, "시작일", 0),
            _buildDateButton(context, "마감일", 1),
          ],
        )
      ],
    );
  }

  Widget _buildDateButton(BuildContext context, String label, int index) {
    String displayLabel = _selectedDates[index] ?? label;
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => _handleDateSelection(context, index),
          child: Text(displayLabel, style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          _getFilteredData();
        },
        child: Text('확인'),
      ),
    );
  }
}
