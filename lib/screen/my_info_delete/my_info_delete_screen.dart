import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/modal_dialog/confirm_dialog.dart';
import 'package:BliU/screen/my_info_edit/view_model/my_info_edit_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyInfoDeleteScreen extends ConsumerStatefulWidget {
  const MyInfoDeleteScreen({super.key});

  @override
  ConsumerState<MyInfoDeleteScreen> createState() => MyInfoDeleteScreenState();
}

class MyInfoDeleteScreenState extends ConsumerState<MyInfoDeleteScreen> {
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
                    child: Text(
                      """블리유를 이용해주셔서 감사합니다.\n\n회원 탈퇴 시 아래 데이터는 복구가 불가합니다:\n- 계정 정보\n- 주문 내역 및 구매 이력\n- 보유 중인 포인트 및 쿠폰\n- 기타 개인화된 서비스 데이터\n\n또한, 탈퇴일로부터 180일 동안 동일한 명의와 연락처로 재가입이 불가합니다.\n\n블리유와 함께했던 순간들이 즐거우셨길 바라며, 더 나은 모습으로 다시 만나 뵙기를 기대하겠습니다.\n\n감사합니다.""",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
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
                  onTap: () {
                    if (_isChecked) {
                      _retire();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
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
  void _retire() {
    showDialog(
      context: context,
      builder: (mContext) {
        return ConfirmDialog(
          title: '알림',
          message: '정말 탈퇴 하시겠습니까?',
          doConfirm: () async {
            final pref = await SharedPreferencesManager.getInstance();
            final mtIdx = pref.getMtIdx();
            Map<String, dynamic> requestData = {
              'mt_idx': mtIdx,
            };
            final resultDTO = await ref.read(myInfoEditViewModelProvider.notifier).retire(requestData);
            if (!mContext.mounted) return;
            Utils.getInstance().showSnackBar(mContext, resultDTO.message.toString());
            await pref.logOut();
            Future.delayed(const Duration(seconds: 2), () {
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/index');

              setState(() {
                ref.read(mainScreenProvider.notifier).selectNavigation(2);
              });
            });
          },
        );
      },
    );
  }
}
