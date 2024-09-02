//회원가입 추가정보 입력
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../main_page.dart';


class JoinAddInfoScreen extends StatefulWidget {
  const JoinAddInfoScreen({super.key});

  @override
  _JoinAddInfoScreenState createState() => _JoinAddInfoScreenState();
}

class _JoinAddInfoScreenState extends State<JoinAddInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isAllFieldsFilled = false;
  String? _selectedGender; // 성별을 저장하는 변수

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkIfAllFieldsFilled);
    _phoneController.addListener(_checkIfAllFieldsFilled);
    _authCodeController.addListener(_checkIfAllFieldsFilled);
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      _isAllFieldsFilled =
          _nameController.text.isNotEmpty &&
              _phoneController.text.isNotEmpty &&
              _selectedDate != null &&
              _selectedGender != null; // 성별이 선택되었는지 확인
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '추가 정보',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                '추가 정보를 입력해 주세요.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
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
                    child: _buildTextField('', _authCodeController, '인증번호 입력'),
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
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('생년월일',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(
                    width: 5,
                  ),
                  Text('선택',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                      '',
                      TextEditingController(
                          text: _selectedDate == null
                              ? '생년월일 입력'
                              : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'),
                      ''),
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/login/coupon_banner.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('성별',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(
                    width: 5,
                  ),
                  Text('선택',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ), // 성별 선택 타이틀
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderButton('남자'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderButton('여자'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAllFieldsFilled
                      ? () {
                    // 회원가입 확인 로직 추가
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
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
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
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

  Widget _buildGenderButton(String gender) {
    bool isSelected = _selectedGender == gender;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGender = gender;
          _checkIfAllFieldsFilled();
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.pinkAccent : Colors.white,
        side: BorderSide(color: isSelected ? Colors.pinkAccent : Colors.grey),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Text(gender),
    );
  }
}
