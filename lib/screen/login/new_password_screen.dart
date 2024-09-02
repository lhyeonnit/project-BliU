//새 비밀번호 설정
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '새 비밀번호 입력',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                '안전한 비밀번호는 8자 이상, 영문 대소문자, 숫자, 특수문자를 포함해야 합니다.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildPasswordField('새 비밀번호 *', _passwordController,
                  '8~20자의 영문 대/소문자, 숫자, 특수문자로 입력'),
              if (!_isPasswordValid)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    '비밀번호를 입력해주세요.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              _buildPasswordField('비밀번호 재입력 *',
                  _confirmPasswordController, '비밀번호 재입력'),
              if (!_isConfirmPasswordValid)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '비밀번호를 다시 입력해주세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        '비밀번호가 일치하지 않습니다.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _validatePassword();
                    if (_formKey.currentState!.validate() &&
                        _isPasswordValid &&
                        _isConfirmPasswordValid) {
                      // 비밀번호 변경 로직 추가

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          onChanged: (text) {
            _validatePassword();
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
