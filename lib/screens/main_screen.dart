import 'package:elswhere/screens/product_screen.dart';
import 'package:elswhere/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar_widget.dart';
import 'home_screen.dart';
import 'my_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    ProductScreen(),
    HomeScreen(),
    MyScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ELSwhere'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
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
