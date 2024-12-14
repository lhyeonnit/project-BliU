import 'dart:async';
import 'dart:io';

import 'package:BliU/data/fcm_data.dart';
import 'package:BliU/screen/_component/custom_bottom_navigation_bar.dart';
import 'package:BliU/screen/cart/cart_screen.dart';
import 'package:BliU/screen/exhibition/exhibition_screen.dart';
import 'package:BliU/screen/main/page_screen/category/category_screen.dart';
import 'package:BliU/screen/main/page_screen/home/home_screen.dart';
import 'package:BliU/screen/main/page_screen/like/like_screen.dart';
import 'package:BliU/screen/main/page_screen/my/my_screen.dart';
import 'package:BliU/screen/main/page_screen/store/store_screen.dart';
import 'package:BliU/screen/main/view_model/main_view_model.dart';
import 'package:BliU/screen/my_coupon/my_coupon_screen.dart';
import 'package:BliU/utils/firebase_service.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> with SingleTickerProviderStateMixin {
  late PreloadPageController _preloadPageController;
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

  @override
  void initState() {
    super.initState();
    _preloadPageController = PreloadPageController(initialPage: 2);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDeepLinks();
      FirebaseService firebaseService = FirebaseService();
      final fcmData = firebaseService.saveFcmData;
      if (fcmData != null) {
        _pushCheck(fcmData);
        firebaseService.saveFcmData = null;
      }
    });

    _getCategory();
  }

  void _getCategory() {
    ref.read(mainViewModelProvider.notifier).getCategory('1');
    ref.read(mainViewModelProvider.notifier).getCategory('2');
    ref.read(mainViewModelProvider.notifier).getAgeCategory();
    ref.read(mainViewModelProvider.notifier).getStyleCategory();
  }

  void _onItemTapped(int index) {
    ref.read(mainScreenProvider.notifier).selectNavigation(index);
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _appLinks.uriLinkStream.listen((uri) {
      String uriString = uri.toString();
      if (uriString.contains("app.open?act=")) {
        final parameters = uri.queryParameters;
        String act = (parameters['act'] ?? "");
        int idx = int.parse((parameters['data'] ?? "0"));
        if (!mounted) return;
        if (idx == 0) return;
        switch(act) {
          case "product":
            Navigator.pushNamed(context, '/product_detail/$idx');
            break;
          case "exhibition":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExhibitionScreen(etIdx: idx),
              ),
            );
            break;
        }
      }
    });
  }

  Future<void> _backPressed() async {
    if (Platform.isAndroid) { // 안드로이드 경우일때만
      DateTime currentTime = DateTime.now();

      //Statement 1 Or statement2
      bool backButton = _backButtonPressedTime == null || currentTime.difference(_backButtonPressedTime!) > const Duration(seconds: 3);
      if (backButton) {
        _backButtonPressedTime = currentTime;
        Utils.getInstance().showSnackBar(context, "한번 더 뒤로가기를 누를 시 종료됩니다");
        return;
      }

      SystemNavigator.pop();
    }
  }

  void _pushCheck(FcmData fcmData) {
    String? ptLink = fcmData.ptLink;
    int etIdx = int.parse(fcmData.etIdx ?? "0");
    print("ptLink $ptLink");
    print("etIdx $etIdx");
    if (ptLink != null) {
      if (ptLink.isNotEmpty) {
        switch (ptLink) {
          case "home":
            Navigator.popUntil(context, ModalRoute.withName("/index"));
            ref.read(mainScreenProvider.notifier).selectNavigation(2);
            break;
          case "order_list":
            Navigator.pushNamed(context, '/order_list');
            break;
          case "cart_list":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
            break;
          case "coupon_list":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCouponScreen()),
            );
            break;
          case "exhibition":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExhibitionScreen(etIdx: etIdx),
              ),
            );
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(fcmProvider,
      ((previous, next) {
        if (next != null) {
          _pushCheck(next);
          ref.read(fcmProvider.notifier).getFcm(null);
        }
      }),
    );

    _selectedIndex = ref.watch(mainScreenProvider) ?? 2;
    ref.listen(mainScreenProvider,
      ((previous, next) {
        if (next == null) return;
        if (previous != next) {
          _preloadPageController.animateToPage(next, duration: const Duration(milliseconds: 1), curve: Curves.linear);
        }
      }),
    );

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
      child: Utils.getInstance().isWebView(
        Scaffold(
          body: PreloadPageView.builder(
            itemCount: 5,
            preloadPagesCount: 5,
            controller: _preloadPageController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _widgetOptions[index];
            },
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
        isHeight: true
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