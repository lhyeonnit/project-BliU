import 'package:BliU/main.dart';
import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/faq_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/non_order_page.dart';
import 'package:BliU/screen/mypage/component/bottom/notice_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/setting_screen.dart';
import 'package:BliU/screen/mypage/component/top/alarm_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/recommend_edit.dart';
import 'package:BliU/screen/mypage/component/bottom/service_screen.dart';
import 'package:BliU/screen/mypage/non_top_screen.dart';
import 'package:BliU/screen/mypage/top_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/my_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(myModelProvider);
    final mtIdx = ref.watch(sharedPreferencesProvider).getString('mtIdx');
    return FocusDetector(
      onFocusGained: () {
        viewWillAppear(ref, context);
      },
      onFocusLost: viewWillDisappear,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          // 기본 뒤로가기 버튼을 숨김
          title: const Text('마이페이지'),
          titleTextStyle: TextStyle(
            fontSize: Responsive.getFont(context, 18),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
            child: Container(
              color: const Color(0xFFF4F4F4), // 하단 구분선 색상
              height: 1.0, // 구분선의 두께 설정
              child: Container(
                height: 1.0, // 그림자 부분의 높이
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFF4F4F4),
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/images/my/ic_alim.svg'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmScreen()),
                );
              },
            ),
            Stack(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  icon: SvgPicture.asset("assets/images/product/ic_cart.svg"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                ),
                Positioned(
                  right: 10,
                  top: 20,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.getFont(context, 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mtIdx != null && mtIdx.isNotEmpty
                ? TopScreen() // 로그인된 상태
                : NonTopScreen(), // 비회원/비로그인 상태
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 30),
              width: double.infinity,
              color: const Color(0xFFF5F9F9), // 색상 적용
              height: 10,
            ),
            _buildSection(context, '쇼핑정보'),
            mtIdx != null && mtIdx.isNotEmpty
                ? _buildSectionItem(context, '추천정보관리', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RecommendEdit()),
              );
            })
                : _buildSectionItem(context, '주문 내역 보기', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NonOrderPage()), // 비회원일 때의 화면
              );
            }),
            SizedBox(
              height: 10,
            ),
            _buildSection(context, '고객서비스'),
            _buildSectionItem(context, 'FAQ', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              );
            }),
            _buildSectionItem(context, '공지사항', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NoticeScreen()),
              );
            }),
            _buildSectionItem(context, '고객센터', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServiceScreen()),
              );
            }),
            _buildSectionItem(context, '설정', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            }),
            if (mtIdx != null && mtIdx.isNotEmpty)
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                        fontSize: Responsive.getFont(context, 16),
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                onTap: () {
                  // TODO 로그아웃 동작 처리
                  SharedPreferencesManager.getInstance().then((pref) {
                    // pref.clear(); // 저장된 사용자 정보 삭제
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyApp()), // 로그아웃 후 메인화면으로
                    );
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  void viewWillAppear(WidgetRef ref, BuildContext context) {
    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx();
      if (mtIdx != null && mtIdx.isNotEmpty) {
        Map<String, dynamic> requestData = {
          'mt_idx': mtIdx,
        };
        ref.read(myModelProvider.notifier).getMy(requestData);
      } else {
        // 비회원 상태이면 NonTopScreen으로 전환
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NonTopScreen()),
        );
      }
    });
  }

  void viewWillDisappear() {
    print("viewWillDisappear");
  }

  Widget _buildSection(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.getFont(context, 14),
          color: Color(0xFFA4A4A4),
        ),
      ),
    );
  }

  Widget _buildSectionItem(
      BuildContext context, String title, VoidCallback onPressed) {
    return InkWell(
      overlayColor: WidgetStateColor.transparent,
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(bottom: 20),
        // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.getFont(context, 15),
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            SvgPicture.asset(
              'assets/images/ic_link.svg',
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
