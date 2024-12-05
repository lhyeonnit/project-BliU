import 'package:BliU/data/member_info_data.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/alarm/alarm_screen.dart';
import 'package:BliU/screen/consumer_center/consumer_center_screen.dart';
import 'package:BliU/screen/faq/faq_screen.dart';
import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/main/page_screen/my/child_widget/non_top_child_widget.dart';
import 'package:BliU/screen/main/page_screen/my/view_model/my_view_model.dart';
import 'package:BliU/screen/my_coupon/my_coupon_screen.dart';
import 'package:BliU/screen/my_info_edit/my_info_edit_screen.dart';
import 'package:BliU/screen/my_info_edit_check/my_info_edit_check_screen.dart';
import 'package:BliU/screen/my_point/my_point_screen.dart';
import 'package:BliU/screen/my_review/my_review_screen.dart';
import 'package:BliU/screen/notice/notice_screen.dart';
import 'package:BliU/screen/order_list/order_list_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  void _viewWillAppear(BuildContext context, WidgetRef ref) async {
    final pref = await SharedPreferencesManager.getInstance();
    final memberInfo = pref.getMemberInfo();
    final mtIdx = memberInfo?.mtIdx.toString();

    if (mtIdx != null && mtIdx.isNotEmpty) {
      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
      };
      ref.read(myViewModelProvider.notifier).getMy(requestData);
    } else {
      ref.read(myViewModelProvider.notifier).resetData();
    }
  }

  void logout(WidgetRef ref) async {
    SharedPreferencesManager prefs = await SharedPreferencesManager.getInstance();
    await prefs.logOut(); // 저장된 모든 데이터를 삭제
    ref.read(myViewModelProvider.notifier).resetData();

    // 로그아웃 후 로그인 화면으로 전환
    ref.read(mainScreenProvider.notifier).selectNavigation(2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context, ref);
      },
      child: Consumer(
        builder: (context, ref, widget) {
          String userId = '';
          MemberInfoData? memberInfoData;
          int? myReviewCount;
          int? myCouponCount;
          int? myPoint;
          int? mtLoginType;

          final model = ref.watch(myViewModelProvider);
          final memberInfoResponseDTO = model.memberInfoResponseDTO;

          if (memberInfoResponseDTO != null) {
            memberInfoData = memberInfoResponseDTO.data;
            myCouponCount = memberInfoResponseDTO.data?.myCouponCount;
            myPoint = memberInfoResponseDTO.data?.myPoint;
            myReviewCount = memberInfoResponseDTO.data?.myRevieCount;
            userId = memberInfoResponseDTO.data?.mtIdx.toString() ?? ''; // userId 업데이트
            mtLoginType = memberInfoResponseDTO.data?.mtLoginType ?? 1;

            String? childCk = memberInfoResponseDTO.data?.childCk;
            if (childCk == "N" && context.mounted) {
              Navigator.pushReplacementNamed(context, '/recommend_info');
            }
          }

          return Scaffold(
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
                        builder: (context) => AlarmScreen(),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                      builder: (context) => MyInfoEditCheckScreen(),
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
                                      builder: (context) => const MyPointScreen(),
                                    ),
                                  );
                                }, '$myPoint'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: userId.isEmpty,
                  child: const NonTopChildWidget(),
                ),
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
                      Navigator.pushNamed(context, '/recommend_info_edit');
                    },
                  ),
                ),
                Visibility(
                  visible: userId.isEmpty,
                  child: _buildSectionItem(context, '비회원 주문조회', () {
                    Navigator.pushNamed(context, '/non_order');// 비회원일 때의 화면
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildSection(context, '고객서비스'),
                _buildSectionItem(context, 'FAQ', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FAQScreen(),
                    ),
                  );
                }),
                _buildSectionItem(context, '공지사항', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NoticeScreen(),
                    ),
                  );
                }),
                _buildSectionItem(context, '고객센터', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsumerCenterScreen(),
                    ),
                  );
                }),
                _buildSectionItem(context, '설정', () {
                  Navigator.pushNamed(context, '/setting');
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
                      logout(ref);
                    },
                  ),
                ),
              ],
            ),
          );
        },
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