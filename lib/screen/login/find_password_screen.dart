//비밀번호 찾가

import 'dart:async';

import 'package:BliU/screen/login/viewmodel/find_password_screen_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'new_password_screen.dart';

class FindPasswordScreen extends ConsumerStatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends ConsumerState<FindPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isAllFieldsFilled = false;
  bool _phoneAuthCodeVisible = false;
  bool _phoneAuthChecked = false;
  int? idx;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idController.addListener(_checkIfAllFieldsFilled);
    _nameController.addListener(_checkIfAllFieldsFilled);
    _phoneController.addListener(_checkIfAllFieldsFilled);
    _authCodeController.addListener(_checkIfAllFieldsFilled);
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      _isAllFieldsFilled = _idController.text.isNotEmpty && _nameController.text.isNotEmpty && _phoneController.text.isNotEmpty;
    });
  }
  int _authSeconds = 180;
  String _timerStr = "00:00";
  Timer? _timer;

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

          int min = _authSeconds ~/ 60;
          int sec = _authSeconds % 60;
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
            margin: const EdgeInsets.only(top: 40, bottom: 80, right: 16, left: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '비밀번호 찾기',
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
                      '비밀번호를 찾으려면 아래 정보를 입력하세요.',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF7B7B7B),
                        height: 1.2,
                      ),
                    ),
                  ),
                  _buildTextField('아이디', _idController, '아이디 입력'),
                  _buildTextField('이름', _nameController, '이름 입력',
                      keyboardType: TextInputType.name),
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
                        child: GestureDetector(
                          onTap: () async {
                            if (_phoneController.text.isEmpty || _phoneAuthChecked) {
                              return;
                            }

                            final pref = await SharedPreferencesManager
                                .getInstance();
                            final phoneNumber = _phoneController.text;

                            Map<String, dynamic> requestData = {
                              'app_token': pref.getToken(),
                              'phone_num': phoneNumber,
                              'code_type': 3,
                            };
                            final resultDTO = await ref.read(
                                findPasswordScreenModelProvider.notifier)
                                .reqPhoneAuthCode(requestData);
                            if (resultDTO?.result == true) {
                              setState(() {
                                _phoneAuthCodeVisible = true;
                                _authTimerStart();
                              });
                            }
                          },
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
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                    Border.all(
                                        color: const Color(0xFFDDDDDD)),
                                  ),
                                  child: Center(
                                      child: Text(
                                        '인증요청',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(
                                              context, 14),
                                          height: 1.2,
                                        ),
                                      )
                                  )
                              )
                            ],
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
                              keyboardType: TextInputType.number,
                              isEnable: _phoneAuthChecked ? false : true),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              if (_authCodeController.text.isEmpty ||
                                  _phoneAuthChecked) {
                                return;
                              }
                              // TODO 타이머 체크필요
                              FocusScope.of(context).unfocus();
                              final pref = await SharedPreferencesManager.getInstance();
                              final phoneNumber = _phoneController.text;
                              final authCode = _authCodeController.text;

                              Map<String, dynamic> requestData = {
                                'app_token': pref.getToken(),
                                'phone_num': phoneNumber,
                                'code_num': authCode,
                                'code_type': 3,
                              };

                              final resultDTO = await ref.read(
                                  findPasswordScreenModelProvider.notifier).checkCode(requestData);
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
                                    fontSize: Responsive.getFont(
                                        context, 14),
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
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                if (!_isAllFieldsFilled) {
                  return;
                }

                final id = _idController.text;
                final name = _nameController.text;
                final phoneNum = _phoneController.text;
                final phoneNumChk = _phoneAuthChecked ? "Y" : "N";

                Map<String, dynamic> requestData = {
                  'id' : id,
                  'name': name,
                  'phone_num': phoneNum,
                  'phone_num_chk': phoneNumChk,
                };

                final findPasswordResponseDTO = await ref.read(findPasswordScreenModelProvider.notifier).findPassword(requestData);
                if (findPasswordResponseDTO?.result == true) {
                  idx = findPasswordResponseDTO?.idx;
                  final passwordToken = findPasswordResponseDTO?.pwdToken;  // 서버에서 받은 비밀번호 토큰
                  final pref = await SharedPreferencesManager.getInstance();
                  pref.savePasswordToken(passwordToken!);
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPasswordScreen(idx: idx),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                decoration: BoxDecoration(
                  color: _isAllFieldsFilled ? Colors.black : const Color(0xFFDDDDDD),
                  borderRadius: const BorderRadius.all(Radius.circular(6),
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
                height: 1.2
              ),
              enabled: isEnable,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 15),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: const Color(0xFF595959),
                  height: 1.2
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

  Widget _buildCheckField(String label, TextEditingController controller,
      String hintText,
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
                height: 1.2,
              ),
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              enabled: isEnable,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: isEnable ? const Color(0xFF595959) : const Color(0xFFA4A4A4),
                  height: 1.2,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(6)
                ),
                hintText: hintText,
                fillColor: isEnable ? Colors.white : const Color(0xFFF5F9F9),
                // 배경색 설정
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  borderSide: isEnable ? const BorderSide(color: Color(0xFFE1E1E1)) : const BorderSide(color: Colors.transparent),
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
}
