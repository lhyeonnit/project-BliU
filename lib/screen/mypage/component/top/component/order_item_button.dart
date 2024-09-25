import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/mypage/component/bottom/component/inquiry_service.dart';
import 'package:BliU/screen/mypage/component/top/cancel_screen.dart';
import 'package:BliU/screen/mypage/component/top/delivery_screen.dart';
import 'package:BliU/screen/mypage/component/top/exchange_return_screen.dart';
import 'package:BliU/screen/mypage/component/top/review_write_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class OrderItemButton extends StatelessWidget {
  final OrderData orderData;
  final OrderDetailData orderDetailData;

  const OrderItemButton({super.key, required this.orderData, required this.orderDetailData,});

  @override
  Widget build(BuildContext context) {
    // TODO 테스트
    String ctStatusTxt = orderDetailData.ctStatusTxt ?? "";
    //ctStatusTxt = "상품준비중";
    //ctStatusTxt = "배송중";

    if (ctStatusTxt == "상품준비중") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CancelScreen(orderData: orderData, orderDetailData: orderDetailData,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '취소하기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
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
                    builder: (context) => InquiryService(qnaType: '3', ptIdx: orderDetailData.ptIdx,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '문의하기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (ctStatusTxt == "배송중") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExchangeReturnScreen(orderData: orderData, orderDetailData: orderDetailData,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '교환/반품 요청',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
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
                    builder: (context) => DeliveryScreen(odtCode: orderDetailData.otCode ?? "",),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '배송조회',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
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
                    builder: (context) => InquiryService(qnaType: '3', ptIdx: orderDetailData.ptIdx,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '문의하기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (ctStatusTxt == "배송완료") {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // TODO 구매 확정
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6192)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '구매확정',
                style: TextStyle(
                  color: const Color(0xFFFF6192),
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExchangeReturnScreen(orderData: orderData, orderDetailData: orderDetailData,),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '교환/반품 요청',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Responsive.getFont(context, 14),
                    ),
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
                        builder: (context) => DeliveryScreen(odtCode: orderDetailData.otCode ?? ""),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '배송조회',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Responsive.getFont(context, 14),
                    ),
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
                        builder: (context) => InquiryService(qnaType: '3', ptIdx: orderDetailData.ptIdx,),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '문의하기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (ctStatusTxt == "구매확정") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                // TODO 전달할 param확인
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ReviewWriteScreen(orders: orders,),
                //   ),
                // );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6192)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '리뷰쓰기',
                style: TextStyle(
                  color: const Color(0xFFFF6192),
                  fontSize: Responsive.getFont(context, 14),
                ),
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
                    builder: (context) => DeliveryScreen(odtCode: orderDetailData.otCode ?? ""),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '배송조회',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
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
                    builder: (context) => InquiryService(qnaType: '3', ptIdx: orderDetailData.ptIdx,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '문의하기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
