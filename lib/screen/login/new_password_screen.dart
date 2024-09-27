//새 비밀번호 설정
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  void _validatePassword() {
    setState(() {
      _isPasswordValid = _passwordController.text.length >= 8 &&
          _passwordController.text.length <= 20;
      _isConfirmPasswordValid =
          _passwordController.text == _confirmPasswordController.text;
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
                    '새 비밀번호 입력',
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
                      '안전한 비밀번호는 8자 이상, 영문 대소문자, 숫자, \n특수문자를 포함하여야 합니다.',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF7B7B7B),
                        height: 1.2,
                      ),
                    ),
                  ),
                  _buildPasswordField('새 비밀번호', _passwordController,
                      '8~20자의 영문 대/소문자, 숫자, 특수문자로 입력'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '8~20자의 영문 대/소문자, 숫자, 특수문자를 사용하세요.',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (!_isPasswordValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '비밀번호를 입력해주세요.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: const Color(0xFFF23728),
                          fontSize: Responsive.getFont(context, 12),
                          height: 1.2,
                        ),
                      ),
                    ),
                  _buildPasswordField(
                      '비밀번호 재입력', _confirmPasswordController, '비밀번호 재입력'),
                  if (!_isConfirmPasswordValid)
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '비밀번호를 다시 입력해주세요.',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: const Color(0xFFF23728),
                              fontSize: Responsive.getFont(context, 12),
                              height: 1.2,
                            ),
                          ),
                          Text(
                            '비밀번호가 일치하지 않습니다.',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: const Color(0xFFF23728),
                              fontSize: Responsive.getFont(context, 12),
                              height: 1.2,
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
              onTap: () {
                _validatePassword();
                if (_formKey.currentState!.validate() &&
                    _isPasswordValid &&
                    _isConfirmPasswordValid) {
                  // 비밀번호 변경 로직 추가

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: Responsive.getHeight(context, 48),
                margin: const EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                decoration: BoxDecoration(
                  color: _isConfirmPasswordValid ? Colors.black : const Color(0xFFDDDDDD),
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
                      color: _isConfirmPasswordValid ? Colors.white : const Color(0xFF7B7B7B),
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

  Widget _buildPasswordField(
      String label, TextEditingController controller, String hintText) {
    return Container(
      margin: EdgeInsets.only(top: 20),
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
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
              ),
              controller: controller,
              obscureText: true,
              onChanged: (text) {
                _validatePassword();
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
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
              ),
            ),
        ],
      ),
    );
  }
}
