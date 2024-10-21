//회원가입 약관 동의
import 'package:BliU/screen/mypage/component/bottom/component/terms_detail.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'join_form_screen.dart';

class JoinAgreeScreen extends StatefulWidget {
  const JoinAgreeScreen({super.key});

  @override
  State<JoinAgreeScreen> createState() => _JoinAgreeScreenState();
}

class _JoinAgreeScreenState extends State<JoinAgreeScreen> {
  bool _serviceAgreement = false;
  bool _privacyPolicy = false;
  bool _ageConfirmation = false;
  bool _allAgreed = false;

  void _updateAllAgreed(bool? value) {
    setState(() {
      _allAgreed = value!;
      _serviceAgreement = value;
      _privacyPolicy = value;
      _ageConfirmation = value;
    });
  }

  void _checkAllAgreed() {
    setState(() {
      _allAgreed = _serviceAgreement && _privacyPolicy && _ageConfirmation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원가입 약관동의',
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
                    '회원가입을 위해 약관에 동의해 주세요!',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: const Color(0xFF7B7B7B),
                      height: 1.2,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAgreementOption(
                      title: '서비스 약관 동의',
                      value: _serviceAgreement,
                      onChanged: (value) {
                        setState(() {
                          _serviceAgreement = value!;
                          _checkAllAgreed();
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsDetail(type: 0),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/images/ic_link.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAgreementOption(
                        title: '개인정보 처리 방침',
                        value: _privacyPolicy,
                        onChanged: (value) {
                          setState(() {
                            _privacyPolicy = value!;
                            _checkAllAgreed();
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsDetail(type: 1),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/ic_link.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildAgreementOption(
                  title: '만 14세 이상입니다.',
                  value: _ageConfirmation,
                  onChanged: (value) {
                    setState(() {
                      _ageConfirmation = value!;
                      _checkAllAgreed();
                    });
                  },
                ),
                _buildAllAgreement(
                  title: '전체 동의합니다.',
                  value: _allAgreed,
                  onChanged: _updateAllAgreed,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0x0D000000),
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 6.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _allAgreed
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JoinFormScreen(),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                    decoration: BoxDecoration(
                      color: _allAgreed ? Colors.black : const Color(0xFFDDDDDD),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '다음',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: _allAgreed ? Colors.white : const Color(0xFF7B7B7B),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementOption({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
          onChanged(value);
        });
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(6),
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                color:
                value ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
              ),
              color: value ? const Color(0xFFFF6191) : Colors.white,
            ),
            child: SvgPicture.asset(
              'assets/images/check01_off.svg', // 체크박스 아이콘
              colorFilter: ColorFilter.mode(
                value ? Colors.white : const Color(0xFFCCCCCC),
                BlendMode.srcIn,
              ),
              height: 10,
              width: 10,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllAgreement({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
          onChanged(value);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(6),
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  color: value ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                ),
                color: value ? const Color(0xFFFF6191) : Colors.white,
              ),
              child: SvgPicture.asset(
                'assets/images/check01_off.svg', // 체크박스 아이콘
                colorFilter: ColorFilter.mode(
                  value ? Colors.white : const Color(0xFFCCCCCC),
                  BlendMode.srcIn,
                ),
                height: 10,
                width: 10,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 16),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
