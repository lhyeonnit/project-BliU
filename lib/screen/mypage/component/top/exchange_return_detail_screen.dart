import 'dart:io';

import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/exchange_return_detail_item.dart';
import 'package:BliU/screen/mypage/component/top/component/exchange_return_info.dart';
import 'package:BliU/screen/mypage/component/top/component/order_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/responsive.dart';
import '../bottom/component/inquiry_service.dart';
import 'delivery_screen.dart';

class ExchangeReturnDetailScreen extends StatefulWidget {
  final String reason; // 요청사유
  final String details; // 상세내용
  final String returnAccount;
  final String returnBank;
  final String shippingCost;
  final List<File> images;
  final String title;
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;
  final Map<String, dynamic> orderDetails; // 모든 정보를 포함한 맵

  const ExchangeReturnDetailScreen(
      {required this.reason,
      required this.details,
      required this.images,
      required this.returnAccount,
      required this.returnBank,
      required this.shippingCost,
      required this.title,
      required this.date,
      required this.orderId,
      required this.orders,
      required this.orderDetails,
      Key? key})
      : super(key: key);

  @override
  State<ExchangeReturnDetailScreen> createState() =>
      _ExchangeReturnDetailScreenState();
}

class _ExchangeReturnDetailScreenState
    extends State<ExchangeReturnDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text('${widget.title}'),
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
            child: Column(
              children: [
                ExchangeReturnDetailItem(
                    date: widget.date,
                    orderId: widget.orderId,
                    orders: widget.orders,
                    title: widget.title),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryScreen(),
                              ),
                            );
                          },
                          child: Text(
                            '배송조회',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Responsive.getFont(context, 14),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFDDDDDD)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InquiryService(),
                              ),
                            );
                          },
                          child: Text(
                            '문의하기',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Responsive.getFont(context, 14),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFDDDDDD)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      border:
                          Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('배송비',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black)),
                        Text('${widget.orderDetails['deliveryCost']}',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 10,
                  width: double.infinity,
                  color: Color(0xFFF5F9F9),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '요청일',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 14)),
                          ),
                          Text(
                            '23.03.12',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 14)),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15, bottom: 8),
                          child: Text(
                            '${widget.reason}',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 14)),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            '${widget.details}',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 14)),
                          )),
                      _buildUploadedImages(),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: widget.title == '교환'
                            ? // 교환 페이지일 때 표시
                        Text(
                          '${widget.shippingCost}',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                          ),
                        )
                            : // 반품/환불 페이지일 때 표시
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.returnBank}',
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                              ),
                            ),
                            Text(
                              '${widget.returnAccount}',
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ExchangeReturnInfo(),
                OrderDetailItem(orderDetails: widget.orderDetails),
              ],
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  Widget _buildUploadedImages() {
    return widget.images.isNotEmpty
        ? Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: Color(0xFFE7EAEF)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      widget.images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }
}
