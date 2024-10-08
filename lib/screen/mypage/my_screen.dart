import 'package:BliU/data/member_info_data.dart';
import 'package:BliU/main.dart';
import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/faq_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/non_order_page.dart';
import 'package:BliU/screen/mypage/component/bottom/notice_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/recommend_edit.dart';
import 'package:BliU/screen/mypage/component/bottom/service_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/setting_screen.dart';
import 'package:BliU/screen/mypage/component/top/alarm_screen.dart';
import 'package:BliU/screen/mypage/component/top/component/my_info.dart';
import 'package:BliU/screen/mypage/component/top/my_coupon_screen.dart';
import 'package:BliU/screen/mypage/component/top/my_review_screen.dart';
import 'package:BliU/screen/mypage/component/top/order_list_screen.dart';
import 'package:BliU/screen/mypage/component/top/point_screen.dart';
import 'package:BliU/screen/mypage/non_top_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/my_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  String? userId;
  MemberInfoData? memberInfoData;
  int? myReviewCount;
  int? myCouponCount;
  int? myPoint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }
  @override
  Widget build(BuildContext context) {

    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
      onFocusLost: _viewWillDisappear,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          // 기본 뒤로가기 버튼을 숨김
          title: const Text('마이페이지'),
          titleTextStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 18),
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.2,
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
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                        fontSize: Responsive.getFont(context, 12),
                        height: 1.2,
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
            Visibility(
              visible: userId != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: MyInfo(
                        memberInfoData: memberInfoData,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildIconButton(context, '주문·배송',
                            'assets/images/my/mypage_ic01.svg', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const OrderListScreen()),
                              );
                            }, ''),
                        _buildIconButton(context, '나의리뷰',
                            'assets/images/my/mypage_ic02.svg', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const MyReviewScreen()),
                              );
                            }, '$myReviewCount'),
                        _buildIconButton(context, '쿠폰함',
                            'assets/images/my/mypage_ic03_1.svg', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const MyCouponScreen()),
                              );
                            }, '$myCouponCount'),
                        _buildIconButton(context, '포인트',
                            'assets/images/my/mypage_ic04.svg', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PointScreen()),
                              );
                            }, '$myPoint'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
                visible: userId == null, child: NonTopScreen()),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              width: double.infinity,
              color: const Color(0xFFF5F9F9), // 색상 적용
              height: 10,
            ),
            _buildSection(context, '쇼핑정보'),
            Visibility(
              visible: userId != null,
              child: _buildSectionItem(
                context,
                '추천정보관리',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecommendEdit()),
                  );
                },
              ),
            ),
            Visibility(
              visible: userId == null,
              child: _buildSectionItem(context, '주문 내역 보기', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NonOrderPage()), // 비회원일 때의 화면
                );
              }),
            ),
            const SizedBox(
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
            Visibility(
              visible: userId != null,
              child: GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 16),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  void _viewWillAppear(BuildContext context)  {
    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx();
      if (mtIdx != null && mtIdx.isNotEmpty) {
        Map<String, dynamic> requestData = {
          'mt_idx': mtIdx,
        };
        ref.read(myModelProvider.notifier).getMy(requestData);
      }
    });
  }

  void _viewWillDisappear() {
    print("viewWillDisappear");
  }

  void _afterBuild(BuildContext context) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
    };
    final memberInfoDTO = await ref.read(myModelProvider.notifier).getMy(requestData);
    memberInfoData = memberInfoDTO?.data;
    myCouponCount = memberInfoDTO?.data?.myCouponCount;
    myPoint = memberInfoDTO?.data?.myPoint;
    myReviewCount = memberInfoDTO?.data?.myRevieCount;
    userId = mtIdx;
  }

  Widget _buildSection(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 14),
          color: const Color(0xFFA4A4A4),
          height: 1.2,
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
        margin: const EdgeInsets.only(bottom: 20),
        // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 15),
                color: Colors.black,
                fontWeight: FontWeight.w400,
                height: 1.2,
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

  Widget _buildIconButton(BuildContext context, String label, String icon,
      VoidCallback onPressed, String num) {
    return Column(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            icon,
            width: 40,
            height: 40,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 16),
            height: 1.2,
          ),
        ),
        Text(
          num,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
