import 'dart:convert';
import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/request_product_search_dto.dart';
import 'package:elswhere/data/models/dtos/response_issuer_dto.dart';
import 'package:elswhere/data/providers/els_products_provider.dart';
import 'package:elswhere/data/providers/issuer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/models/dtos/response_ticker_symbol_dto.dart';
import '../../data/providers/ticker_symbol_provider.dart';

class DetailSearchModal extends StatefulWidget {
  VoidCallback? callback;
  DetailSearchModal({super.key, this.callback});

  @override
  State<DetailSearchModal> createState() => _DetailSearchModalState();
}

class _DetailSearchModalState extends State<DetailSearchModal> {
  final TextEditingController _equityController = TextEditingController();
  final TextEditingController _KIController = TextEditingController();
  final TextEditingController _yieldController = TextEditingController();
  final TextEditingController _firstBarrierController = TextEditingController();
  final TextEditingController _lastBarrierController = TextEditingController();
  final List<String> _chips = [];
  final List<ResponseTickerSymbolDto> _selectedTickers = [];
  List<ResponseTickerSymbolDto> _filteredTickers = [];
  List<ResponseIssuerDto> _issuerDTOList = [];
  final List<String> _issuerList = ['발행회사'];
  bool _isLoading = false;

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
  String? _selectedIssuer;
  final List<String> _buttonLabels = ["스텝다운형", "리자드형", "월지급형", "기타"];
  final Map<int, String> _selectedDates = {0: "시작일", 1: "마감일"};
  final List<String> _initialDatePickerString = ["시작일", "마감일"];

