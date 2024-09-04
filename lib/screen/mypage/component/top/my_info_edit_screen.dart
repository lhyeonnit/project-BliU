//내정보 수정
import 'package:BliU/screen/mypage/my_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyInfoEditScreen extends StatefulWidget {
  const MyInfoEditScreen({super.key});

  @override
  _MyInfoEditScreenState createState() => _MyInfoEditScreenState();
}

class _MyInfoEditScreenState extends State<MyInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool _isIdChecked = false;
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
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: const Text(
          '내정보수정',
          style: TextStyle(color: Colors.black),
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
              const Text(
                '내 정보 수정',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '회원님의 개인정보 및 연락처, 주소 등을 수정할 수 있습니다.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField('아이디', _idController, '아이디 입력'),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildTextField(
                  '비밀번호 *', _passwordController, '비밀번호 입력(숫자, 특수기호 포함한 7~15자)',
                  obscureText: true),
              const SizedBox(height: 10),
              _buildTextField('', _confirmPasswordController, '비밀번호 재입력',
                  obscureText: true),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // 확인 버튼 동작 추가

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    '변경',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      '휴대폰번호 *', _phoneController, '-없이 숫자만 입력',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100, // 가로 길이를 100으로 고정
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // 확인 버튼 동작 추가
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Text(
                          '변경',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      '이름 *', _nameController, '이름 입력',
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100, // 가로 길이를 100으로 고정
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // 확인 버튼 동작 추가
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Text(
                          '변경',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
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
                              ? '생년월일 선택'
                              : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'),
                      ''),
                ),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/login/coupon_banner.png'),
              ),
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
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    '회원탈퇴',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAllFieldsFilled
                      ? () {
                    // 확인 로직 추가
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyScreen(),
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
                    '저장',
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
