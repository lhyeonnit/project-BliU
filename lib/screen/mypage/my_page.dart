import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/faq_screen.dart';
import 'package:BliU/screen/mypage/component/bottom/setting_screen.dart';
import 'package:BliU/screen/mypage/component/top/alarm_screen.dart';
import 'package:BliU/screen/mypage/component/top/my_coupon_screen.dart';
import 'package:BliU/screen/mypage/component/top/my_info.dart';
import 'package:BliU/screen/mypage/component/bottom/recommend_edit.dart';
import 'package:BliU/screen/mypage/component/bottom/service_screen.dart';
import 'package:BliU/screen/mypage/component/top/my_review_screen.dart';
import 'package:BliU/screen/mypage/component/top/point_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'component/bottom/notice_screen.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 기본 뒤로가기 버튼을 숨김

        title: const Text('마이페이지'),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/my/ic_alim.svg'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                padding: EdgeInsets.only(right: 10),
                icon: SvgPicture.asset("assets/images/product/ic_cart.svg"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
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
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
          MyInfo(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(
                    '주문·배송', 'assets/images/my/mypage_ic01.svg', () {}, ''),
                _buildIconButton(
                    '나의리뷰', 'assets/images/my/mypage_ic02.svg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyReviewScreen()),
                  );
                }, '100'),
                _buildIconButton(
                    '쿠폰함', 'assets/images/my/mypage_ic03_1.svg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCouponScreen()),
                  );
                }, '2'),
                _buildIconButton('포인트', 'assets/images/my/mypage_ic04.svg', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PointScreen()),
                  );
                }, '200,000'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: Color(0xFFF5F9F9), // 색상 적용
            height: 10,
          ),
          SizedBox(height: 30),
          _buildSection('쇼핑정보'),
          _buildSectionItem('추천정보관리', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecommendEdit()),
            );
          }),
          SizedBox(height: 30),
          _buildSection('고객서비스'),
          _buildSectionItem('FAQ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FAQScreen()),
            );
          }),
          _buildSectionItem('공지사항', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoticeScreen()),
            );
          }),
          _buildSectionItem('고객센터', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServiceScreen()),
            );
          }),
          _buildSectionItem('설정', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: TextButton(
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      String label, String icon, VoidCallback onPressed, String num) {
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
          style: TextStyle(fontSize: 16),
        ),
        Text(
          num,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSectionItem(String title, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
