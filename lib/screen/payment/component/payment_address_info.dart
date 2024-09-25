import 'package:BliU/data/daum_post_data.dart';
import 'package:BliU/screen/payment/component/webview_with_daum_post_webivew.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class PaymentAddressInfo extends StatefulWidget {
  final Function(String, String, String, String, String, String) onSave;
  final String initialName;
  final String initialPhone;
  final String initialZip;
  final String initialRoadAddress;
  final String initialDetailAddress;
  final String initialMemo;

  const PaymentAddressInfo({
    super.key,
    required this.onSave,
    required this.initialName,
    required this.initialPhone,
    required this.initialZip,
    required this.initialRoadAddress,
    required this.initialDetailAddress,
    required this.initialMemo,
  });

  @override
  State<PaymentAddressInfo> createState() => _PaymentAddressInfoState();
}

class _PaymentAddressInfoState extends State<PaymentAddressInfo> {
  late String _receiveName = widget.initialName;
  late String _receiveTel = widget.initialPhone;
  late String _receiveZip = widget.initialZip;
  late String _addressRoad = widget.initialRoadAddress;
  late String _addressDetail = widget.initialDetailAddress;
  late String _deliveryMemo = widget.initialMemo;

  final TextEditingController _roadAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Text(
                        '수령인',
                        style: TextStyle( fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 13),
                        ),
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle( fontFamily: 'Pretendard',
                        color: const Color(0xFFFF6192),
                        fontSize: Responsive.getFont(context, 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      hintText: '수령인',
                      hintStyle: TextStyle( fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF595959)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _receiveName = value;
                        widget.onSave(_receiveName, _receiveTel, _receiveZip, _addressRoad,
                            _addressDetail, _deliveryMemo);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Text(
                        '휴대폰',
                        style: TextStyle( fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 13),
                        ),
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle( fontFamily: 'Pretendard',
                        color: const Color(0xFFFF6192),
                        fontSize: Responsive.getFont(context, 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      hintText: '‘-’ 없이 번호만 입력',
                      hintStyle: TextStyle( fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF595959)
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _receiveTel = value;
                        widget.onSave(_receiveName, _receiveTel, _receiveZip, _addressRoad,
                            _addressDetail, _deliveryMemo);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Text(
                        '주소',
                        style: TextStyle( fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 13),
                        ),
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle( fontFamily: 'Pretendard',
                        color: const Color(0xFFFF6192),
                        fontSize: Responsive.getFont(context, 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: TextField(
                            controller: _roadAddressController,
                            enabled: false,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 15
                              ),
                              hintText: '주소를 검색해 주세요.',
                              hintStyle: TextStyle( fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: const Color(0xFF595959)
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(6)),
                                borderSide:
                                BorderSide(color: Color(0xFFE1E1E1)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () async {
                              // 주소 검색 API 호출
                              DaumPostData? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WebviewWithDaumPostWebview(), // 주소 검색 창으로 이동
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  _roadAddressController.text = result.roadAddress;
                                  _receiveZip = result.zonecode;
                                  _addressRoad = result.roadAddress; // 검색된 주소로 도로명 주소 업데이트
                                  widget.onSave(
                                      _receiveName,
                                      _receiveTel,
                                      _receiveZip,
                                      _addressRoad,
                                      _addressDetail,
                                      _deliveryMemo);
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                border:
                                    Border.all(color: const Color(0xFFE1E1E1)),
                              ),
                              child: Center(
                                child: Text(
                                  '주소검색',
                                  style: TextStyle( fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 15
                          ),
                          hintText: '상세주소 입력',
                          hintStyle: TextStyle( fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: const Color(0xFF595959)),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _addressDetail = value;
                            widget.onSave(_receiveName, _receiveTel, _receiveZip,
                                _addressRoad, _addressDetail, _deliveryMemo);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
              hintText: '배송 메모 입력',
              hintStyle: TextStyle( fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                color: const Color(0xFF595959)
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Color(0xFFE1E1E1)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Color(0xFFE1E1E1)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _deliveryMemo = value;
                widget.onSave(_receiveName, _receiveTel, _receiveZip, _addressRoad,
                    _addressDetail, _deliveryMemo);
              });
            },
          ),
        ),
      ],
    );
  }
}
