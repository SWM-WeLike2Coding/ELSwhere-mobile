import 'package:elswhere/ui/screens/more_screen.dart';
import 'package:elswhere/ui/screens/product_screen.dart';
import 'package:elswhere/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar_widget.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ProductScreen(),
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        changeIndex: _onItemTapped,
      ),
    );
  }
}
