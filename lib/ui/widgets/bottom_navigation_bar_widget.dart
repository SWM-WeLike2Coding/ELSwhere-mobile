import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({super.key, required this.changeIndex});

  void Function(int) changeIndex;

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    widget.changeIndex(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sell_outlined),
          label: '상품',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: '더보기',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,

    );
  }
}
