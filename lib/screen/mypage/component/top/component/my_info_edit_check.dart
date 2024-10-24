import 'package:BliU/screen/mypage/component/top/my_info_edit_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/my_info_edit_check_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyInfoEditCheck extends ConsumerWidget {
  final TextEditingController _passwordController = TextEditingController();

  MyInfoEditCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('내정보수정'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
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
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 정보 수정',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 20),
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 30),
                    child: Text(
                      '본인 확인을 위해 한 번 더 비밀번호를 \n입력해주세요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: const Color(0xFF7B7B7B),
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '비밀번호',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 13),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: Text(
                          '*',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 13),
                            color: const Color(0xFFFF6192),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextField(
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                      obscureText: true,
                      // 비밀번호 입력을 위해 텍스트 숨김
                      style: TextStyle(
                          decorationThickness: 0,
                          height: 1.2,
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14)
                      ),
                      enabled: true,
                      controller: _passwordController,
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
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _passwordCheck(context, ref);
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: Colors.white,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _passwordCheck(BuildContext context, WidgetRef ref) async {
    String password = _passwordController.text;
    if (password.isEmpty) {
      Utils.getInstance().showSnackBar(context, "비밀번호를 입력해 주세요.");
      return;
    }

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'password' : password,
    };

    final myInfoResponseDTO = await ref.read(myInfoEditCheckViewModelProvider.notifier).passwordCheck(requestData);
    if (myInfoResponseDTO != null) {
      if (myInfoResponseDTO.result == true) {
        final authToken = myInfoResponseDTO.data?.authToken;  // 서버에서 받은 비밀번호 토큰
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyInfoEditScreen(authToken: authToken,)),
        );
      } else {
        if (!context.mounted) return;
          Utils.getInstance().showSnackBar(context, myInfoResponseDTO.message ?? "");
      }
    }
  }
}
