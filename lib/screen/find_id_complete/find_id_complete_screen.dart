import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FindIdCompleteScreen extends StatelessWidget {
  const FindIdCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Get.parameters["id"].toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
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
      ),
      body: SafeArea(
        child: Utils.getInstance().isWebView(
          Stack(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 155),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F9F9),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/check01_off.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25, bottom: 10),
                      child: EasyRichText(
                        "회원님의 아이디는 $userId 입니다.",
                        patternList: [
                          EasyRichTextPattern(
                            targetString: "회원님의 아이디는 ",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          EasyRichTextPattern(
                            targetString: userId,
                            style: TextStyle(
                              color: const Color(0xFFFF6192),
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          EasyRichTextPattern(
                            targetString: " 입니다.",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '아이디 찾기가 완료되었습니다. 로그인해 주세요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
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
                  height: 48,
                  margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/find_password");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              border: Border.all(color: const Color(0xFFDDDDDD)),
                            ),
                            margin: const EdgeInsets.only(right: 4),
                            child: Center(
                              child: Text(
                                '비밀번호 찾기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            margin: const EdgeInsets.only(left: 4),
                            child: Center(
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
