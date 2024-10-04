//내정보 수정
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/my_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/my_info_edit_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class MyInfoEditScreen extends ConsumerStatefulWidget {
  const MyInfoEditScreen({super.key});

  @override
  _MyInfoEditScreenState createState() => _MyInfoEditScreenState();
}

class _MyInfoEditScreenState extends ConsumerState<MyInfoEditScreen> {
  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  final bool _isIdChecked = false;
  bool _isAllFieldsFilled = false;
  bool _phoneAuthCodeVisible = false;
  bool _phoneAuthChecked = false;

  String? _selectedGender; // 성별을 저장하는 변수
  TextEditingController _birthController =
      TextEditingController(text: '생년월일입력');

  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _idController.addListener(_checkIfAllFieldsFilled);
    // _passwordController.addListener(_checkIfAllFieldsFilled);
    // _confirmPasswordController.addListener(_checkIfAllFieldsFilled);
    // _nameController.addListener(_checkIfAllFieldsFilled);
    // _phoneController.addListener(_checkIfAllFieldsFilled);
    // _authCodeController.addListener(_checkIfAllFieldsFilled);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMyInfo();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('내 정보 수정'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              margin: EdgeInsets.only(top: 40, bottom: 90),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 정보 수정',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 20),
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 30),
                      child: Text(
                        '회원님의 개인정보 및 연락처, 주소 등을 수정할 수 있습니다',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFF7B7B7B),
                          height: 1.2,
                        ),
                      ),
                    ),
                    _buildIdPasswordField('아이디', _idController, 'id1234',
                        isChange: _isIdChecked),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          _buildIdPasswordField('비밀번호', _passwordController,
                              '비밀번호 입력(숫자, 특수기호 포함한 7~15자)',
                              obscureText: true, isChange: true),
                          _buildCheckField(
                              '비밀번호', _confirmPasswordController, '비밀번호 재입력',
                              obscureText: true, isEnable: true),
                          GestureDetector(
                            onTap: () {
                              _editMyPassword();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xFFDDDDDD)),
                              ),
                              child: Center(
                                child: Text(
                                  '변경',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    height: 1.2,
                                  ),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildPhoneField(
                              '휴대폰번호', _phoneController, '01012345678',
                              keyboardType: TextInputType.phone,
                              isEnable: _phoneAuthChecked ? true : false),
                        ),
                        Visibility(
                          visible: !_phoneAuthChecked,
                          child: Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _phoneAuthChecked = true;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 45, left: 8),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Color(0xFFDDDDDD)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '변경',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        height: 1.2,
                                      ),
                                    )
                                  )
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _phoneAuthChecked,
                          child: Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () async {
                                _editMyPh();
                                if (_phoneController.text.isEmpty ||
                                    _phoneAuthChecked) {
                                  return;
                                }

                                final pref =
                                await SharedPreferencesManager.getInstance();
                                final phoneNumber = _phoneController.text;

                                Map<String, dynamic> requestData = {
                                  'app_token': pref.getToken(),
                                  'phone_num': phoneNumber,
                                  'code_type': 3,
                                };
                                final resultDTO = await ref
                                    .read(myInfoEditViewModelProvider.notifier)
                                    .reqPhoneAuthCode(requestData);
                                if (resultDTO.result == true) {
                                  setState(() {
                                    _phoneAuthCodeVisible = true;
                                    // TODO 타이머 로직 추가
                                  });
                                } else {
                                  if (!context.mounted) return;
                                  Utils.getInstance().showSnackBar(
                                      context, resultDTO.message.toString());
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 45, left: 8),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Color(0xFFDDDDDD)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '인증요청',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        height: 1.2,
                                      ),
                                    )
                                  )
                              ),
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
                                isEnable: _phoneAuthChecked ? true : false
                            ),
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

                                final pref = await SharedPreferencesManager
                                    .getInstance();
                                final phoneNumber = _phoneController.text;
                                final authCode = _authCodeController.text;

                                Map<String, dynamic> requestData = {
                                  'app_token': pref.getToken(),
                                  'phone_num': phoneNumber,
                                  'code_num': authCode,
                                  'code_type': 3,
                                };

                                final resultDTO = await ref
                                    .read(myInfoEditViewModelProvider.notifier)
                                    .checkCode(requestData);
                                if (!context.mounted) return;
                                Utils.getInstance().showSnackBar(
                                    context, resultDTO.message.toString());
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
                                  color: _phoneAuthChecked ?  Colors.black : const Color(0xFFDDDDDD),
                                ),
                                child: Center(
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: _phoneAuthChecked ? Colors.white : const Color(0xFF7B7B7B) ,
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
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildTextField(
                            '이름', _nameController, '김이름', keyboardType: TextInputType.name
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              _editMyName();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 45, left: 8),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xFFDDDDDD)),
                              ),
                              child: Center(
                                child: Text(
                                  '변경',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                )
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        children: [
                          Text('생년월일',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.getFont(context, 13),
                              height: 1.2,
                            )
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 4),
                              child: Text('선택',
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        border: Border.all(color: Color(0xFFDDDDDD)),
                      ),
                      child: BirthdayText(),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO 쿠폰 지급 이동
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset(
                                  'assets/images/login/coupon_banner.png'),
                            ),
                          ),
                          Positioned(
                            left: 25,
                            top: 10,
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '생일 쿠폰 지급!',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 16),
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                  Text(
                                    '생년월일을 입력 주시면, 생일날 쿠폰 지급!',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 12),
                                      color: const Color(0xFF6A5B54),
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text('성별',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.getFont(context, 13),
                            height: 1.2,
                          )
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: Text('선택',
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
                    ), // 성별 선택 타이틀
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 4),
                                child: _buildGenderButton('남자')),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(left: 4),
                                child: _buildGenderButton('여자')),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            _retire();
                          },
                          child: Text(
                            '회원탈퇴',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: const Color(0xFF7B7B7B),
                              fontSize: Responsive.getFont(context, 14),
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center, // 텍스트 가운데 정렬
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                MoveTopButton(scrollController: _scrollController),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      _isAllFieldsFilled
                          ? () {
                        _editMyInfo();
                      }
                          : null;
                    },
                    child: Container(
                      width: double.infinity,
                      height: Responsive.getHeight(context, 48),
                      margin: EdgeInsets.only(
                          right: 16.0, left: 16, top: 9, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '저장',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.white,
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
    );
  }

  Widget _buildIdPasswordField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon,
      required bool isChange}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (label.isNotEmpty)
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(label,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
                fontSize: Responsive.getFont(context, 13),
                height: 1.2,
              ),
            ),
          ),
          if (label.isNotEmpty)
            TextField(
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
              ),
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              enabled: isChange,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: isChange ? Color(0xFF595959) : Color(0xFFA4A4A4)),
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6)),
                hintText: hintText,
                fillColor: isChange ? Colors.white : Color(0xFFF5F9F9),
                // 배경색 설정
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: isChange
                      ? BorderSide(color: Color(0xFFE1E1E1))
                      : BorderSide(color: Colors.transparent),
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

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon}) {
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
              obscureText: obscureText,
              keyboardType: keyboardType,
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
                suffixIcon: suffixIcon,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoneField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon,
      required bool isEnable}) {
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
              obscureText: obscureText,
              keyboardType: keyboardType,
              enabled: isEnable,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: isEnable ? Colors.white : Color(0xFFA4A4A4)),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6)),
                hintText: hintText,
                fillColor: isEnable ? Colors.white : Color(0xFFF5F9F9),
                // 배경색 설정
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
        required bool isEnable}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            TextField(
              style: TextStyle(
                fontFamily: 'Pretendard',
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
                suffixIcon: suffixIcon,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _checkIfAllFieldsFilled();
        });
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: isSelected ? Color(0xFFFF6192) : Color(0xFFDDDDDD)),
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                fontSize: Responsive.getFont(context, 14),
                height: 1.2,
              ),
            )
          )
      ),
    );
  }

  Widget BirthdayText() {
    return GestureDetector(
      onTap: () {
        _selectDate();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        child: TextFormField(
          textAlign: TextAlign.start,
          enabled: false,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
          ),
          controller: _birthController,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: Color(0xFF595959),
          ),
        ),
      ),
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true, // 모달이 화면을 꽉 채우도록 설정
      builder: (context) {
        return Container(
          height: 400,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              // 상단 타이틀과 닫기 버튼
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, left: 16, top: 18, bottom: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '출생년도',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 18),
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFEEEEEE),
              ),
              // 날짜 선택기
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 년도 선택 부분
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          diameterRatio: 5.0,
                          itemExtent: 50,
                          selectionOverlay: Container(
                            margin: EdgeInsets.only(left: 17, right: 15),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal:
                                      BorderSide(color: Color(0xFFDDDDDD))),
                            ),
                          ),
                          squeeze: 0.9,
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedYear - 1900),
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedYear = 1900 + index;
                            });
                          },
                          children: List<Widget>.generate(
                            DateTime.now().year - 1900 + 1,
                            (int index) {
                              return Center(
                                child: Text(
                                  '${1900 + index}년', // 년도로 표시
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 16),
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // 월 선택 부분
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 50,
                          selectionOverlay: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal:
                                      BorderSide(color: Color(0xFFDDDDDD))),
                            ),
                          ),
                          diameterRatio: 5.0,
                          squeeze: 0.9,
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedMonth - 1),
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedMonth = index + 1;
                            });
                          },
                          children: List<Widget>.generate(12, (int index) {
                            return Center(
                              child: Text(
                                '${index + 1}월', // 월로 표시
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 16),
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            );
                          }),
                        ),
                      ), // 일 선택 부분
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 50,
                          selectionOverlay: Container(
                            margin: EdgeInsets.only(left: 15, right: 17),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal:
                                      BorderSide(color: Color(0xFFDDDDDD))),
                            ),
                          ),
                          diameterRatio: 5.0,
                          squeeze: 0.9,
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedDay - 1),
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedDay = index + 1;
                            });
                          },
                          children: List<Widget>.generate(31, (int index) {
                            return Center(
                              child: Text(
                                '${index + 1}일', // 일로 표시
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 16),
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // '선택하기' 버튼
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(
                      selectedYear,
                      selectedMonth,
                      selectedDay,
                    );
                    _birthController.text =
                        convertDateTimeDisplay(_selectedDate.toString());
                  });
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: double.infinity,
                  height: Responsive.getHeight(context, 48),
                  margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '선택하기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthController.text = convertDateTimeDisplay(pickedDate.toString());
      });
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('yyyy년 MM월 dd일');
    final DateTime displayDate = displayFormatter.parse(date);
    return serverFormatter.format(displayDate);
  }
  void _getMyInfo() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'auth_token' : pref.getToken(),
    };

    await ref.read(myInfoEditViewModelProvider.notifier).getMyInfo(requestData);
  }
  void _editMyInfo() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String birthDay = "";
    try {
      if (_selectedDate != null) {
        birthDay = DateFormat("yyyy-MM-dd").format(_selectedDate!);
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
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'mt_birth' : birthDay,
      'mt_gender' : gender,
    };
    final resultDTO = await ref.read(myInfoEditViewModelProvider.notifier).editMyInfo(requestData);
    if (resultDTO.result == true) {
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyScreen(),
        ),
      );
    } else {
      if (!context.mounted) return;
      Utils.getInstance().showSnackBar(
          context, resultDTO.message.toString());
    }
  }
  void _editMyName() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final name = _nameController.text;
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'mt_name' : name,
    };
    await ref.read(myInfoEditViewModelProvider.notifier).editMyName(requestData);
  }
  void _editMyPh() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final phone = _phoneController.text;

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'mt_hp' :phone,
    };
    await ref.read(myInfoEditViewModelProvider.notifier).editMyPh(requestData);

  }
  void _editMyPassword() async {
    if (_passwordController.text !=
        _confirmPasswordController.text) {
      Utils.getInstance()
          .showSnackBar(context, "비밀번호가 서로 다릅니다 다시 입력해 주세요.");
      return;
    }
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'pwd' :password,
      'pwd_chk' :confirmPassword,
      'pwd_token' :pref.getToken(),
    };
    await ref.read(myInfoEditViewModelProvider.notifier).editMyPassword(requestData);
  }
  void _retire() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
    };
    final resultDTO = await ref.read(myInfoEditViewModelProvider.notifier).retire(requestData);
    Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
  }
}
