import 'package:BliU/screen/_non/non_mypage/bottom/component/non_order_list_page.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NonOrderPage extends StatefulWidget {
  const NonOrderPage({super.key});

  @override
  State<NonOrderPage> createState() => _NonOrderPageState();
}

class _NonOrderPageState extends State<NonOrderPage> {
  bool _isAllFieldsFilled = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _deliveryCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkIfAllFieldsFilled);
    _phoneController.addListener(_checkIfAllFieldsFilled);
    _deliveryCodeController.addListener(_checkIfAllFieldsFilled);
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      _isAllFieldsFilled =
          _nameController.text.isNotEmpty &&
              _phoneController.text.isNotEmpty &&
              _deliveryCodeController.text.isNotEmpty;
      // && _selectedDate != null
      // && _selectedGender != null; // 성별이 선택되었는지 확인
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
        title: const Text('비회원구매조회'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('이름', _nameController, '수령인 이름 입력',
                    keyboardType: TextInputType.name),
                _buildTextField('휴대폰번호', _phoneController, '휴대폰 번호 입력',
                  keyboardType: TextInputType.phone,),
                _buildTextField('주문번호', _deliveryCodeController, '주문번호 입력',
                  keyboardType: TextInputType.text,),
                Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text('주문번호는 주문자의 휴대폰 번호로 발송됩니다. \n주문번호 확인이 어려울 시, 고객센터로 문의 바랍니다.', style: TextStyle(fontSize: Responsive.getFont(context, 12)),))
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              // TODO 비회원 구매 조회 로직 추가
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NonOrderListPage()
                  ),
                );
              },
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

  Widget _buildTextField(String label, TextEditingController controller,
      String hintText,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,}) {
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
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