  Future<void> _getFilteredData() async {
    if (widget.callback != null) widget.callback!();
    String? equityType;
    if (_isStock && _isIndex) {
      equityType = "MIX";
    } else if (_isIndex) {
      equityType = "INDEX";
    } else if (_isStock) {
      equityType = "STOCK";
    } else {
      equityType = null; // 이거 바꿔줘야함
    }

    List<String> equityList = [];
    for (int i = 0; i < _selectedTickers.length; i++) {
      equityList.add(_selectedTickers[i].equityName);
    }
    List<String> typeList = ["STEP_DOWN", "LIZARD", "MONTHLY_PAYMENT", "ETC"];
    String? type;
    if (_selectedTypeIndex != -1) {
      type = typeList[_selectedTypeIndex];
    }
    String? subscriptionStartDate = _selectedDates[0];
    String? subscriptionEndDate = _selectedDates[1];

    Map<String, dynamic> body = {};

    if (equityList.isNotEmpty) body['equityNames'] = equityList;
    if (_equityCount != null) body['equityCount'] = _equityCount;
    if (_selectedIssuer != null) body['issuer'] = _selectedIssuer;
    if (_maxKnockIn != null) body['maxKnockIn'] = _maxKnockIn;
    if (_minYield != null) body['minYieldIfConditionsMet'] = _minYield;
    if (_initialRedemptionBarrier != null) body['initialRedemptionBarrier'] = _initialRedemptionBarrier;
    if (_maturityRedemptionBarrier != null) body['maturityRedemptionBarrier'] = _maturityRedemptionBarrier;
    if (_subscriptionPeriod != null) body['subscriptionPeriod'] = _subscriptionPeriod;
    if (_redemptionInterval != null) body['redemptionInterval'] = _redemptionInterval;
    if (equityType != null) body['equityType'] = equityType;
    if (type != null) body['type'] = type;
    if (subscriptionStartDate != '시작일') body['subscriptionStartDate'] = subscriptionStartDate;
    if (subscriptionEndDate != '마감일') body['subscriptionEndDate'] = subscriptionEndDate;

    print(body);

    final requestBody = RequestProductSearchDto.fromJson(body);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    await Provider.of<ELSOnSaleProductsProvider>(context, listen: false).fetchFilteredProducts(requestBody);
    await Provider.of<ELSEndSaleProductsProvider>(context, listen: false).fetchFilteredProducts(requestBody);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _addTickerToSelected(ResponseTickerSymbolDto ticker) {
    setState(() {
      _selectedTickers.add(ticker);
      _equityController.clear(); // Clear the text field after adding
      _filteredTickers = []; // Hide the list
    });
  }

  void _removeTickerFromSelected(ResponseTickerSymbolDto ticker) {
    setState(() {
      _selectedTickers.remove(ticker);
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

  Future<void> _handleDateSelection(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // 달력의 주 색상
              onPrimary: Colors.white, // 선택된 날짜의 텍스트 색상
              onSurface: Colors.black, // 달력의 텍스트 색상
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: textTheme.labelMedium,
                foregroundColor: Colors.black, // 버튼 텍스트 색상
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        // 선택된 날짜를 저장하고 라벨을 업데이트
        _selectedDates[index] = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _onButtonPressed(int index) {
    setState(() {
      // Toggle the selection state
      if (_selectedTypeIndex == index) {
        // If the currently selected button is clicked again, deselect it
        _selectedTypeIndex = -1;
      } else {
        // Otherwise, select the new button
        _selectedTypeIndex = index;
      }
    });
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

  void _onSearchTextChanged() {
    final query = _equityController.text.toLowerCase();

    final provider = Provider.of<TickerSymbolProvider>(context, listen: false);
    final allTickers = provider.tickers;

    setState(() {
      _filteredTickers = allTickers.where((ticker) {
        return ticker.equityName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<TickerSymbolProvider>(context, listen: false);
      await provider.fetchTickers(); // 데이터 가져오기
      setState(() {
        _filteredTickers = provider.tickers; // 초기 데이터 설정
      });
    } catch (error) {
      print('Error fetching tickers: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    try {
      final issuerProvider = Provider.of<IssuerProvider>(context, listen: false);
      await issuerProvider.fetchIssuers(); // 데이터 가져오기
      setState(() {
        _issuerDTOList = issuerProvider.issuer; // 초기 데이터 설정
      });
    } catch (error) {
      print('Error fetching tickers: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    for (int i = 0; i < _issuerDTOList.length; i++) {
      _issuerList.add(_issuerDTOList[i].issuer);
    }
  }

  @override
  void initState() {
    super.initState();
    _equityController.addListener(_onSearchTextChanged);
    _fetchInitialData();
  }

  @override
  void dispose() {
    _equityController.removeListener(_onSearchTextChanged);
    _equityController.dispose(); // 메모리 누수 방지를 위해 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    _buildSearchInput(),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _selectedTickers.map((ticker) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Chip(
                              label: Text(
                                ticker.equityName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF838A8E),
                                ),
                              ),
                              onDeleted: () {
                                _removeTickerFromSelected(ticker);
                              },
                              deleteIcon: const Icon(Icons.close),
                              deleteIconColor: const Color(0xFFACB2B5),
                              backgroundColor: AppColors.gray50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(600),
                                side: const BorderSide(
                                  color: AppColors.gray50,
                                  width: 0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: AppColors.gray50,
                        width: 1,
                      ))),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                      child: _buildDropDowns(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                      child: _buildCheckboxes(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                      child: _buildDateButtons(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            if (_selectedDates[0] != "시작일" && _selectedDates[1] != "마감일") {
              DateTime startDate = DateTime.parse(_selectedDates[0]!);
              DateTime endDate = DateTime.parse(_selectedDates[1]!);
              if (startDate.isAfter(endDate)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('마감일이 시작일보다 빠를 수 없습니다.'),
                  ),
                );
                return;
              }
            }

            await _getFilteredData();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: const Color(0xFF1C6BF9),
          ),
          child: const Text(
            '상품 검색',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: TextField(
                controller: _equityController,
                decoration: InputDecoration(
                  hintText: '기초자산명을 검색해보세요',
                  hintStyle: const TextStyle(
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
            const SizedBox(width: 8),
          ],
        ),
        if (_equityController.text.isNotEmpty && !_isLoading)
          Container(
            height: 200, // 결과 리스트의 높이
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: _filteredTickers.length,
              itemBuilder: (context, index) {
                final ticker = _filteredTickers[index];
                return ListTile(
                  title: Text(ticker.equityName),
                  onTap: () {
                    // 선택된 값을 처리하는 로직 추가
                    print('Selected: ${ticker.equityName}');
                    // 선택된 항목을 _controller에 표시하고 리스트를 숨깁니다
                    _equityController.text = ticker.equityName;
                    _filteredTickers = []; // 리스트 숨기기
                    setState(() {
                      _addTickerToSelected(ticker);
                    }); // 상태 업데이트
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDropDowns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "검색필터",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        hint: _equityCount == null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "기초자산 수",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFFACB2B5)),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "${_equityCount!}개",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                        items: ['기초자산 수', '1개', '2개', '3개'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == '기초자산 수') {
                              _equityCount = null;
                              return;
                            }
                            _equityCount = int.parse(newValue!.split('개')[0]);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        hint: _selectedIssuer == null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "발행회사",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFFACB2B5)),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  _selectedIssuer!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                        items: _issuerList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == '발행회사') {
                              _selectedIssuer = null;
                              return;
                            }
                            _selectedIssuer = newValue;
                            print(_selectedIssuer);
                          });
                        },
                        menuMaxHeight: 5 * 48,
                        itemHeight: 48,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        hint: _subscriptionPeriod == null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "상품가입기간",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFFACB2B5)),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "${_subscriptionPeriod!}년",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                        items: ['상품가입기간', '1년', '2년', '3년'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == '상품가입기간') {
                              _subscriptionPeriod = null;
                              return;
                            }
                            _subscriptionPeriod = int.parse(newValue!.split('년')[0]);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        hint: _redemptionInterval == null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "상환일간격",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFFACB2B5)),
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "${_redemptionInterval!}개월",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                        items: ['상환일간격', '3개월', '4개월', '6개월'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == '상환일간격') {
                              _redemptionInterval = null;
                              return;
                            }
                            _redemptionInterval = int.parse(newValue!.split('개월')[0]);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: _KIController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumberRangeTextInputFormatter(min: 0, max: 100),
                  ],
                  decoration: InputDecoration(
                    hintText: "최대 KI 낙인배리어",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFFACB2B5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.gray50,
                  ),
                  onChanged: _updateKIValue,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: TextField(
                controller: _yieldController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  NumberRangeTextInputFormatter(min: 0, max: 100),
                ],
                decoration: InputDecoration(
                  hintText: "최소 수익률",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFFACB2B5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.gray50,
                ),
                onChanged: _updateYieldValue,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: _firstBarrierController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumberRangeTextInputFormatter(min: 0, max: 100),
                  ],
                  decoration: InputDecoration(
                    hintText: "1차상환 배리어",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFFACB2B5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.gray50,
                  ),
                  onChanged: _updateFirstBarrier,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                child: TextField(
                  controller: _lastBarrierController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NumberRangeTextInputFormatter(min: 0, max: 100),
                  ],
                  decoration: InputDecoration(
                    hintText: "만기상환 배리어",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFFACB2B5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.gray50,
                  ),
                  onChanged: _updateLastBarrier,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "종목유형",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray600,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: _isIndex ? const Color(0xFF1C6BF9) : AppColors.gray50,
                ),
                onPressed: () {
                  setState(() {
                    _isIndex = !_isIndex;
                  });
                },
                child: Text(
                  "지수형",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _isIndex ? const Color(0xFFFFFFFF) : const Color(0xFFACB2B5)),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: _isStock ? const Color(0xFF1C6BF9) : AppColors.gray50,
                ),
                onPressed: () {
                  setState(() {
                    _isStock = !_isStock;
                  });
                },
                child: Text(
                  "종목형",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _isStock ? const Color(0xFFFFFFFF) : const Color(0xFFACB2B5)),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        const Text(
          "상품종류",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray600,
          ),
        ),
        SizedBox(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  backgroundColor: _selectedTypeIndex == index ? const Color(0xFF1C6BF9) : AppColors.gray50,
                ),
                child: Text(
                  _getButtonText(index),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _selectedTypeIndex == index ? const Color(0xFFFFFFFF) : const Color(0xFFACB2B5)),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildDateButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "발행일",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray600,
          ),
        ),
        Row(
          children: [
            _buildDateButton(context, _initialDatePickerString[0], 0),
            const SizedBox(
              width: 12,
            ),
            _buildDateButton(context, _initialDatePickerString[1], 1),
          ],
        )
      ],
    );
  }

  Widget _buildDateButton(BuildContext context, String label, int index) {
    String displayLabel = _selectedDates[index] ?? label;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: displayLabel != label ? const Color(0xFF1C6BF9) : AppColors.gray50,
        ),
        // onPressed: () {
        //   if (displayLabel == label) {
        //
        //   }
        // },
        onPressed: () => _handleDateSelection(context, index),
        child: Text(
          displayLabel,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: displayLabel != label ? const Color(0xFFFFFFFF) : const Color(0xFFACB2B5)),
        ),
      ),
    );
  }
}

class NumberRangeTextInputFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumberRangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final double? newDouble = double.tryParse(newValue.text);
    if (newDouble == null) {
      return oldValue;
    }

    if (newDouble < min || newDouble > max) {
      return oldValue;
    }

    return newValue;
  }
}
