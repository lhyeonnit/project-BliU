//교환 반품
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/cancel_item.dart';
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
  int selectedCategoryIndex = 0;

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
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final bool isSelected = selectedCategoryIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: FilterChip(
                          label: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.pink : Colors.black, // 텍스트 색상
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected ? Colors.pink : Colors.grey, // 테두리 색상
                              width: 1.0,
                            ),
                          ),
                          showCheckmark: false, // 체크 표시 없애기
                        ),
                      );
                    },
                  ),
                ),
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
}
