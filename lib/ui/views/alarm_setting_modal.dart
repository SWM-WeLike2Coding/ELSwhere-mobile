import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/models/dtos/response_ticker_symbol_dto.dart';
import '../../data/providers/ticker_symbol_provider.dart';

class AlarmSettingModal extends StatefulWidget {
  const AlarmSettingModal({super.key});

  @override
  State<AlarmSettingModal> createState() => _AlarmSettingModalState();
}

class _AlarmSettingModalState extends State<AlarmSettingModal> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerKIB = TextEditingController();
  final TextEditingController _controllerCoupon = TextEditingController();

  int _selectedTypeIndex = -1;
  bool _isLoading = false;
  List<ResponseTickerSymbolDto> _filteredTickers = [];
  final List<ResponseTickerSymbolDto> _selectedTickers = [];

  void _addTickerToSelected(ResponseTickerSymbolDto ticker) {
    setState(() {
      _selectedTickers.add(ticker);
      _controller.clear(); // Clear the text field after adding
      _filteredTickers = []; // Hide the list
    });
  }

  void _removeTickerFromSelected(ResponseTickerSymbolDto ticker) {
    setState(() {
      _selectedTickers.remove(ticker);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchTextChanged);
    _fetchInitialData();
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
  }

  void _onSearchTextChanged() {
    final query = _controller.text.toLowerCase();

    final provider = Provider.of<TickerSymbolProvider>(context, listen: false);
    final allTickers = provider.tickers;

    setState(() {
      _filteredTickers = allTickers.where((ticker) {
        return ticker.equityName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchTextChanged);
    _controller.dispose(); // 메모리 누수 방지를 위해 컨트롤러 해제
    super.dispose();
  }

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
                                color: AppColors.gray400,
                              ),
                            ),
                            onDeleted: () {
                              _removeTickerFromSelected(ticker);
                            },
                            deleteIcon: const Icon(Icons.close),
                            deleteIconColor: const Color(0xFFACB2B5),
                            backgroundColor: AppColors.backgroundGray,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(600),
                              side: const BorderSide(
                                color: AppColors.backgroundGray,
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
                      color: AppColors.backgroundGray,
                      width: 1,
                    ))),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                    child: Container(
                      child: Column(
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
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controllerKIB,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    NumberRangeTextInputFormatter(min: 0, max: 100),
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: "최대 KI 낙인배리어",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFFACB2B5),
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: AppColors.backgroundGray,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _controllerCoupon,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                    NumberRangeTextInputFormatter(min: 0, max: 100),
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: "최소 수익률",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFFACB2B5),
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: AppColors.backgroundGray,
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
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "상품종류",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray600,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 86,
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
                                    backgroundColor: _selectedTypeIndex == index ? const Color(0xFF1C6BF9) : AppColors.backgroundGray,
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  // _buildCheckboxes(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // 저장 버튼 기능 구현
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: const Color(0xFF1C6BF9),
          ),
          child: const Text(
            '관심 상품 알림 저장',
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
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '기초자산명을 검색해보세요',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray400,
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
        if (_controller.text.isNotEmpty && !_isLoading)
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
                    _controller.text = ticker.equityName;
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
