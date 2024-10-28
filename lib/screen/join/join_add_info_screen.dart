import 'dart:async';

import 'package:BliU/data/pay_order_detail_data.dart';
import 'package:BliU/screen/join/viewmodel/join_add_info_view_model.dart';
import 'package:BliU/screen/payment/payment_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class JoinAddInfoScreen extends ConsumerStatefulWidget {
  final PayOrderDetailData payOrderDetailData;
  final int memberType;
  const JoinAddInfoScreen({super.key, required this.memberType, required this.payOrderDetailData});

  @override
  ConsumerState<JoinAddInfoScreen> createState() => JoinAddInfoScreenState();
}

class JoinAddInfoScreenState extends ConsumerState<JoinAddInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isAllFieldsFilled = false;
  bool _phoneAuthCodeVisible = false;
  bool _phoneAuthChecked = false;
  String? _selectedGender;

  final TextEditingController _birthController = TextEditingController(text: '생년월일 입력');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  int _authSeconds = 180;
  String _timerStr = "00:00";
  Timer? _timer;

  void _showCancelDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      // 다른 영역을 클릭해도 닫힘
      // barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // barrierColor: Colors.black.withOpacity(0.5),
      // 배경을 어둡게
      transitionDuration: const Duration(milliseconds: 100),
      // 애니메이션 시간
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter, // 화면 상단 중앙에 배치
          child: Material(
            color: Colors.transparent, // 배경을 투명하게
            child: Container(
              margin: const EdgeInsets.only(top: 50), // 상단에서의 간격
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xCC000000), // 알림창 배경색
                borderRadius: BorderRadius.circular(22), // 둥근 모서리
              ),
              child: Text(
                '추가정보 입력이 완료되었습니다.',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
          _phoneAuthChecked;
    });
  }

  void _authTimerStart() {
    if (_timer != null) {
      _timer?.cancel();
    }

    setState(() {
      _authSeconds = 180;
      _timerStr = "03:00";
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (_authSeconds == 0) {
          t.cancel();
        } else {
          _authSeconds--;

          int min = _authSeconds~/60;
          int sec = _authSeconds%60;
          String secStr = "";
          if (sec < 10) {
            secStr = "0$sec";
          } else {
            secStr = sec.toString();
          }

          _timerStr = "0$min:$secStr";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // 스크롤 가능하도록 설정
              child: Container(
                margin: const EdgeInsets.only(top: 40, bottom: 80, right: 16, left: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '추가 정보',
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
                          '추가 정보를 입력해 주세요.',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: const Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                      _buildTextField('이름', _nameController, '이름 입력', keyboardType: TextInputType.name),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: _buildTextField(
                                '휴대폰번호', _phoneController, "'-'없이 숫자만 입력",
                                keyboardType: TextInputType.phone,
                                isEnable: _phoneAuthChecked ? false : true
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Visibility(
                                    visible: _phoneAuthCodeVisible && !_phoneAuthChecked,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20, left: 8),
                                      child: Text(
                                        _timerStr,
                                        style: TextStyle(
                                          color: const Color(0xFFFF6192),
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 13),
                                          height: 1.2,
                                        ),
                                      ),
                                    )
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_phoneController.text.isEmpty || _phoneAuthChecked) {
                                      return;
                                    }

                                    final pref = await SharedPreferencesManager.getInstance();
                                    final phoneNumber = _phoneController.text;

                                    Map<String, dynamic> requestData = {
                                      'app_token': pref.getToken(),
                                      'phone_num': phoneNumber,
                                      'code_type': 4,
                                    };
                                    final resultDTO = await ref.read(joinAddInfoModelProvider.notifier).reqPhoneAuthCode(requestData);
                                    if (resultDTO.result == true) {
                                      setState(() {
                                        _phoneAuthChecked = false;
                                        _phoneAuthCodeVisible = true;
                                        _authTimerStart();
                                      });
                                    } else {
                                      if (!context.mounted) return;
                                      Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                                    }
                                  },
                                  child: Container(
                                      height: 44,
                                      margin: const EdgeInsets.only(top: 10, left: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFFDDDDDD)),
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
                                )
                              ],
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
                                  '휴대폰번호', _authCodeController, keyboardType: TextInputType.number, '인증번호 입력',
                                  isEnable: _phoneAuthChecked ? false : true),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () async {
                                  if (_authCodeController.text.isEmpty || _phoneAuthChecked) {
                                    return;
                                  }
                                  if (_authSeconds <= 0) {
                                    return;
                                  }

                                  final pref = await SharedPreferencesManager.getInstance();
                                  final phoneNumber = _phoneController.text;
                                  final authCode = _authCodeController.text;

                                  Map<String, dynamic> requestData = {
                                    'app_token': pref.getToken(),
                                    'phone_num': phoneNumber,
                                    'code_num': authCode,
                                    'code_type': 4,
                                  };

                                  final resultDTO = await ref.read(joinAddInfoModelProvider.notifier).checkCode(requestData);
                                  if (!context.mounted) return;
                                  Utils.getInstance().showSnackBar(context, resultDTO.message.toString());
                                  if (resultDTO.result == true) {
                                    setState(() {
                                      _phoneAuthChecked = true;
                                      _checkIfAllFieldsFilled();
                                    });
                                  }
                                },
                                child: Container(
                                  height: 44,
                                  margin: const EdgeInsets.only(top: 10, left: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: _phoneAuthChecked ? const Color(0xFFDDDDDD) : Colors.black,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: _phoneAuthChecked ? const Color(0xFF7B7B7B) : Colors.white,
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
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          children: [
                            Text('생년월일',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.getFont(context, 13),
                                height: 1.2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              child: Text(
                                '선택',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.getFont(context, 13),
                                  color: const Color(0xFFFF6192),
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                        ),
                        child: _birthdayText(),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset('assets/images/login/coupon_banner.png'),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 10,
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
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
                            ),
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
                              ),
                            ),
                          ),
                        ],
                      ), // 성별 선택 타이틀
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: _buildGenderButton('남자')
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  child: _buildGenderButton('여자')
                              ),
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
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: GestureDetector(
                  onTap: _isAllFieldsFilled
                      ? () async {
                    String name = _nameController.text;
                    String phoneNum = _phoneController.text;
                    String birthDay = "";
                    try {
                      birthDay = DateFormat("yyyy-MM-dd").format(_selectedDate);
                    } catch (e) {
                      if (kDebugMode) {
                        print("DateError $e");
                      }
                    }
                    String gender = "";
                    if (_selectedGender == "남자") {
                      gender = "M";
                    } else if (_selectedGender == "여자") {
                      gender = "F";
                    }

                    final pref = await SharedPreferencesManager.getInstance();
                    Map<String, dynamic> requestData = {
                      "mt_idx": pref.getMtIdx(),
                      'mt_name': name,
                      'mt_hp': phoneNum,
                      'mt_birth': birthDay,
                      'mt_gender': gender,
                    };

                    final myPageInfoDTO = await ref.read(joinAddInfoModelProvider.notifier).snsAddInfo(requestData);
                    if (myPageInfoDTO.result == true) {
                      name = myPageInfoDTO.data?.mtName ?? '';
                      phoneNum = myPageInfoDTO.data?.mtHp ?? '';
                      birthDay = myPageInfoDTO.data?.mtBirth ?? '';
                      gender = myPageInfoDTO.data?.mtGender ?? '';

                      setState(() {
                        widget.payOrderDetailData.userInfoCheck == 'Y';
                      });
                      if (!context.mounted) return;
                      _showCancelDialog(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            payOrderDetailData: widget.payOrderDetailData,
                            memberType: widget.memberType,
                          ),
                        ),
                      );
                    } else {
                      if (!context.mounted) return;
                      final message = myPageInfoDTO.message ?? "";
                      Utils.getInstance().showSnackBar(context, message);
                    }
                  }
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                    decoration: BoxDecoration(
                      color: _isAllFieldsFilled ? Colors.black : const Color(0xFFDDDDDD),
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
                          color: _isAllFieldsFilled ? Colors.white : const Color(0xFF7B7B7B),
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        Widget? suffixIcon,
        bool isEnable = true,
        FocusNode? focusNode}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (label.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(bottom: 10, top: 20),
          child: Row(
            children: [
              Text(label,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFont(context, 13),
                  height: 1.2,
                ),
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
          SizedBox(
            height: 44,
            child: TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              focusNode: focusNode,
              style: TextStyle(
                  decorationThickness: 0,
                  height: 1.2,
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14)
              ),
              enabled: isEnable,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: const Color(0xFF595959)
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCheckField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        Widget? suffixIcon,
        bool isEnable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Container(
            height: 44,
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              style: TextStyle(
                decorationThickness: 0,
                height: 1.2,
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
                    color: isEnable ? const Color(0xFF595959) : const Color(0xFFA4A4A4)),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: hintText,
                fillColor: isEnable ? Colors.white : const Color(0xFFF5F9F9),
                // 배경색 설정
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  borderSide: isEnable ? const BorderSide(color: Color(0xFFE1E1E1)) : const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
      ],
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
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)
            ),
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
  Widget _birthdayText() {
    return GestureDetector(
      onTap: () {
        _selectDate();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
          ),
          controller: _birthController,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: const Color(0xFF595959),
          ),
        ),
      ),
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: Colors.white,
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              int maxDay = DateTime(selectedYear, selectedMonth + 1, 0).day;

              return Container(
                height: 400,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16, top: 15, bottom: 15),
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
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEEEEEE),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                diameterRatio: 5.0,
                                itemExtent: 50,
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.only(left: 17, right: 15),
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(color: Color(0xFFDDDDDD)),
                                    ),
                                  ),
                                ),
                                squeeze: 1,
                                scrollController: FixedExtentScrollController(initialItem: selectedYear - 1900),
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedYear = 1900 + index;
                                    maxDay = DateTime(selectedYear, selectedMonth + 1, 0).day;
                                    if (selectedDay > maxDay) selectedDay = maxDay;
                                  });
                                },
                                children: List<Widget>.generate(
                                  DateTime.now().year - 1900 + 1,
                                      (int index) => Center(
                                    child: Text(
                                      '${1900 + index}년',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 16),
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                itemExtent: 50,
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(color: Color(0xFFDDDDDD)),
                                    ),
                                  ),
                                ),
                                diameterRatio: 5.0,
                                squeeze: 1,
                                scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedMonth = index + 1;
                                    maxDay = DateTime(selectedYear, selectedMonth + 1, 0).day;
                                    if (selectedDay > maxDay) selectedDay = maxDay;
                                  });
                                },
                                children: List<Widget>.generate(12, (int index) => Center(
                                  child: Text(
                                    '${index + 1}월',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 16),
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                )),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                itemExtent: 50,
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.only(left: 15, right: 17),
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(color: Color(0xFFDDDDDD)),
                                    ),
                                  ),
                                ),
                                diameterRatio: 5.0,
                                squeeze: 1,
                                scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                                onSelectedItemChanged: (int index) {
                                  setModalState(() {
                                    selectedDay = index + 1;
                                  });
                                },
                                children: List<Widget>.generate(
                                  maxDay,
                                      (int index) => Center(
                                    child: Text(
                                      '${index + 1}일',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 16),
                                        fontWeight: FontWeight.w600,
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
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
                          _birthController.text = convertDateTimeDisplay(_selectedDate.toString());
                        });
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                          child: Text(
                            '선택하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.white,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
}
