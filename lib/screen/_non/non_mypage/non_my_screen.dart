import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/non_order_page.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/non_faq_page.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/non_notice_page.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/non_service_page.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/non_setting_page.dart';
import 'package:BliU/screen/_non/non_mypage/top/non_top.dart';
import 'package:BliU/screen/mypage/component/top/alarm_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class NonMyScreen extends StatelessWidget {
  const NonMyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    MaterialPageRoute(builder: (context) => const CartScreen()),
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
          Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: NonTop(),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 30),
            width: double.infinity,
            color: const Color(0xFFF5F9F9), // 색상 적용
            height: 10,
          ),
          _buildSection(context, '쇼핑정보'),
          _buildSectionItem(context, '비회원 주문조회', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NonOrderPage()),
            );
          }),
          SizedBox(
            height: 10,
          ),
          _buildSection(context, '고객서비스'),
          _buildSectionItem(context, 'FAQ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NonFaqPage()),
            );
          }),
          _buildSectionItem(context, '공지사항', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NonNoticePage()),
            );
          }),
          _buildSectionItem(context, '고객센터', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NonServicePage()),
            );
          }),
          _buildSectionItem(context, '설정', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NonSettingPage()),
            );
          }),
        ],
      ),
    );
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
                fontWeight: FontWeight.w500,
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
