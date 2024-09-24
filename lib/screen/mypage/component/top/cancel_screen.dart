import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/cancel_item.dart';
import 'package:BliU/screen/mypage/component/top/component/exchange_return_info.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CancelScreen extends StatefulWidget {
  final OrderData orderData;
  final OrderDetailData orderDetailData;

  const CancelScreen({super.key, required this.orderData, required this.orderDetailData,});

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  String _dropdownValue = '취소사유 선택';
  String _detailedReason = '';
  final LayerLink _layerLink = LayerLink();
  final List<String> _cancelReasons = [
    '단순 변심',
    '상품 정보 변경',
    '배송 지연 예상',
    '결제 실수',
    '재주문 예정',
    '기타',
  ];

  // 드롭다운 생성.
  void _createOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _customDropdown();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  // 드롭다운 해제.
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('취소요청'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: SvgPicture.asset("assets/images/product/ic_close.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
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
            padding: const EdgeInsets.only(bottom: 50), // 하단 버튼 공간 확보
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주문 날짜 및 ID
                CancelItem(orderData: widget.orderData, orderDetailData: widget.orderDetailData,),
                // 취소사유 선택
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  // 하단 버튼 공간 확보
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 취소사유 선택
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_overlayEntry == null) {
                                  _createOverlay();
                                } else {
                                  _removeOverlay();
                                }
                              },
                              child: Center(
                                child: CompositedTransformTarget(
                                  link: _layerLink,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFE1E1E1),
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // 선택값.
                                        Text(
                                          _dropdownValue,
                                          style: TextStyle(
                                            fontSize:
                                                Responsive.getFont(context, 14),
                                            color: Colors.black,
                                          ),
                                        ),

                                        // 아이콘.
                                        SvgPicture.asset(
                                            'assets/images/product/ic_select.svg'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),),
                                maxLines: 4,
                                maxLength: 500,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 15),
                                  hintText: '세부 내용 입력',
                                  hintStyle: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: const Color(0xFF595959)),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE1E1E1)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFE1E1E1)),
                                  ),
                                  counter: Align(
                                    alignment: Alignment.centerLeft, // 왼쪽 정렬
                                    child: Text(
                                      '${_detailedReason.length}/500',
                                      style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 13),
                                        color: const Color(0xFF7B7B7B),
                                      ),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _detailedReason = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ExchangeReturnInfo(),
                    ],
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
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      // 확인 버튼 눌렀을 때 처리
                    },
                    child: Container(
                      height: Responsive.getHeight(context, 48),
                      margin: const EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(6),),
                      ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry _customDropdown() {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.9, // 드롭다운 너비 설정
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50), // 드롭다운이 열리는 위치 설정
          child: Material(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE1E1E1)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: _cancelReasons.length,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    pressedOpacity: 1,
                    minSize: 0,
                    onPressed: () {
                      setState(() {
                        _dropdownValue = _cancelReasons.elementAt(index);
                      });
                      _removeOverlay();
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _cancelReasons.elementAt(index),
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
