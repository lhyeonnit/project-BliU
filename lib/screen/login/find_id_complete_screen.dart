
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'find_password_screen.dart';
import 'login_screen.dart';

class FindIdCompleteScreen extends StatelessWidget {
  final String userId = "ID_1234"; // 찾은 아이디를 여기에 넣습니다.

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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.check, color: Colors.black, size: 40),
            ),
            SizedBox(height: 24),
            Text(
              '회원님의 아이디는',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'ID_1234', // 실제 찾은 아이디를 여기에 넣습니다.
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '입니다.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '아이디 찾기가 완료되었습니다. 로그인해 주세요.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // 비밀번호 찾기 페이지로 이동하는 로직을 여기에 추가합니다.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FindPasswordScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text('비밀번호 찾기'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 로그인 페이지로 이동하는 로직을 여기에 추가합니다.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
