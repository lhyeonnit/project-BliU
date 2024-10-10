import 'dart:async';

import 'package:BliU/screen/join/join_complete_screen.dart';
import 'package:BliU/screen/join/viewmodel/join_form_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

//회원가입폼
class JoinFormScreen extends ConsumerStatefulWidget {
  const JoinFormScreen({super.key});

  @override
  ConsumerState<JoinFormScreen> createState() => _JoinFormScreenState();
}

class _JoinFormScreenState extends ConsumerState<JoinFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isIdChecked = false;
  bool _isAllFieldsFilled = false;
  bool _phoneAuthCodeVisible = false;
  bool _phoneAuthChecked = false;
  String? _selectedGender; // 성별을 저장하는 변수

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  DateTime? _selectedDate;

  int _authSeconds = 180;
  String _timerStr = "00:00";
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _idController.addListener(_checkIfAllFieldsFilled);
    _passwordController.addListener(_checkIfAllFieldsFilled);
    _confirmPasswordController.addListener(_checkIfAllFieldsFilled);
    _nameController.addListener(_checkIfAllFieldsFilled);
    _phoneController.addListener(_checkIfAllFieldsFilled);
    _authCodeController.addListener(_checkIfAllFieldsFilled);
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      _isAllFieldsFilled = _idController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _isIdChecked &&
          _phoneAuthChecked;
      // && _selectedDate != null
      // && _selectedGender != null; // 성별이 선택되었는지 확인
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _checkIfAllFieldsFilled();
      });
    }
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
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
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
          SingleChildScrollView(
            // 스크롤 가능하도록 설정
            child: Container(
              margin: const EdgeInsets.only(top: 40, bottom: 80, right: 16, left: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '회원가입 정보입력',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 20),
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 10),
                      child: Text(
                        '회원가입을 위해 회원님의 정보를 입력해 주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFF7B7B7B),
                          height: 1.2,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildTextField('아이디', _idController, '아이디 입력',
                              isEnable: _isIdChecked ? false : true),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              if (_idController.text.isEmpty || _isIdChecked) {
                                return;
                              }

                              final id = _idController.text;
                              Map<String, dynamic> requestData = {'id': id};

                              final resultDTO = await ref.read(joinFormModelProvider.notifier).checkId(requestData);
                              if (!context.mounted) return;
                              Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                              if (resultDTO.result == true) {
                                setState(() {
                                  setState(() {
                                    _isIdChecked = true;
                                    _checkIfAllFieldsFilled();
                                  });
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 50, left: 8),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFDDDDDD)),
                              ),
                              child: Center(
                                child: Text(
                                  '중복확인',
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
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(
                        '5~15자의 영문 소문자, 숫자만 입력해 주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: const Color(0xFFF23728),
                          fontSize: Responsive.getFont(context, 12),
                          height: 1.2,
                        ),
                      ),
                    ),
                    _buildTextField('비밀번호', _passwordController, '비밀번호 입력(숫자, 특수기호 포함한 7~15자)', obscureText: true),
                    _buildCheckField('비밀번호', _confirmPasswordController, '비밀번호 재입력', obscureText: true),
                    _buildTextField('이름', _nameController, '이름 입력', keyboardType: TextInputType.name),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildTextField(
                            '휴대폰번호', _phoneController, '-없이 숫자만 입력',
                            keyboardType: TextInputType.phone,
                            isEnable: _phoneAuthChecked ? false : true
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: _phoneAuthCodeVisible && !_phoneAuthChecked,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 20, left: 8),
                                  child: Text(
                                    _timerStr,
                                    style: TextStyle(
                                      color: const Color(0xFFFF6192),
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 13),
                                      height: 1.2,
                                    ),
                                  ),
                                )
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_phoneController.text.isEmpty || _phoneAuthChecked) {
                                    return;
                                  }

                                  final pref = await SharedPreferencesManager.getInstance();
                                  final phoneNumber = _phoneController.text;

                                  Map<String, dynamic> requestData = {
                                    'app_token': pref.getToken(),
                                    'phone_num': phoneNumber,
                                    'code_type': 1,
                                  };
                                  final resultDTO = await ref.read(joinFormModelProvider.notifier).reqPhoneAuthCode(requestData);
                                  if (resultDTO.result == true) {
                                    setState(() {
                                      _phoneAuthChecked = false;
                                      _phoneAuthCodeVisible = true;
                                      _authTimerStart();
                                    });
                                  } else {
                                    if (!context.mounted) return;
                                    Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10, left: 8),
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
                              )
                            ],
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
                                isEnable: _phoneAuthChecked ? false : true),
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
                                  'code_type': 1,
                                };

                                final resultDTO = await ref.read(joinFormModelProvider.notifier).checkCode(requestData);
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
                                  color: _phoneAuthChecked ? const Color(0xFFDDDDDD) : Colors.black,
                                ),
                                child: Center(
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: _phoneAuthChecked ? const Color(0xFF7B7B7B) : Colors.white,
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
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildOrTextField(
                            '생년월일',
                            TextEditingController(
                                text: _selectedDate == null ? '생년월일 선택'
                                    : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'),
                            ''),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset('assets/images/login/coupon_banner.png'),
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
                          ),
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
                            ),
                          ),
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
                              child: _buildGenderButton('남자')
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 4),
                              child: _buildGenderButton('여자')
                            ),
                          ),
                        ],
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
            child: GestureDetector(
              onTap: _isAllFieldsFilled
                  ? () async {
                      // TODO 회원가입 확인 로직 추가
                      if (_passwordController.text != _confirmPasswordController.text) {
                        Utils.getInstance().showSnackBar(context, "비밀번호가 서로 다릅니다 다시 입력해 주세요.");
                        return;
                      }

                      final id = _idController.text;
                      final pwd = _passwordController.text;
                      final pwdChk = _confirmPasswordController.text;
                      final name = _nameController.text;
                      final phoneNum = _phoneController.text;
                      final phoneNumChk = _phoneAuthChecked ? "Y" : "N";
                      String birthDay = "";
                      try {
                        if (_selectedDate != null) {
                          birthDay = DateFormat("yyyy-MM-dd").format(_selectedDate!);
                        }
                      } catch (e) {
                        print("DateError $e");
                      }
                      String gender = "";
                      if (_selectedGender == "남자") {
                        gender = "M";
                      } else if (_selectedGender == "여자") {
                        gender = "F";
                      }

                      final pref = await SharedPreferencesManager.getInstance();

                      Map<String, dynamic> requestData = {
                        'id': id,
                        'pwd': pwd,
                        'pwd_chk': pwdChk,
                        'name': name,
                        'phone_num': phoneNum,
                        'phone_num_chk': phoneNumChk,
                        'birth_day': birthDay,
                        'gender': gender,
                        'app_token': pref.getToken(),
                      };

                      final resultDTO = await ref.read(joinFormModelProvider.notifier).join(requestData);
                      if (resultDTO.result == true) {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const JoinCompleteScreen(),),);
                      } else {
                        if (!context.mounted) return;
                        Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                      }
                    }
                  : null,
              child: Container(
                width: double.infinity,
                height: Responsive.getHeight(context, 48),
                margin: const EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                decoration: BoxDecoration(
                  color: _isAllFieldsFilled ? Colors.black : const Color(0xFFDDDDDD),
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
                      color: _isAllFieldsFilled ? Colors.white : const Color(0xFF7B7B7B),
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon,
      bool isEnable = true}) {
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
                  ),
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
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
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
                  color: const Color(0xFF595959)
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                disabledBorder: const OutlineInputBorder(
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
      bool isEnable = true}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            TextField(
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
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
                    color: const Color(0xFF595959)),
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

  Widget _buildOrTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      bool isEnable = true}) {
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
          TextField(
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
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
                color:const Color(0xFF595959)
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
        ],
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _checkIfAllFieldsFilled();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)
          ),
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
        )
      ),
    );
  }
}
