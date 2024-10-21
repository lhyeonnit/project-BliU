import 'package:BliU/screen/_component/custom_bottom_navigation_bar.dart';
import 'package:BliU/screen/category/category_screen.dart';
import 'package:BliU/screen/home/home_screen.dart';
import 'package:BliU/screen/like/like_screen.dart';
import 'package:BliU/screen/mypage/my_screen.dart';
import 'package:BliU/screen/store/store_screen.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
    ref.read(mainScreenProvider.notifier).selectNavigation(index);
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
    _selectedIndex = ref.watch(mainScreenProvider) ?? 2;

    SharedPreferencesManager.getInstance().then( (pref) {
      final mtIdx = pref.getMtIdx() ?? "";
      if (mtIdx.isEmpty) {
        ref.read(memberProvider.notifier).isLogin(false);
      } else {
        ref.read(memberProvider.notifier).isLogin(true);
      }
    });

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

final mainScreenProvider = StateNotifierProvider<MainScreenProvider, int?>((ref){
  return MainScreenProvider(null, ref);
});

final memberProvider = StateNotifierProvider<MemberProvider, bool?>((ref){
  return MemberProvider(null, ref);
});

class MainScreenProvider extends StateNotifier<int?> {
  final Ref ref;
  MainScreenProvider(super.state, this.ref);

  void selectNavigation(int index){
    state = index;
  }
}

class MemberProvider extends StateNotifier<bool?> {
  final Ref ref;
  MemberProvider(super.state, this.ref);

  void isLogin(bool isLogin){
    state = isLogin;
  }
}