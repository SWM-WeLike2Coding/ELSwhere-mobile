import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';


class AlarmSettingModal extends StatefulWidget {
  const AlarmSettingModal({super.key});

  @override
  State<AlarmSettingModal> createState() => _AlarmSettingModalState();
}

class _AlarmSettingModalState extends State<AlarmSettingModal> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _chips = [];

  void _addChip() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _chips.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _deleteChip(String chip) {
    setState(() {
      _chips.remove(chip);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsetsAll4,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '조건등록',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    SizedBox(height: 16),
                    // _buildTagButtons(),
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
                  ],
                ),
              ),
            ),
            _buildConfirmButton(context),
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
            controller: _controller,
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
            print("hello");
          },
          child: Text('추가'),
        ),
      ],
    );
  }

  Widget _buildDropDowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdownWithIcon('최대 KI(낙인 배리어)', '최소'),
        SizedBox(width: 20,),
        Text('~'),
        SizedBox(width: 20,),
        _buildDropdownWithIcon('최소수익률', '최대'),
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
              Icon(Icons.search),
              SizedBox(width: 8),
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
    return Wrap(
      spacing: 16.0,
      children: [
        _buildCheckboxButton('스텝 다운형'),
        _buildCheckboxButton('낙아웃형'),
        _buildCheckboxButton('월지급형'),
        _buildCheckboxButton('리자드형'),
      ],
    );
  }

  Widget _buildCheckboxButton(String label, {bool isChecked = false}) {
    return FilterChip(
      label: Text(label),
      selected: isChecked,
      onSelected: (bool selected) {},
    );
  }

  Widget _buildDateButton(BuildContext context, String label) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            print(pickedDate); // 선택된 날짜를 처리하는 로직
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
        ),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('확인'),
      ),
    );
  }
}
