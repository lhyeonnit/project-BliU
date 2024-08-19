//회원가입폼
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'join_complete_screen.dart';

class JoinFormScreen extends StatefulWidget {
  @override
  _JoinFormScreenState createState() => _JoinFormScreenState();
}

class _JoinFormScreenState extends State<JoinFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isIdChecked = false;
  bool _isAllFieldsFilled = false;
  String? _selectedGender; // 성별을 저장하는 변수

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  DateTime? _selectedDate;

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
          _selectedDate != null &&
          _selectedGender != null && // 성별이 선택되었는지 확인
          _isIdChecked;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _checkIfAllFieldsFilled();
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
      body: SingleChildScrollView(
        // 스크롤 가능하도록 설정
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '회원가입 정보입력',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '회원가입을 위해 회원님의 정보를 입력해 주세요',
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('아이디 *', _idController, '아이디 입력'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _idController.text.isNotEmpty
                        ? () {
                            // 아이디 중복확인 로직 추가
                            setState(() {
                              _isIdChecked = true;
                              _checkIfAllFieldsFilled();
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _idController.text.isNotEmpty
                          ? Colors.grey[300]
                          : Colors.grey[200],
                    ),
                    child: Text('중복확인'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '5~15자의 영문 소문자, 숫자만 입력해 주세요',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              _buildTextField(
                  '비밀번호 *', _passwordController, '비밀번호 입력(숫자, 특수기호 포함한 7~15자)',
                  obscureText: true),
              SizedBox(height: 16),
              _buildTextField('', _confirmPasswordController, '비밀번호 재입력',
                  obscureText: true),
              SizedBox(height: 16),
              _buildTextField('이름 *', _nameController, '이름 입력'),
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
                    child: _buildTextField('', _authCodeController, '인증번호 입력'),
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
              SizedBox(height: 16),
              Row(
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
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                      '',
                      TextEditingController(
                          text: _selectedDate == null
                              ? '생년월일 선택'
                              : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'),
                      ''),
                ),
              ),
              SizedBox(height: 16),
              IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/login/coupon_banner.png'),
              ),
              Row(
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
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderButton('남자'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderButton('여자'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAllFieldsFilled
                      ? () {
                          // 회원가입 확인 로직 추가
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JoinCompleteScreen(),
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
        padding: EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Text(gender),
    );
  }
}
