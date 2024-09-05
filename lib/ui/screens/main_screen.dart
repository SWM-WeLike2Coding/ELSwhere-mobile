import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/screens/more_screen.dart';
import 'package:elswhere/ui/screens/product_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar_widget.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  DateTime? lastPressed;

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

  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    if (lastPressed == null ||
        now.difference(lastPressed!) > const Duration(seconds: 2)) {
      lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '한 번 더 누르면 종료됩니다.',
            style: textTheme.displayMedium
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return true; // Prevent pop
    }
    return false; // Allow pop
  }

  @override
  Future<bool> didPopRoute() async {
    final result = await _onWillPop();
    return result;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
