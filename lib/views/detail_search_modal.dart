import 'package:elswhere/resources/app_resource.dart';
import 'package:flutter/material.dart';

class DetailSearchModal extends StatelessWidget {
  const DetailSearchModal({super.key});

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
                      '상세 검색',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildSearchInput(),
                    SizedBox(height: 16),
                    _buildTagButtons(),
                    SizedBox(height: 16),
                    _buildDropDowns(),
                    SizedBox(height: 16),
                    _buildCheckboxes(),
                    SizedBox(height: 16),
                    _buildDatePickers(context),
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
    return TextField(
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
    );
  }

  Widget _buildTagButtons() {
    return Wrap(
      spacing: 8.0,
      children: [
        Chip(
          label: Text('항목'),
          deleteIcon: Icon(Icons.close),
          onDeleted: () {},
        ),
        Chip(
          label: Text('항목'),
          deleteIcon: Icon(Icons.close),
          onDeleted: () {},
        ),
      ],
    );
  }

  Widget _buildDropDowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdownWithIcon('최소'),
        Text('~'),
        _buildDropdownWithIcon('최대'),
      ],
    );
  }

  Widget _buildDropdownWithIcon(String hint) {
    return Expanded(
      child: Row(
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
    );
  }

  Widget _buildCheckboxes() {
    return Wrap(
      spacing: 16.0,
      children: [
        _buildCheckboxButton('스텝 다운형'),
        _buildCheckboxButton('낙아웃형', isChecked: true),
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

  Widget _buildDatePickers(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateButton(context, '시작일'),
        Text('~'),
        _buildDateButton(context, '마감일'),
      ],
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
