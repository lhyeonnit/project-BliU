import 'package:BliU/screen/category/category_screen.dart';
import 'package:BliU/screen/home/home_screen.dart';
import 'package:BliU/screen/like/like_screen.dart';
import 'package:flutter/material.dart';

import 'package:BliU/screen/mypage/my_screen.dart';
import 'package:BliU/screen/store/store_screen.dart';
import '_component/custom_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? _backButtonPressedTime;
  int _selectedIndex = 2;

  final List<Widget> _widgetOptions = <Widget>[
    const StoreScreen(),
    const LikeScreen(),
    const HomeScreen(),
    const CategoryScreen(),
    const MyScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        _backButtonPressedTime == null ||
            currentTime.difference(_backButtonPressedTime!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      _backButtonPressedTime = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("한번 더 뒤로가기를 누르면 종료됩니다."),
          duration: Duration(seconds: 3),
        ),
      );
      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(  // WillPopScope로 뒤로가기 동작 제어
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}