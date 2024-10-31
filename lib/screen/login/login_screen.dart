import 'dart:io';

import 'package:BliU/screen/recommend_info/recommend_info_screen.dart';
import 'package:BliU/screen/join_agree/join_agree_screen.dart';
import 'package:BliU/screen/find_id_complete/find_id_complete_screen.dart';
import 'package:BliU/screen/find_id/find_id_screen.dart';
import 'package:BliU/screen/find_password/find_password_screen.dart';
import 'package:BliU/screen/login/view_model/login_view_model.dart';
import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/non_order/non_order_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//로그인
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _isAutoLogin = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      loginViewModelProvider,
      ((previous, next) {
        if (next != null) {
          _loginResult(next);
        }
      }),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/images/home/bottom_home.svg",
                    width: 90,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                  child: Column(
                    children: [
                      TextField(
                        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                        style: TextStyle(
                            decorationThickness: 0,
                            height: 1.2,
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14)
                        ),
                        controller: _idController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                          hintText: '아이디 입력',
                          hintStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: const Color(0xFF595959),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          style: TextStyle(
                            height: 1.2,
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                          ),
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                            hintText: '비밀번호 입력',
                            hintStyle: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: const Color(0xFF595959),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: Color(0xFFE1E1E1)
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAutoLogin = !_isAutoLogin;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(6),
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                border: Border.all(
                                  color: _isAutoLogin
                                      ? const Color(0xFFFF6191)
                                      : const Color(0xFFCCCCCC),
                                ),
                                color: _isAutoLogin
                                    ? const Color(0xFFFF6191)
                                    : Colors.white,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/check01_off.svg', // 체크박스 아이콘
                                colorFilter: ColorFilter.mode(
                                  _isAutoLogin ? Colors.white : const Color(0xFFCCCCCC),
                                  BlendMode.srcIn,
                                ),
                                height: 10,
                                width: 10,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            '자동로그인',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // 로그인 버튼 동작
                          _login(context);
                        },
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.only(top: 15),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child: Text(
                              '로그인',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: Colors.white,
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // 회원가입 버튼 동작
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JoinAgreeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(color: Color(0xFFDDDDDD))
                          )
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          // 아이디찾기 버튼 동작
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FindIdScreen(),
                            ),
                          );

                          if (result != null) {
                            if(!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindIdCompleteScreen(id: result,),
                              ),
                            );
                          }
                        },
                        child: Text(
                          '아이디찾기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 비밀번호찾기 버튼 동작
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '비밀번호찾기',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Center(
                          child: Text(
                            'SNS 로그인',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.getFont(context, 15),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: ClipOval(
                                child: SvgPicture.asset('assets/images/login/sns_k.svg')
                            ),
                            iconSize: 60,
                            onPressed: () {
                              _kakaoLogin();
                            },
                          ),
                          IconButton(
                            icon: ClipOval(
                                child: SvgPicture.asset('assets/images/login/sns_n.svg')
                            ),
                            iconSize: 60,
                            onPressed: () {
                              _naverLogin();
                            },
                          ),
                          Visibility(
                            visible: Platform.isIOS ? true : false,
                            child: IconButton(
                              icon: ClipOval(
                                  child: SvgPicture.asset('assets/images/login/sns_a.svg')
                              ),
                              iconSize: 60,
                              onPressed: () {
                                _appleLogin();
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NonOrderScreen()), // 비회원일 때의 화면
                      );
                    },
                    child: Text(
                      '비회원 배송조회',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        if (kDebugMode) {
          print('카카오톡으로 로그인 실패 $error');
        }

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
          if (kDebugMode) {
            print('카카오계정으로 로그인 실패 $error');
          }
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        //print('카카오계정으로 로그인 성공');
        await _kakaoGetInfo();
      } catch (error) {
        if (kDebugMode) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    }
  }

  Future<void> _kakaoGetInfo() async {
    try {
      var user = await UserApi.instance.me();
      final pref = await SharedPreferencesManager.getInstance();
      Map<String, dynamic> data = {
        'id': user.id.toString(),
        'name': user.kakaoAccount?.profile?.nickname ?? "",
        'app_token': pref.getToken(),
        'login_type': '3'
      };

      await pref.setAutoLogin(true);

      await ref.read(loginViewModelProvider.notifier).authSnsLogin(data);
    } catch (error) {
      if (kDebugMode) {
        print('사용자 정보 요청 실패 $error');
      }
    }
  }

  //네이버 로그인
  Future<void> _naverLogin() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      if (result.status == NaverLoginStatus.loggedIn) {
        final pref = await SharedPreferencesManager.getInstance();
        Map<String, dynamic> data = {
          'id': result.account.id,
          'name': result.account.name,
          'app_token': pref.getToken(),
          'login_type': '2'
        };

        await pref.setAutoLogin(true);

        await ref.read(loginViewModelProvider.notifier).authSnsLogin(data);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  //애플 로그인
  Future<void> _appleLogin() async {
    final userCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (kDebugMode) {
      print('credential.state = $userCredential');
      print('credential.state = ${userCredential.email}');
      print('credential.state = ${userCredential.userIdentifier}');
      print('credential.state = ${userCredential.familyName}');
      print('credential.state = ${userCredential.givenName}');
    }

    final id = userCredential.userIdentifier;
    final name = "${userCredential.familyName ?? ""}${userCredential.givenName ?? ""}";

    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'app_token': pref.getToken(),
      'login_type': '4'
    };
    await pref.setAutoLogin(true);

    await ref.read(loginViewModelProvider.notifier).authSnsLogin(data);

    // AppleAuthProvider appleProvider = AppleAuthProvider();
    // appleProvider = appleProvider.addScope('email');
    // appleProvider = appleProvider.addScope('name');
    // final userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    // var user = userCredential.user;
    // if (user != null) {
    //   final pref = await SharedPreferencesManager.getInstance();
    //   Map<String, dynamic> data = {
    //     'id': user.uid,
    //     'name': user.displayName,
    //     'app_token': pref.getToken(),
    //     'login_type': '4'
    //   };
    //   await pref.setAutoLogin(true);
    //
    //   await ref.read(loginViewModelProvider.notifier).authSnsLogin(data);
    // }
  }

  void _login(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final pref = await SharedPreferencesManager.getInstance();
    String? appToken = pref.getToken();
    if (_idController.text.isEmpty) {
      if (!context.mounted) return;
      Utils.getInstance().showSnackBar(context, "아이디를 입력해 주세요");
      return;
    }

    if (_passwordController.text.isEmpty) {
      if (!context.mounted) return;
      Utils.getInstance().showSnackBar(context, "비밀번호를 입력해 주세요");
      return;
    }

    final autoLogin = _isAutoLogin ? "Y" : "N";
    Map<String, dynamic> data = {
      'id': _idController.text,
      'pwd': _passwordController.text,
      'mt_app_token': appToken,
      'auto_login': autoLogin,
    };

    await pref.setAutoLogin(_isAutoLogin);

    await ref.read(loginViewModelProvider.notifier).login(data);
  }

  void _loginResult(LoginModel model) async {
    if (model.memberInfoResponseDTO != null) {
      final pref = await SharedPreferencesManager.getInstance();
      if (model.memberInfoResponseDTO?.result == true) {
        // 로그인 성공 시 처리
        final loginData = model.memberInfoResponseDTO?.data;
        if (loginData != null) {
          await pref.login(loginData);
          final childCk = loginData.childCk ?? "N"; // childCk 값 가져오기

          if (mounted) {
            if (childCk == "Y") {
              // childCk가 "Y"인 경우 메인 화면으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
              ref.read(mainScreenProvider.notifier).selectNavigation(2); // 네비게이션 선택
            } else {
              // childCk가 "N"인 경우 RecommendInfoScreen으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RecommendInfoScreen()),
              );
            }
            return;
          }
        }
      }

      // 로그인 실패 시 처리
      pref.setAutoLogin(false);
      Future.delayed(Duration.zero, () {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, model.memberInfoResponseDTO?.message ?? "로그인 실패");
      });
    }
  }
}
