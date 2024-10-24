import 'dart:async';

import 'package:BliU/data/my_page_info_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/screen/mypage/my_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/my_info_edit_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class MyInfoDeletePage extends ConsumerStatefulWidget {
  const MyInfoDeletePage({super.key});

  @override
  ConsumerState<MyInfoDeletePage> createState() => MyInfoDeletePageState();
}

class MyInfoDeletePageState extends ConsumerState<MyInfoDeletePage> {
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('회원탈퇴'),
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
              margin: const EdgeInsets.only(top: 40, bottom: 90),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '탈퇴 시 삭제/유지되는 정보를 확인하세요.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 20),
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 30),
                    child: Text(
                      '한번 삭제된 정보는 복구가 불가능합니다.',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF7B7B7B),
                        height: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '계정 삭제',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            height: 1.2,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '포인트, 쿠폰 삭제',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          '내 평점, 리뷰 삭제',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildAllAgreement(
                    title: '확인했습니다.',
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
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
                color: Colors.white,
                child: GestureDetector(
                  onTap: () => _retire(),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.only(
                        right: 16.0, left: 16, top: 9, bottom: 8),
                    decoration: BoxDecoration(
                      color: _isChecked ? Colors.black : const Color(0xFFDDDDDD),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: _isChecked ? Colors.white : const Color(0xFF7B7B7B),
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
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
    );
  }
  void _retire() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
    };
    final resultDTO = await ref.read(myInfoEditViewModelProvider.notifier).retire(requestData);
    if (!mounted) return;
    Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
    await pref.logOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );

    setState(() {
      ref.read(mainScreenProvider.notifier).selectNavigation(2);
    });
  }
}
