//로그인

import 'package:BliU/screen/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../join/join_agree_screen.dart';
import 'find_id_screen.dart';
import 'find_password_screen.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/login/ic_home.svg"),
            onPressed: () {
              // 홈 버튼 눌렀을 때 동작
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: SvgPicture.asset("assets/images/home/bottom_home.svg", width: 90,),
            ),
            const SizedBox(height: 40),
            const TextField(
              decoration: InputDecoration(
                labelText: '아이디 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {
                    // 자동로그인 체크박스 동작
                  },
                ),
                const Text('자동로그인'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 로그인 버튼 동작
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('로그인', style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // 회원가입 버튼 동작
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JoinAgreeScreen(),
                      ),
                    );
                  },
                  child: const Text('회원가입'),
                ),
                const VerticalDivider(color: Colors.black),
                TextButton(
                  onPressed: () {
                    // 아이디찾기 버튼 동작
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindIdScreen(),
                      ),
                    );
                  },
                  child: const Text('아이디찾기'),
                ),
                const VerticalDivider(color: Colors.black),
                TextButton(
                  onPressed: () {
                    // 비밀번호찾기 버튼 동작
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('비밀번호찾기'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'SNS 로그인',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/images/login/sns_k.svg'),
                  iconSize: 50,
                  onPressed: () {
                    // 카카오톡 로그인 동작
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/images/login/sns_n.svg'),
                  iconSize: 50,
                  onPressed: () {
                    // 네이버 로그인 동작
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/images/login/sns_a.svg'),
                  iconSize: 50,
                  onPressed: () {
                    // 애플 로그인 동작
                  },
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  // 비회원 배송조회 동작
                },
                child: const Text('비회원 배송조회'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
