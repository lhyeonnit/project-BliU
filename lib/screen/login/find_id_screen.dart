
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'find_id_complete_screen.dart';


class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  _FindIdScreenState createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isAllFieldsFilled = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkIfAllFieldsFilled);
    _phoneController.addListener(_checkIfAllFieldsFilled);
    _authCodeController.addListener(_checkIfAllFieldsFilled);
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      _isAllFieldsFilled = _nameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty;
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
                    Text(
                      '아이디 찾기',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '아이디를 찾으려면 아래 정보를 입력하세요.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    _buildTextField('이름 *', _nameController, '이름 입력',
                        keyboardType: TextInputType.name),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              '휴대폰번호 *', _phoneController, '-없이 숫자만 입력',
                              keyboardType: TextInputType.phone),
                        ),
                        SizedBox(width: 8),
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
                          child: Text('인증요청'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              '', _authCodeController, '인증번호 입력'),
                        ),
                        SizedBox(width: 8),
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
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isAllFieldsFilled
                  ? () {
                // 아이디 확인 로직 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FindIdCompleteScreen(),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _isAllFieldsFilled ? Colors.black : Colors.grey[300],
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
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
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        if (label.isNotEmpty) SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
