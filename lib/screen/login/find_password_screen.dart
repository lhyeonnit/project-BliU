//비밀번호 찾가

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '비밀번호를 찾으려면 아래 정보를 입력하세요.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('아이디 *', _idController, '아이디 입력'),
                    const SizedBox(height: 8),
                    _buildTextField('이름 *', _nameController, '이름 입력',
                        keyboardType: TextInputType.name),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              '휴대폰번호 *', _phoneController, '-없이 숫자만 입력',
                              keyboardType: TextInputType.phone),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _phoneController.text.isNotEmpty
                              ? () {
                            // 인증요청 로직 추가
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _phoneController.text.isNotEmpty
                                ? Colors.grey[300]
                                : Colors.grey[200],
                          ),
                          child: const Text('인증요청'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              '', _authCodeController, '인증번호 입력'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _phoneController.text.isNotEmpty
                              ? () {
                            // 확인 로직 추가
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _phoneController.text.isNotEmpty
                                ? Colors.grey[300]
                                : Colors.grey[200],
                          ),
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isAllFieldsFilled
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
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _isAllFieldsFilled ? Colors.black : Colors.grey[300],
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      String hintText,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (label.isNotEmpty) const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
