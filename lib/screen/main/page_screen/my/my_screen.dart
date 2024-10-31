import 'package:BliU/data/member_info_data.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/recommend_info/recommend_info_screen.dart';
import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/faq_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/non_order_page.dart';
import 'package:BliU/screen/mypage/component/bottom/notice_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/recommend_edit.dart';
import 'package:BliU/screen/mypage/component/bottom/service_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/setting_screen.dart';
import 'package:BliU/screen/alarm/alarm_screen.dart';
import 'package:BliU/screen/mypage/component/top/component/my_info_edit_check.dart';
import 'package:BliU/screen/mypage/component/top/my_coupon_screen.dart';
import 'package:BliU/screen/mypage/component/top/my_info_edit_screen.dart';
import 'package:BliU/screen/mypage/component/top/my_review_screen.dart';
import 'package:BliU/screen/mypage/component/top/order_list_screen.dart';
import 'package:BliU/screen/mypage/component/top/point_screen.dart';
import 'package:BliU/screen/main/page_screen/my/child_view/non_top_screen.dart';
import 'package:BliU/screen/main/page_screen/my/view_model/my_view_model.dart';
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
  ConsumerState<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends ConsumerState<MyScreen> {
  String userId = '';
  MemberInfoData? memberInfoData;
  int? myReviewCount;
  int? myCouponCount;
  int? myPoint;
  int? mtLoginType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _viewWillAppear(BuildContext context) {
    _getMy();
  }

  void _afterBuild(BuildContext context) {
    _getMy();
  }

  void _getMy() async {
    final pref = await SharedPreferencesManager.getInstance();
    final memberInfo = pref.getMemberInfo();
    final mtIdx = memberInfo?.mtIdx.toString();
    if (mtIdx != null && mtIdx.isNotEmpty) {
      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
      };
      final memberInfoDTO = await ref.read(myViewModelProvider.notifier).getMy(requestData);
      if (memberInfoDTO?.result == true) {
        setState(() {
          // 상태 변경 후 UI 업데이트
          memberInfoData = memberInfoDTO?.data;
          myCouponCount = memberInfoDTO?.data?.myCouponCount;
          myPoint = memberInfoDTO?.data?.myPoint;
          myReviewCount = memberInfoDTO?.data?.myRevieCount;
          userId = memberInfoDTO?.data?.mtIdx.toString() ?? ''; // userId 업데이트
          mtLoginType = memberInfo?.mtLoginType ?? 1;
        });
        String? childCk = memberInfo?.childCk;
        if (!mounted) return;
        if (childCk == "N") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RecommendInfoScreen(),
            ),
          );
        }
      } else {
        _resetData();
      }
    } else {
      _resetData();
    }
  }

  void _resetData() {
    setState(() {
      memberInfoData = null;
      myCouponCount = null;
      myPoint = null;
      myReviewCount = null;
      userId = ''; // userId 업데이트
      mtLoginType = null;
    });
  }

  void logout() async {
    SharedPreferencesManager prefs =
    await SharedPreferencesManager.getInstance();
    await prefs.logOut(); // 저장된 모든 데이터를 삭제

    _resetData();

    // 로그아웃 후 로그인 화면으로 전환
    ref.read(mainScreenProvider.notifier).selectNavigation(2);
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
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
              color: const Color(0x0D000000), // 하단 구분선 색상
              height: 1.0, // 구분선의 두께 설정
              child: Container(
                height: 1.0, // 그림자 부분의 높이
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 6.0,
                      spreadRadius: 0.1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/images/my/ic_alim.svg',
                height: Responsive.getHeight(context, 30),
                width: Responsive.getWidth(context, 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlarmScreen(),
                  ),
                );
              },
            ),
            const TopCartButton(),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: userId.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFE4DF),
                            ),
                            child: Image.asset('assets/images/my/gender_select_boy.png'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${memberInfoData?.mtName ?? ""}님 안녕하세요',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 18),
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                Text(
                                  memberInfoData?.mtId ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    color: const Color(0xFF7B7B7B),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mtLoginType == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyInfoEditCheck(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyInfoEditScreen(isCommon: false,),
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFDDDDDD)),
                            ),
                            child: Text(
                              '내정보수정',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: Colors.black,
                                fontSize: Responsive.getFont(context, 12),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                              builder: (context) => const OrderListScreen(),
                            ),
                          );
                        }, ''),
                        _buildIconButton(
                            context, '나의리뷰', 'assets/images/my/mypage_ic02.svg',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyReviewScreen(),
                            ),
                          );
                        }, '$myReviewCount'),
                        _buildIconButton(context, '쿠폰함',
                            'assets/images/my/mypage_ic03_1.svg', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyCouponScreen(),
                            ),
                          );
                        }, '$myCouponCount'),
                        _buildIconButton(
                            context, '포인트', 'assets/images/my/mypage_ic04.svg',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PointScreen(),
                            ),
                          );
                        }, '$myPoint'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(visible: userId.isEmpty, child: const NonTopScreen()),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 30),
              width: double.infinity,
              color: const Color(0xFFF5F9F9), // 색상 적용
              height: 10,
            ),
            _buildSection(context, '쇼핑정보'),
            Visibility(
              visible: userId.isNotEmpty,
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
              visible: userId.isEmpty,
              child: _buildSectionItem(context, '비회원 주문조회', () {
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
              visible: userId.isNotEmpty,
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
                  logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildSectionItem(BuildContext context, String title, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 17),
      child: InkWell(
        overlayColor: WidgetStateColor.transparent,
        onTap: onPressed,
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
              height: 11,
              width: 11,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, String label, String icon, VoidCallback onPressed, String num) {
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
