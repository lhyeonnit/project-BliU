//교환 반품
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/cancel_item.dart';
import 'package:BliU/screen/mypage/component/top/component/exchange_item.dart';
import 'package:BliU/screen/mypage/component/top/component/return_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/responsive.dart';

class ExchangeReturnScreen extends StatefulWidget {
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;

  const ExchangeReturnScreen({
    Key? key,
    required this.date,
    required this.orderId,
    required this.orders,
  }) : super(key: key);

  @override
  State<ExchangeReturnScreen> createState() => _ExchangeReturnScreenState();
}

class _ExchangeReturnScreenState extends State<ExchangeReturnScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> categories = ['교환', '반품/환불'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('교환/반품 요청'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 80), // 하단 버튼 공간 확보
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주문 날짜 및 ID
                CancelItem(
                    date: widget.date,
                    orderId: widget.orderId,
                    orders: widget.orders),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 교환 버튼
                      _buildCustomButton(
                        context,
                        text: "교환",
                        isSelected: selectedIndex == 0,
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                      ),
                      SizedBox(width: 8,),
                      // 반품/환불 버튼
                      _buildCustomButton(
                        context,
                        text: "반품/환불",
                        isSelected: selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _buildSelectedPage(),
              ],
            ),
          ),
          // 하단 고정 버튼
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
                    onTap: () {
                      // 확인 버튼 눌렀을 때 처리
                    },
                    child: Center(
                      child: Text(
                        '확인',
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
  Widget _buildSelectedPage() {
    if (selectedIndex == 0) {
      // 교환 페이지
      return Padding(
        padding: const EdgeInsets.symmetric(vertical:20 ),
        child: ExchangeItem(),
      );
    } else {
      // 반품/환불 페이지
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ReturnItem(),
      );
    }
  }

  Widget _buildCustomButton(BuildContext context,
      {required String text,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? Color(0xFFFF6192) : Color(0xFFDDDDDD), // 테두리 색상
              width: 1.0,
            ),
            color: Colors.white, // 배경색
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: Responsive.getFont(context, 14),
                color: isSelected ? Color(0xFFFF6192) : Colors.black,
                // 선택 시 텍스트 색상 변경
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
