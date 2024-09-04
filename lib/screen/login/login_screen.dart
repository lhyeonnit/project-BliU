//로그인
import 'package:BliU/screen/join/join_agree_screen.dart';
import 'package:BliU/screen/login/viewmodel/login_screen_view_model.dart';
import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'find_id_screen.dart';
import 'find_password_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginScreenViewModel = ref.read(loginViewModelProvider.notifier);
    ref.listen(
      loginViewModelProvider,
      ((previous, next) {
        if (next?.memberInfoResponseDTO != null) {
          if (next?.memberInfoResponseDTO?.result == true) {
            print('로그인 성공 == ${next?.memberInfoResponseDTO?.data?.toJson()}');
            // TODO
          } else {
            Utils.getInstance().showSnackBar(context, next?.memberInfoResponseDTO?.message ?? "");
          }
        }
      }),
    );
    
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
                  builder: (context) => const MainScreen(),
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
                _login(loginScreenViewModel);
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

  Future<void> _kakaoLogin() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        //print('카카오톡으로 로그인 성공');
        await _kakaoGetInfo();
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          //print('카카오계정으로 로그인 성공');
          await _kakaoGetInfo();
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        //print('카카오계정으로 로그인 성공');
        await _kakaoGetInfo();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  Future<void> _kakaoGetInfo() async {
    // 사용자 정보 재요청
    try {
      var user = await UserApi.instance.me();
      // print('사용자 정보 요청 성공'
      //     '\n회원번호: ${user.id}'
      //     '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
      //     '\n이메일: ${user.kakaoAccount?.email}'
      //     '\n폰번호: ${user.kakaoAccount?.phoneNumber}');

      var shared = await SharedPreferencesManager.getInstance();
      Map<String, dynamic> data = {
        'id': user.id.toString(),
        'name': user.kakaoAccount?.profile?.nickname ?? "",
        'app_token': shared.getToken(),
        'login_type': '3'
      };

      _snsLogin(data);
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  //네이버 로그인
  Future<void> _naverLogin() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      if (result.status == NaverLoginStatus.loggedIn) {
        // print('accessToken = ${result.accessToken}');
        // print('id = ${result.account.id}');
        // print('name = ${result.account.name}');
        // print('nickname = ${result.account.nickname}');
        // print('email = ${result.account.email}');
        // print('mobile = ${result.account.mobile}');

        var shared = await SharedPreferencesManager.getInstance();
        Map<String, dynamic> data = {
          'id': result.account.id,
          'name': result.account.name,
          'app_token': shared.getToken(),
          'login_type': '2'
        };

        _snsLogin(data);
      }
    } catch (error) {
      print(error);
    }
  }

  //애플 로그인

  Future<void> _appleLogin() async {
    AppleAuthProvider appleProvider = AppleAuthProvider();
    appleProvider = appleProvider.addScope('email');
    appleProvider = appleProvider.addScope('name');
    // the line below will start the Apple sign in flow for your platform
    final userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    var user = userCredential.user;
    if (user != null) {
      // print("user.uid == ${user.uid}");
      // print("user.displayName == ${user.displayName}");
      // print("user.email == ${user.email}");

      var shared = await SharedPreferencesManager.getInstance();
      Map<String, dynamic> data = {
        'id': user.uid,
        'name': user.displayName,
        'app_token': shared.getToken(),
        'login_type': '4'
      };

      _snsLogin(data);
    }
  }

  // TODO
  void _login(LoginScreenViewModel model) {
    Map<String, dynamic> data = {
      'id': 'test1',
      'pwd': 'test1234!',
      'auto_login': 'Y'
    };

    model.authLogin(data);
  }
  // TODO
  void _snsLogin(Map<String, dynamic> data) {

  }
}
