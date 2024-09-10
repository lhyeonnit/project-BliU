import 'dart:io';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/payment_data.dart';
import 'package:BliU/screen/payment/component/payment_address_info.dart';
import 'package:BliU/screen/payment/component/payment_discount.dart';
import 'package:BliU/screen/payment/component/payment_money.dart';
import 'package:BliU/screen/payment/component/payment_order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

import '../../utils/responsive.dart';
import '../_component/move_top_button.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartDetails;

  const PaymentScreen(
      {required this.cartDetails, super.key});

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  double selectedDiscountRate = 0.0;

  void onCouponSelected(double discountRate) {
    setState(() {
      selectedDiscountRate = discountRate;
    });
  }  final ScrollController _scrollController = ScrollController();
  late bool isUseAddress = false;
  String? savedRecipientName; // 저장된 수령인 이름
  String? savedRecipientPhone; // 저장된 전화번호
  String? savedAddressRoad; // 저장된 도로명 주소
  String? savedAddressDetail; // 저장된 상세주소
  String? savedMemo; // 저장된 메모

  // 배송지 정보 저장 함수
  void _saveAddress(String name, String phone, String road, String detail,
      String memo) {
    setState(() {
      savedRecipientName = name;
      savedRecipientPhone = phone;
      savedAddressRoad = road;
      savedAddressDetail = detail;
      savedMemo = memo;
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, List<Map<String, dynamic>>> storeGroupedItems = {};
    for (var item in widget.cartDetails) {
      int storeId = item['storeId'];
      if (!storeGroupedItems.containsKey(storeId)) {
        storeGroupedItems[storeId] = [];
      }
      storeGroupedItems[storeId]!.add(item);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: const Text("결제하기"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: ListView(
              children: [
                CustomExpansionTile(
                  title: '주문상품',
                  content: Column(
                    children: [
                      ...storeGroupedItems.entries.map((entry) {
                        int storeId = entry.key;
                        List<Map<String, dynamic>> items = entry.value;

                        bool isLastStore =
                            storeGroupedItems.entries.last.key == storeId;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 스토어명
                            Container(
                              margin: const EdgeInsets.only(
                                  right: 16, left: 16, bottom: 10, top: 20),
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      border: Border.all(
                                        color: const Color(0xFFDDDDDD),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: Image.asset(
                                        items.first['storeLogo'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 10),
                                    child: Text(
                                      items.first['storeName'],
                                      style: TextStyle(
                                        fontSize: Responsive.getFont(
                                            context, 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: items
                                  .where((item) => item['isSelected'] == true)
                                  .map((item) {
                                return PaymentOrderItem(
                                  item: item,
                                );
                              }).toList(),
                            ),
                            if (!isLastStore)
                              const Divider(
                                  thickness: 1, color: Color(0xFFEEEEEE)),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Color(0xFFF5F9F9),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '배송지 정보',
                            style: TextStyle(
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isUseAddress = !isUseAddress;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    border: Border.all(
                                      color: isUseAddress
                                          ? const Color(0xFFFF6191)
                                          : const Color(0xFFCCCCCC),
                                    ),
                                    color: isUseAddress
                                        ? const Color(0xFFFF6191)
                                        : Colors.white,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/check01_off.svg', // 체크박스 아이콘
                                    color: isUseAddress
                                        ? Colors.white
                                        : const Color(0xFFCCCCCC),
                                    height: 10,
                                    width: 10,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '다음에도 이 배송지 사용',
                                style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFEEEEEE),
                            ),
                          ),
                        ),
                        child: PaymentAddressInfo(
                          onSave: _saveAddress,
                          initialName: savedRecipientName ?? '',
                          initialPhone: savedRecipientPhone ?? '',
                          initialRoadAddress: savedAddressRoad ?? '',
                          initialDetailAddress: savedAddressDetail ?? '',
                          initialMemo: savedMemo ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Color(0xFFF5F9F9),
                ),
                CustomExpansionTile(
                  title: '할인적용',
                  content: PaymentDiscount(onCouponSelected: onCouponSelected,),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Color(0xFFF5F9F9),
                ),
                CustomExpansionTile(
                  title: '결제 금액',
                  content: PaymentMoney(
                    cartDetails: widget.cartDetails
                        .where((item) =>
                    item['isSelected'] == true) // 선택된 항목만 전달
                        .toList(),discountRate: selectedDiscountRate,
                  ),
                ),
              ],
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
                  height: Responsive.getHeight(context, 48),
                  margin:
                  EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                    },
                    child: Center(
                      child: Text(
                        '결제하기',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.white,
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
}

// Custom ExpansionTile Widget
class CustomExpansionTile extends StatelessWidget {
  final String title;
  final Widget content;

  const CustomExpansionTile({
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFEEEEEE),
                ),
              ),
            ),
            child: content,
          ),
        ],
      ),
    );
  }
}
