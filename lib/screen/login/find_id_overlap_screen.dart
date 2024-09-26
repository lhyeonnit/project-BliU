import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'find_password_screen.dart';
import 'login_screen.dart';

class FindIdOverlapScreen extends StatelessWidget {
  final String userId = "ID_1234";

  const FindIdOverlapScreen({super.key}); // 찾은 아이디를 여기에 넣습니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 155),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F9F9),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/check01_off.svg',
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25, bottom: 10),
                  child: Text(
                    '이미 SNS 가입이 되어 있습니다.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '중복 가입 불가로 로그인 페이지로 이동합니다.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: Responsive.getHeight(context, 48),
              margin: EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
