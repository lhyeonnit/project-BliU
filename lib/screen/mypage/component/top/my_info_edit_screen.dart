import 'dart:async';

import 'package:BliU/data/my_page_info_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/my_info_delete_page.dart';
import 'package:BliU/screen/mypage/my_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/my_info_edit_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class MyInfoEditScreen extends ConsumerStatefulWidget {
  final String? authToken;
  final bool? isCommon;
  const MyInfoEditScreen({super.key, this.authToken, this.isCommon});

  @override
  ConsumerState<MyInfoEditScreen> createState() => MyInfoEditScreenState();
}

class MyInfoEditScreenState extends ConsumerState<MyInfoEditScreen> {
  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  bool _isAllFieldsFilled = false;
  bool _phoneAuthCodeVisible = false;
  bool _phoneAuthChecked = false;
  MyPageInfoData? myPageInfoData;
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  String? _selectedGender; // 성별을 저장하는 변수
  final TextEditingController _birthController = TextEditingController(text: '생년월일 입력');

  late TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  int _authSeconds = 180;
  String _timerStr = "00:00";
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMyInfo();
    });
    _idController.addListener(_checkIfAllFieldsFilled);
    _passwordController.addListener(_checkIfAllFieldsFilled);
    _confirmPasswordController.addListener(_checkIfAllFieldsFilled);
    _nameController.addListener(_checkIfAllFieldsFilled);
    _phoneController.addListener(_checkIfAllFieldsFilled);
    _authCodeController.addListener(_checkIfAllFieldsFilled);
    _checkIfAllFieldsFilled();
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      if (widget.isCommon ?? true) {
        _isAllFieldsFilled = _idController.text.isNotEmpty &&
            // _passwordController.text.isNotEmpty &&
            // _confirmPasswordController.text.isNotEmpty &&
            _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty;
            // _selectedDate != null &&
            // _selectedGender != null && // 성별이 선택되었는지 확인
      } else {
        _isAllFieldsFilled = _idController.text.isNotEmpty &&
            _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty;
            // _selectedDate != null &&
            // _selectedGender != null && // 성별이 선택되었는지 확인
      }
    });
  }
  void _authTimerStart() {
    if (_timer != null) {
      _timer?.cancel();
    }

    setState(() {
      _authSeconds = 180;
      _timerStr = "03:00";
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (_authSeconds == 0) {
          t.cancel();
        } else {
          _authSeconds--;

          int min = _authSeconds~/60;
          int sec = _authSeconds%60;
          String secStr = "";
          if (sec < 10) {
            secStr = "0$sec";
          } else {
            secStr = sec.toString();
          }

          _timerStr = "0$min:$secStr";
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('내 정보 수정'),
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
            SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                margin: const EdgeInsets.only(top: 40, bottom: 90),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
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
                          '회원님의 개인정보 및 연락처, 주소 등을 수정할 수 있습니다',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: const Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                      _buildIdPasswordField('아이디', _idController, '아이디 입력', isChange: false),
                      Visibility(
                        visible: widget.isCommon ?? true,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              _buildIdPasswordField('비밀번호', _passwordController,
                                  '비밀번호 입력(숫자, 특수기호 포함한 7~15자)',
                                  obscureText: true, isChange: true),
                              _buildCheckField(
                                  '비밀번호', _confirmPasswordController, '비밀번호 재입력',
                                  obscureText: true, isEnable: true),
                              GestureDetector(
                                onTap: () {
                                  // TODO 이전 비밀번호 재사용 방지 처리 필요
                                  _editMyPassword();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  margin: const EdgeInsets.only(top: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFDDDDDD)),
                                  ),
                                  child: Center(
                                      child: Text(
                                        '변경',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          height: 1.2,
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: _buildPhoneField(
                                '휴대폰번호', _phoneController, "'-'없이 숫자만 입력",
                                keyboardType: TextInputType.phone,
                                isEnable: _phoneAuthChecked ? true : false),
                          ),
                          Visibility(
                            visible: !_phoneAuthChecked,
                            child: Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _phoneAuthChecked = true;
                                    _timerStr;
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(top: 45, left: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFDDDDDD)),
                                    ),
                                    child: Center(
                                        child: Text(
                                          '변경',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            height: 1.2,
                                          ),
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _phoneAuthChecked,
                            child: Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () async {
                                  _editMyPh();
                                  if (_phoneController.text.isEmpty ||
                                      _phoneAuthChecked) {
                                    return;
                                  }

                                  final pref = await SharedPreferencesManager.getInstance();
                                  final phoneNumber = _phoneController.text;

                                  Map<String, dynamic> requestData = {
                                    'app_token': pref.getToken(),
                                    'phone_num': phoneNumber,
                                    'code_type': 4,
                                  };
                                  final resultDTO = await ref
                                      .read(myInfoEditViewModelProvider.notifier)
                                      .reqPhoneAuthCode(requestData);
                                  if (resultDTO.result == true) {
                                    setState(() {
                                      _phoneAuthCodeVisible = true;
                                      _authTimerStart();
                                    });
                                  } else {
                                    if (!context.mounted) return;
                                    Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                                  }
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(top: 45, left: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFDDDDDD)),
                                    ),
                                    child: Center(
                                        child: Text(
                                          '인증요청',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            height: 1.2,
                                          ),
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: _phoneAuthCodeVisible,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: _buildCheckField(
                                  '휴대폰번호', _authCodeController, '인증번호 입력',
                                  isEnable: _phoneAuthChecked ? true : false
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () async {
                                  if (_authCodeController.text.isEmpty || _phoneAuthChecked) {
                                    return;
                                  }
                                  if (_authSeconds <= 0) {
                                    return;
                                  }

                                  final pref = await SharedPreferencesManager.getInstance();
                                  final phoneNumber = _phoneController.text;
                                  final authCode = _authCodeController.text;

                                  Map<String, dynamic> requestData = {
                                    'app_token': pref.getToken(),
                                    'phone_num': phoneNumber,
                                    'code_num': authCode,
                                    'code_type': 4,
                                  };

                                  final resultDTO = await ref.read(myInfoEditViewModelProvider.notifier).checkCode(requestData);
                                  if (!context.mounted) return;
                                  Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                                  if (resultDTO.result == true) {
                                    setState(() {
                                      _phoneAuthChecked = true;
                                      _checkIfAllFieldsFilled();
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10, left: 8),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: _phoneAuthChecked ?  Colors.black : const Color(0xFFDDDDDD),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: _phoneAuthChecked ? Colors.white : const Color(0xFF7B7B7B) ,
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
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: _buildTextField('이름', _nameController, '이름 입력', keyboardType: TextInputType.name
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () async {
                                _editMyName();
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(top: 45, left: 8),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFDDDDDD)),
                                  ),
                                  child: Center(
                                      child: Text(
                                        '변경',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      )
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          children: [
                            Text('생년월일',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.getFont(context, 13),
                                  height: 1.2,
                                )
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 4),
                                child: Text('선택',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.getFont(context, 13),
                                      color: const Color(0xFFFF6192),
                                      height: 1.2,
                                    )
                                )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                        ),
                        child: _birthdayText(),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO 쿠폰 지급 이동
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                    'assets/images/login/coupon_banner.png'),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 10,
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '생일 쿠폰 지급!',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 16),
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      '생년월일을 입력 주시면, 생일날 쿠폰 지급!',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 12),
                                        color: const Color(0xFF6A5B54),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('성별',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.getFont(context, 13),
                                height: 1.2,
                              )
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 4),
                              child: Text('선택',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.getFont(context, 13),
                                    color: const Color(0xFFFF6192),
                                    height: 1.2,
                                  )
                              )
                          ),
                        ],
                      ), // 성별 선택 타이틀
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: _buildGenderButton('남자')),
                            ),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  child: _buildGenderButton('여자')),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MyInfoDeletePage()),
                              );
                            },
                            child: Text(
                              '회원탈퇴',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: const Color(0xFF7B7B7B),
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  MoveTopButton(scrollController: _scrollController),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        _isAllFieldsFilled
                            ? () {
                          _editMyInfo();
                        }
                            : null;
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                        decoration: BoxDecoration(
                          color: _isAllFieldsFilled ? Colors.black : const Color(0xFFDDDDDD),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '저장',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: _isAllFieldsFilled ? Colors.white : const Color(0xFF7B7B7B),
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
          ],
        ),
      ),
    );
  }

  Widget _buildIdPasswordField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon,
      required bool isChange}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (label.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: Responsive.getFont(context, 13),
              height: 1.2,
            ),
          ),
        ),
        if (label.isNotEmpty)
          TextField(
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            style: TextStyle(
                decorationThickness: 0,
                height: 1.2,
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14)
            ),
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            enabled: isChange,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                color: isChange ? const Color(0xFF595959) : const Color(0xFFA4A4A4),
              ),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(6),
              ),
              hintText: hintText,
              fillColor: isChange ? Colors.white : const Color(0xFFF5F9F9),
              // 배경색 설정
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                borderSide: isChange ? const BorderSide(color: Color(0xFFE1E1E1)) : const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Colors.black),
              ),
              suffixIcon: suffixIcon,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (label.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(label,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.getFont(context, 13),
                    height: 1.2,
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: Text('*',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.getFont(context, 13),
                      color: const Color(0xFFFF6192),
                      height: 1.2,
                    )
                  )
                ),
              ],
            ),
          ),
          if (label.isNotEmpty)
            TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              style: TextStyle(
                  decorationThickness: 0,
                  height: 1.2,
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14)
              ),
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                hintText: hintText,
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
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoneField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon,
      required bool isEnable}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (label.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(label,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.getFont(context, 13),
                    height: 1.2,
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: Text('*',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.getFont(context, 13),
                      color: const Color(0xFFFF6192),
                      height: 1.2,
                    )
                  )
                ),
              ],
            ),
          ),
          if (label.isNotEmpty)
            TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              style: TextStyle(
                  decorationThickness: 0,
                  height: 1.2,
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14)
              ),
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              enabled: isEnable,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: isEnable ? Colors.white : const Color(0xFFA4A4A4)
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: hintText,
                fillColor: isEnable ? Colors.white : const Color(0xFFF5F9F9),
                // 배경색 설정
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon,
        required bool isEnable}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              style: TextStyle(
                  decorationThickness: 0,
                  height: 1.2,
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14)
              ),
              enabled: isEnable,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                hintText: hintText,
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
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    String genderValue = 'M';
    if (gender == '남자') {
      genderValue = 'M';
    } else if(gender == '여자') {
      genderValue = 'F';
    }
    bool isSelected = _selectedGender == genderValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = genderValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontFamily: 'Pretendard',
              color: isSelected ? const Color(0xFFFF6192) : Colors.black,
              fontSize: Responsive.getFont(context, 14),
              height: 1.2,
            ),
          )
        ),
      ),
    );
  }

  Widget _birthdayText() {
    return GestureDetector(
      onTap: () {
        _selectDate();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
          ),
          controller: _birthController,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: const Color(0xFF595959),
          ),
        ),
      ),
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: Colors.white,
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              int maxDay = DateTime(selectedYear, selectedMonth + 1, 0).day;

              return Container(
                height: 400,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '출생년도',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEEEEEE),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                diameterRatio: 5.0,
                                itemExtent: 50,
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.only(left: 17, right: 15),
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(color: Color(0xFFDDDDDD)),
                                    ),
                                  ),
                                ),
                                squeeze: 1,
                                scrollController: FixedExtentScrollController(initialItem: selectedYear - 1900),
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedYear = 1900 + index;
                                    maxDay = DateTime(selectedYear, selectedMonth + 1, 0).day;
                                    if (selectedDay > maxDay) selectedDay = maxDay;
                                  });
                                },
                                children: List<Widget>.generate(
                                  DateTime.now().year - 1900 + 1,
                                      (int index) => Center(
                                    child: Text(
                                      '${1900 + index}년',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 16),
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                itemExtent: 50,
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(color: Color(0xFFDDDDDD)),
                                    ),
                                  ),
                                ),
                                diameterRatio: 5.0,
                                squeeze: 1,
                                scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedMonth = index + 1;
                                    maxDay = DateTime(selectedYear, selectedMonth + 1, 0).day;
                                    if (selectedDay > maxDay) selectedDay = maxDay;
                                  });
                                },
                                children: List<Widget>.generate(12, (int index) => Center(
                                  child: Text(
                                    '${index + 1}월',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 16),
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                )),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                itemExtent: 50,
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.only(left: 15, right: 17),
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(color: Color(0xFFDDDDDD)),
                                    ),
                                  ),
                                ),
                                diameterRatio: 5.0,
                                squeeze: 1,
                                scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedDay = index + 1;
                                  });
                                },
                                children: List<Widget>.generate(
                                  maxDay,
                                      (int index) => Center(
                                    child: Text(
                                      '${index + 1}일',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 16),
                                        fontWeight: FontWeight.w600,
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                          _birthController.text = convertDateTimeDisplay(_selectedDate.toString());
                        });
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                          child: Text(
                            '선택하기',
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
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthController.text = convertDateTimeDisplay(pickedDate.toString());
      });
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('yyyy년 MM월 dd일');
    final DateTime displayDate = displayFormatter.parse(date);
    return serverFormatter.format(displayDate);
  }

  void _getMyInfo() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx().toString();
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'auth_token' : widget.authToken,
    };

    final myPageInfoResponseDTO = await ref.read(myInfoEditViewModelProvider.notifier).getMyInfo(requestData);
    setState(() {
      myPageInfoData = myPageInfoResponseDTO?.data;
      _idController.text = myPageInfoData?.mtId ?? '';  // ID 설정
      _nameController.text = myPageInfoData?.mtName ?? '';  // 이름 설정
      _phoneController.text = myPageInfoData?.mtHp ?? '';  // 전화번호 설정
      if (myPageInfoResponseDTO?.data?.mtBirth != null && myPageInfoResponseDTO!.data!.mtBirth!.isNotEmpty) {
        _selectedDate = DateTime.parse(myPageInfoResponseDTO.data!.mtBirth!); // 출생일 데이터를 DateTime으로 변환
        _birthController.text = convertDateTimeDisplay(_selectedDate.toString());
      }

      _selectedGender = myPageInfoResponseDTO?.data?.mtGender;
    });
  }
  void _editMyInfo() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String birthDay = "";
    try {
      birthDay = DateFormat("yyyy-MM-dd").format(_selectedDate);
    } catch (e) {
      if (kDebugMode) {
        print("DateError $e");
      }
    }
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'mt_birth' : birthDay,
      'mt_gender' : _selectedGender,
    };
    final defaultResponseDTO = await ref.read(myInfoEditViewModelProvider.notifier).editMyInfo(requestData);
    if (defaultResponseDTO.result == true) {
      myPageInfoData?.mtBirth = birthDay;
      myPageInfoData?.mtGender = _selectedGender;
    } else {
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, defaultResponseDTO.message.toString());
    }
    if(!mounted) return;
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const MyScreen()),
    );
  }
  void _editMyName() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final name = _nameController.text;
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'mt_name' : name,
    };
    final defaultResponseDTO = await ref.read(myInfoEditViewModelProvider.notifier).editMyName(requestData);
    if (defaultResponseDTO.result == true) {
      myPageInfoData?.mtName = name;
    } else {
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, defaultResponseDTO.message.toString());
    }
  }
  void _editMyPh() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final phone = _phoneController.text;

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'mt_hp' :phone,
    };
    final defaultResponseDTO = await ref.read(myInfoEditViewModelProvider.notifier).editMyPh(requestData);
    if (defaultResponseDTO.result == true) {
      myPageInfoData?.mtHp = phone;
    } else {
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, defaultResponseDTO.message.toString());
    }
  }
  void _editMyPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      Utils.getInstance().showSnackBar(context, "비밀번호가 서로 다릅니다 다시 입력해 주세요.");
      return;
    }
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'pwd' :password,
      'pwd_chk' :confirmPassword,
      'pwd_token' :pref.getToken(),
    };
    await ref.read(myInfoEditViewModelProvider.notifier).editMyPassword(requestData);
  }
}
