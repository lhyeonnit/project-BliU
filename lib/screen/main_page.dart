import 'package:flutter/material.dart';

import 'package:BliU/screen/category/category_page.dart';
import 'package:BliU/screen/home/home_page.dart';
import 'package:BliU/screen/like/like_page.dart';
import 'package:BliU/screen/mypage/my_page.dart';
import 'package:BliU/screen/store/store_page.dart';

import '_component/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? _backButtonPressedTime;
  int _selectedIndex = 2;

  final List<Widget> _widgetOptions = <Widget>[
    const StorePage(),
    const LikePage(),
    const HomePage(),
    const CategoryPage(),
    const MyPage(),
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
