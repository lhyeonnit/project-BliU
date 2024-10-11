import 'package:BliU/screen/join/join_agree_screen.dart';
import 'package:BliU/screen/login/find_id_complete_screen.dart';
import 'package:BliU/screen/login/find_id_screen.dart';
import 'package:BliU/screen/login/find_password_screen.dart';
import 'package:BliU/screen/login/viewmodel/login_screen_view_model.dart';
import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

//로그인
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _isAutoLogin = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      loginViewModelProvider,
      ((previous, next) {
        if (next?.memberInfoResponseDTO != null) {
          if (next?.memberInfoResponseDTO?.result == true) {
            //print('로그인 성공 == ${next?.memberInfoResponseDTO?.data?.toJson()}');
            SharedPreferencesManager.getInstance().then((pref) {
              final mtIdx = next?.memberInfoResponseDTO?.data?.mtIdx.toString();  // 서버에서 받은 비밀번호 토큰
              if (mtIdx != null && mtIdx.isNotEmpty) {
                pref.setMtIdx(mtIdx).then((_) {
                  // TODO 뷰 이동 처리
                  // if(!context.mounted) return;
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const RecommendInfoScreen()),
                  // );
                });
              }
            });
          } else {
            Future.delayed(Duration.zero, () {
              Utils.getInstance().showSnackBar(context, next?.memberInfoResponseDTO?.message ?? "");
            });
          }
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
      body: SingleChildScrollView(
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
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                      ),
                      controller: _idController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                        hintText: '아이디 입력',
                        hintStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: const Color(0xFF595959)),
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
                        style: TextStyle(
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
                            color: const Color(0xFF595959)
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
                              },
                            );
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
                        IconButton(
                          icon: ClipOval(
                            child: SvgPicture.asset('assets/images/login/sns_a.svg')
                          ),
                          iconSize: 60,
                          onPressed: () {
                            _appleLogin();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO 비회원 배송조회 동작
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
      )
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
      await ref.read(loginViewModelProvider.notifier).authSnsLogin(data);
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
    if(!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
    setState(() {
      ref.read(mainScreenProvider.notifier).selectNavigation(2);
    });
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
        await ref.read(loginViewModelProvider.notifier).authSnsLogin(data);
      }
    } catch (error) {
      print(error);
    }
    if(!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
    setState(() {
      ref.read(mainScreenProvider.notifier).selectNavigation(2);
    });
  }

  //애플 로그인

  Future<void> _appleLogin() async {
    AppleAuthProvider appleProvider = AppleAuthProvider();
    appleProvider = appleProvider.addScope('email');
    appleProvider = appleProvider.addScope('name');
    // the line below will start the Apple sign in flow for your platform
    final userCredential =
        await FirebaseAuth.instance.signInWithProvider(appleProvider);
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

      await ref.read(loginViewModelProvider.notifier).authSnsLogin(data);
    }

    if(!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
    setState(() {
      ref.read(mainScreenProvider.notifier).selectNavigation(2);
    });
  }

  void _login(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final pref = await SharedPreferencesManager.getInstance();
    String? appToken = pref.getToken();
    if (_idController.text.isEmpty) {
      if(!context.mounted) return;
      Utils.getInstance().showSnackBar(context, "아이디를 입력해 주세요");
      return;
    }

    if (_passwordController.text.isEmpty) {
      if(!context.mounted) return;
      Utils.getInstance().showSnackBar(context, "비밇번호를 입력해 주세요");
      return;
    }

    final autoLogin = _isAutoLogin ? "Y" : "N";
    Map<String, dynamic> data = {
      'id': _idController.text,
      'pwd': _passwordController.text,
      'mt_app_token': appToken,
      'auto_login': autoLogin,
    };

    await ref.read(loginViewModelProvider.notifier).login(data);
  }
}
