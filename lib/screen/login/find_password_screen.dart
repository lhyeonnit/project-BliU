//비밀번호 찾가

import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'new_password_screen.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  _FindPasswordScreenState createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool _isIdChecked = false;
  bool _isAllFieldsFilled = false;

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
      _isAllFieldsFilled = _idController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _isIdChecked;
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
              margin: EdgeInsets.only(top: 40, bottom: 80, right: 16, left: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '비밀번호 찾기',
                      style: TextStyle( fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 10),
                      child: Text(
                        '비밀번호를 찾으려면 아래 정보를 입력하세요.',
                        style: TextStyle( fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFF7B7B7B)),
                      ),
                    ),
                    _buildTextField('아이디', _idController, '아이디 입력',
                              isEnable: _isIdChecked ? false : true),
                    _buildTextField('이름', _nameController, '이름 입력', keyboardType: TextInputType.name),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildTextField(
                              '휴대폰번호', _phoneController, '-없이 숫자만 입력',
                              keyboardType: TextInputType.phone,
                              // isEnable: _phoneAuthChecked ? false : true
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              // if (_phoneController.text.isEmpty ||
                              //     _phoneAuthChecked) {
                              //   return;
                              // }
                              //
                              // final pref =
                              // await SharedPreferencesManager.getInstance();
                              // final phoneNumber = _phoneController.text;
                              //
                              // Map<String, dynamic> requestData = {
                              //   'app_token': pref.getToken(),
                              //   'phone_num': phoneNumber,
                              //   'code_type': 1,
                              // };
                              // final resultDTO = await ref
                              //     .read(joinFormModelProvider.notifier)
                              //     .reqPhoneAuthCode(requestData);
                              // if (resultDTO.result == true) {
                              //   setState(() {
                              //     _phoneAuthCodeVisible = true;
                              //     // TODO 타이머 로직 추가
                              //   });
                              // } else {
                              //   if (!context.mounted) return;
                              //   Utils.getInstance().showSnackBar(
                              //       context, resultDTO.message.toString());
                              // }
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 50, left: 8),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Color(0xFFDDDDDD)),
                                ),
                                child: Center(
                                    child: Text(
                                      '인증요청',
                                      style: TextStyle( fontFamily: 'Pretendard',
                                          fontSize:
                                          Responsive.getFont(context, 14)),
                                    ))),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      // visible: _phoneAuthCodeVisible,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: _buildCheckField(
                                '휴대폰번호', _authCodeController, '인증번호 입력',
                                keyboardType: TextInputType.phone,
                                // isEnable: _phoneAuthChecked ? false : true
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () async {
                                // if (_authCodeController.text.isEmpty ||
                                //     _phoneAuthChecked) {
                                //   return;
                                // }
                                // // TODO 타이머 체크필요
                                //
                                // final pref = await SharedPreferencesManager
                                //     .getInstance();
                                // final phoneNumber = _phoneController.text;
                                // final authCode = _authCodeController.text;
                                //
                                // Map<String, dynamic> requestData = {
                                //   'app_token': pref.getToken(),
                                //   'phone_num': phoneNumber,
                                //   'code_num': authCode,
                                //   'code_type': 1,
                                // };
                                //
                                // final resultDTO = await ref
                                //     .read(joinFormModelProvider.notifier)
                                //     .checkCode(requestData);
                                // if (!context.mounted) return;
                                // Utils.getInstance().showSnackBar(
                                //     context, resultDTO.message.toString());
                                // if (resultDTO.result == true) {
                                //   setState(() {
                                //     _phoneAuthChecked = true;
                                //     _checkIfAllFieldsFilled();
                                //   });
                                // }
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10, left: 8),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Text(
                                    '확인',
                                    style: TextStyle( fontFamily: 'Pretendard',
                                        fontSize:
                                        Responsive.getFont(context, 14),
                                        color: Colors.white),
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
              onTap:  _isAllFieldsFilled
                  ? () {
                // 아이디 확인 로직 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewPasswordScreen(),
                  ),
                );
              }
                  : null,
              child: Container(
                width: double.infinity,
                height: Responsive.getHeight(context, 48),
                margin:
                EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                decoration: BoxDecoration(
                  color: _isAllFieldsFilled ? Colors.black : Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    '확인',
                    style: TextStyle( fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color:
                      _isAllFieldsFilled ? Colors.white : Color(0xFF7B7B7B),
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
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (label.isNotEmpty)
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(label,
                    style: TextStyle( fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 13))),
                Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text('*',
                        style: TextStyle( fontFamily: 'Pretendard',
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.getFont(context, 13),
                            color: Color(0xFFFF6192)))),
              ],
            ),
          ),
          if (label.isNotEmpty)
            TextField(
              style: TextStyle( fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
              ),
              enabled: isEnable,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                hintText: hintText,
                hintStyle: TextStyle( fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF595959)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: OutlineInputBorder(
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
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            TextField(
              style: TextStyle( fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
              ),
              enabled: isEnable,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                hintText: hintText,
                hintStyle: TextStyle( fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF595959)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: OutlineInputBorder(
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
