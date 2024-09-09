import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/responsive.dart';

class PaymentAddressInfo extends StatefulWidget {
  const PaymentAddressInfo({super.key});

  @override
  State<PaymentAddressInfo> createState() => _PaymentAddressInfoState();
}

class _PaymentAddressInfoState extends State<PaymentAddressInfo> {
  String _receiveName = '';
  String _receiveTel = '';
  String _deliveryMemo = '';
  String _addressDetail = '';
  String _addressRoad = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 4),
                      child: Text(
                        '수령인',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 13),
                        ),
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        color: Color(0xFFFF6192),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      hintText: '수령인',
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
                    onChanged: (value) {
                      setState(() {
                        _receiveName = value;
                        // _updateCollectedData();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 4),
                      child: Text(
                        '휴대폰',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 13),
                        ),
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        color: Color(0xFFFF6192),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      hintText: '‘-’ 없이 번호만 입력',
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
                    onChanged: (value) {
                      setState(() {
                        _receiveTel = value;
                        // _updateCollectedData();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
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
                      margin: EdgeInsets.only(right: 4),
                      child: Text(
                        '주소',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 13),
                        ),
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        color: Color(0xFFFF6192),
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
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 15),
                              hintText: '',
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
                            ),
                            onChanged: (value) {
                              setState(() {
                                _receiveTel = value;
                                // _updateCollectedData();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                border: Border.all(color: Color(0xFFE1E1E1)),
                              ),
                              child: Center(
                                  child: Text(
                                '주소검색',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14), fontWeight: FontWeight.normal),
                              )),
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 15),
                          hintText: '상세주소 입력',
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
                        onChanged: (value) {
                          setState(() {
                            _addressDetail = value;
                            // _updateCollectedData();
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
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 15),
              hintText: '배송 메모 입력',
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
            onChanged: (value) {
              setState(() {
                _deliveryMemo = value;
                // _updateCollectedData();
              });
            },
          ),
        ),
      ],
    );
  }
}
