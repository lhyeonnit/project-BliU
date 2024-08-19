//가입완료
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../login/login_screen.dart';

class JoinCompleteScreen extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 중앙에 이미지 추가
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/join_complete_image.png'), // 이미지 경로 설정
            ),
            SizedBox(height: 24.0),
            Text(
              '회원가입이 완료되었습니다.',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '블리유의 회원이 되신 걸 환영합니다!',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
