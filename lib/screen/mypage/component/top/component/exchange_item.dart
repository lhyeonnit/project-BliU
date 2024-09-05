import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../utils/responsive.dart';

class ExchangeItem extends StatefulWidget {
  const ExchangeItem({super.key});

  @override
  State<ExchangeItem> createState() => _ExchangeItemState();
}

class _ExchangeItemState extends State<ExchangeItem> {
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
      Overlay.of(context)?.insert(_overlayEntry!);
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
    return Padding(
      padding: EdgeInsets.only(bottom: 80),
      // 하단 버튼 공간 확보
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 취소사유 선택
          Padding(
            padding: EdgeInsets.symmetric(
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
                            color: Color(0xFFE1E1E1),
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
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextField(
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 14, horizontal: 15),
                      hintText: '세부 내용 입력',
                      hintStyle: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Color(0xFF595959)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(6)),
                        borderSide:
                        BorderSide(color: Color(0xFFE1E1E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
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
                            color: Color(0xFF7B7B7B),
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 10,
            width: double.infinity,
            color: Color(0xFFF5F9F9),
          ),
          // 환불 정보 및 환불 예정 금액
          Container(
            padding:
            EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: Text(
              '환불정보',
              style: TextStyle(
                  fontSize: Responsive.getFont(context, 18),
                  fontWeight: FontWeight.bold),
            ),
          ),
          // 배송지 정보 세부 내용
          Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFEEEEEE),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text('포인트환급액',
                          style: TextStyle(
                              fontSize:
                              Responsive.getFont(context, 14),
                              color: Colors.black)),
                      Text('1,042원',
                          style: TextStyle(
                              fontSize:
                              Responsive.getFont(context, 14),
                              color: Colors.black)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('배송비차감액',
                            style: TextStyle(
                                fontSize:
                                Responsive.getFont(context, 14),
                                color: Colors.black)),
                      ),
                      Text('(-) 0원',
                          style: TextStyle(
                              fontSize:
                              Responsive.getFont(context, 14),
                              color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 10,
            width: double.infinity,
            color: Color(0xFFF5F9F9),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '환불예정금액',
                  style: TextStyle(
                      fontSize: Responsive.getFont(context, 18),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '13,366원',
                  style: TextStyle(
                      fontSize: Responsive.getFont(context, 14),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // 배송지 정보 세부 내용
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFEEEEEE),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text('환불방법',
                          style: TextStyle(
                              fontSize:
                              Responsive.getFont(context, 14),
                              color: Colors.black)),
                      Text('카드승인취소',
                          style: TextStyle(
                              fontSize:
                              Responsive.getFont(context, 14),
                              color: Colors.black)),
                    ],
                  ),
                )
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
          offset: Offset(0, 50), // 드롭다운이 열리는 위치 설정
          child: Material(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE1E1E1)),
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

