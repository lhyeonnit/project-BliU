import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//회원가입 추가정보 입력
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
      _isAllFieldsFilled = _nameController.text.isNotEmpty &&
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
        scrolledUnderElevation: 0,
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
          SingleChildScrollView(
            // 스크롤 가능하도록 설정
            child: Container(
              margin: EdgeInsets.only(top: 40, bottom: 80, right: 16, left: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '추가 정보',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 10),
                      child: Text(
                        '추가 정보를 입력해 주세요.',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFF7B7B7B)),
                      ),
                    ),
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
                                  style: TextStyle(
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
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildOrTextField(
                            '생년월일',
                            TextEditingController(
                                text: _selectedDate == null
                                    ? '생년월일 선택'
                                    : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'),
                            ''),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
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
                                        fontSize:
                                            Responsive.getFont(context, 16),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '생년월일을 입력 주시면, 생일날 쿠폰 지급!',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 12),
                                        color: Color(0xFF6A5B54)),
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
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.getFont(context, 13))),
                        Container(
                            margin: EdgeInsets.only(left: 4),
                            child: Text('선택',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.getFont(context, 13),
                                    color: Color(0xFFFF6192)))),
                      ],
                    ), // 성별 선택 타이틀
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _isAllFieldsFilled
                  ? () {
                      // 회원가입 확인 로직 추가
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
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
                    style: TextStyle(
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 13))),
                Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text('*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.getFont(context, 13),
                            color: Color(0xFFFF6192)))),
              ],
            ),
          ),
          if (label.isNotEmpty)
            TextField(
              style: TextStyle(
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
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF595959)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
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
              style: TextStyle(
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
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF595959)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 13))),
                Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text('선택',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.getFont(context, 13),
                            color: Color(0xFFFF6192)))),
              ],
            ),
          ),
          TextField(
            style: TextStyle(
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
                  fontSize: Responsive.getFont(context, 14),
                  color: Color(0xFF595959)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Color(0xFFE1E1E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Color(0xFFE1E1E1)),
              ),
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
                color: isSelected ? Color(0xFFFF6192) : Colors.black,
                fontSize: Responsive.getFont(context, 14)),
          ))),
    );
  }
}

//   Widget _buildTextField(
//       String label, TextEditingController controller, String hintText,
//       {bool obscureText = false,
//         TextInputType keyboardType = TextInputType.text,
//         Widget? suffixIcon}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label.isNotEmpty)
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         if (label.isNotEmpty) const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: obscureText,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(
//             hintText: hintText,
//             border: const OutlineInputBorder(),
//             suffixIcon: suffixIcon,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGenderButton(String gender) {
//     bool isSelected = _selectedGender == gender;
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           _selectedGender = gender;
//           _checkIfAllFieldsFilled();
//         });
//       },
//       style: ElevatedButton.styleFrom(
//         foregroundColor: isSelected ? Colors.white : Colors.black,
//         backgroundColor: isSelected ? Colors.pinkAccent : Colors.white,
//         side: BorderSide(color: isSelected ? Colors.pinkAccent : Colors.grey),
//         elevation: 0,
//         padding: const EdgeInsets.symmetric(vertical: 16.0),
//       ),
//       child: Text(gender),
//     );
//   }
// }
