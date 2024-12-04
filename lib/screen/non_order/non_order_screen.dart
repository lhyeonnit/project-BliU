import 'package:BliU/screen/non_order/view_model/non_order_view_model.dart';
import 'package:BliU/screen/order_list/order_list_screen.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NonOrderScreen extends ConsumerStatefulWidget {
  const NonOrderScreen({super.key});

  @override
  ConsumerState<NonOrderScreen> createState() => NonOrderScreenState();
}

class NonOrderScreenState extends ConsumerState<NonOrderScreen> {
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
      _isAllFieldsFilled = _nameController.text.isNotEmpty &&
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
      appBar: MyAppBar(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text('비회원구매조회'),
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
              color: const Color(0x0D000000), // 하단 구분선 색상
              height: 1.0, // 구분선의 두께 설정
              child: Container(
                height: 1.0, // 그림자 부분의 높이
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 6.0,
                      spreadRadius: 0.1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Utils.getInstance().isWebView(
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('이름', _nameController, '수령인 이름 입력',
                        keyboardType: TextInputType.name),
                    _buildTextField(
                      '휴대폰번호',
                      _phoneController,
                      '휴대폰 번호 입력',
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      '주문번호',
                      _deliveryCodeController,
                      '주문번호 입력',
                      keyboardType: TextInputType.text,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(
                        '주문번호는 주문자의 휴대폰 번호로 발송됩니다. \n주문번호 확인이 어려울 시, 고객센터로 문의 바랍니다.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 12),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final name = _nameController.text;
                    final phone = _phoneController.text;
                    final deliveryCode = _deliveryCodeController.text;

                    if(name.isEmpty) {
                      Utils.getInstance().showSnackBar(context, "이름을 입력해 주세요.");
                      return;
                    }

                    if(phone.isEmpty) {
                      Utils.getInstance().showSnackBar(context, "휴대폰 번호를 입력해 주세요.");
                      return;
                    }

                    if(deliveryCode.isEmpty) {
                      Utils.getInstance().showSnackBar(context, "주문 번호를 입력해 주세요.");
                      return;
                    }

                    Map<String, dynamic> requestData = {
                      'name' : name,
                      'hp' : phone,
                      'ot_code' : deliveryCode,
                    };

                    final responseData = await ref.read(nonOrderViewModelProvider.notifier).getFindOrder(requestData);
                    if (responseData != null) {
                      if (responseData["result"] == true) {
                        if (!context.mounted) return;
                        final otCode = responseData["data"]["ot_code"].toString();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OrderListScreen(otCode: otCode)),
                        );
                      } else {
                        if (!context.mounted) return;
                        Utils.getInstance().showSnackBar(context, responseData["data"]["message"]);
                      }
                    }
                  },
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hintText, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (label.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
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
            TextField(
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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: const Color(0xFF595959),
                  height: 1.2,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: const OutlineInputBorder(
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
