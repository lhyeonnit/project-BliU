import 'package:BliU/screen/join/join_complete_screen.dart';
import 'package:BliU/screen/join/viewmodel/join_form_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

//회원가입폼
class JoinFormScreen extends ConsumerStatefulWidget {
  const JoinFormScreen({super.key});

  @override
  _JoinFormScreenState createState() => _JoinFormScreenState();
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
                  fontSize: Responsive.getFont(context, 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                '회원가입을 위해 회원님의 정보를 입력해 주세요',
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('아이디 *', _idController, '아이디 입력', isEnable: _isIdChecked ? false : true),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_idController.text.isEmpty || _isIdChecked) {
                        return;
                      }

                      final id = _idController.text;
                      Map<String, dynamic> requestData = {
                        'id' : id
                      };

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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _idController.text.isNotEmpty
                          ? Colors.grey[300]
                          : Colors.grey[200],
                    ),
                    child: const Text('중복확인'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '5~15자의 영문 소문자, 숫자만 입력해 주세요',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                  '비밀번호 *', _passwordController, '비밀번호 입력(숫자, 특수기호 포함한 7~15자)',
                  obscureText: true),
              const SizedBox(height: 16),
              _buildTextField('', _confirmPasswordController, '비밀번호 재입력',
                  obscureText: true),
              const SizedBox(height: 16),
              _buildTextField('이름 *', _nameController, '이름 입력'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        '휴대폰번호 *', _phoneController, '-없이 숫자만 입력',
                        keyboardType: TextInputType.phone,
                        isEnable: _phoneAuthChecked ? false : true),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_phoneController.text.isEmpty || _phoneAuthChecked) {
                        return;
                      }

                      final pref = await SharedPreferencesManager.getInstance();
                      final phoneNumber = _phoneController.text;

                      Map<String, dynamic> requestData = {
                        'app_token' : pref.getToken(),
                        'phone_num' : phoneNumber,
                        'code_type' : 1,
                      };
                      final resultDTO = await ref.read(joinFormModelProvider.notifier).reqPhoneAuthCode(requestData);
                      if (resultDTO.result == true) {
                        setState(() {
                          _phoneAuthCodeVisible = true;
                          // TODO 타이머 로직 추가
                        });
                      } else {
                        if (!context.mounted) return;
                        Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                      }
                    },
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
              Visibility(
                visible: _phoneAuthCodeVisible,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTextField('', _authCodeController, '인증번호 입력', isEnable: _phoneAuthChecked ? false : true),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (_authCodeController.text.isEmpty || _phoneAuthChecked) {
                          return;
                        }
                        // TODO 타이머 체크필요

                        final pref = await SharedPreferencesManager.getInstance();
                        final phoneNumber = _phoneController.text;
                        final authCode = _authCodeController.text;

                        Map<String, dynamic> requestData = {
                          'app_token' : pref.getToken(),
                          'phone_num' : phoneNumber,
                          'code_num' : authCode,
                          'code_type' : 1,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _phoneController.text.isNotEmpty
                            ? Colors.grey[300]
                            : Colors.grey[200],
                      ),
                      child: const Text('확인'),
                    ),
                  ],
                ),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAllFieldsFilled ? () async {
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
                        birthDay =  DateFormat("yyyy-MM-dd").format(_selectedDate!);
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
                      'id' : id,
                      'pwd' : pwd,
                      'pwd_chk' : pwdChk,
                      'name' : name ,
                      'phone_num' : phoneNum,
                      'phone_num_chk' : phoneNumChk,
                      'birth_day' : birthDay,
                      'gender' : gender,
                      'app_token' : pref.getToken(),
                    };

                    final resultDTO = await ref.read(joinFormModelProvider.notifier).join(requestData);
                    if (resultDTO.result == true) {
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JoinCompleteScreen(),
                        ),
                      );
                    } else {
                      if (!context.mounted) return;
                      Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                    }

                  } : null,
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
      Widget? suffixIcon,
      bool isEnable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (label.isNotEmpty) const SizedBox(height: 8),
        TextField(
          enabled: isEnable,
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
