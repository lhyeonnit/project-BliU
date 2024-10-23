import 'dart:async';
import 'dart:io';

import 'package:BliU/screen/_component/custom_bottom_navigation_bar.dart';
import 'package:BliU/screen/category/category_screen.dart';
import 'package:BliU/screen/home/home_screen.dart';
import 'package:BliU/screen/like/like_screen.dart';
import 'package:BliU/screen/mypage/my_screen.dart';
import 'package:BliU/screen/store/store_screen.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    _initDeepLinks();
  }

  void _onItemTapped(int index) {
    ref.read(mainScreenProvider.notifier).selectNavigation(index);
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
      //String uriString = uri.toString();
      // if (uriString.contains("bplusapp.app.open?act=url&data=")) {
      //   var uriArr = uriString.split("bplusapp.app.open?act=url&data=");
      //   if (uriArr.isNotEmpty) {
      //     if (uriArr.length >= 2) {
      //       String moveUri = uriArr[1];
      //       if (!_visible) {
      //         _webViewController.loadRequest(Uri.parse(moveUri));
      //       } else {
      //         _saveDeepLink = moveUri;
      //       }
      //     }
      //   }
      // }
    });
  }

  Future<void> _backPressed() async {
    if (Platform.isAndroid) { // 안드로이드 경우일때만
      DateTime currentTime = DateTime.now();

      //Statement 1 Or statement2
      bool backButton = _backButtonPressedTime == null ||
          currentTime.difference(_backButtonPressedTime!) > const Duration(seconds: 3);

      if (backButton) {
        _backButtonPressedTime = currentTime;
        Utils.getInstance().showSnackBar(context, "한번 더 뒤로가기를 누를 시 종료됩니다");
        return;
      }

      SystemNavigator.pop();
    }
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

    return PopScope(  // WillPopScope로 뒤로가기 동작 제어
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        _backPressed();
      },
      //onWillPop: _onWillPop,
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