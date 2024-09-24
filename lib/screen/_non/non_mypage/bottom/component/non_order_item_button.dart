import 'package:BliU/screen/_non/non_mypage/bottom/non_cancel_page.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/non_exchange_return_page.dart';
import 'package:BliU/screen/mypage/component/top/delivery_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/responsive.dart';

class NonOrderItemButton extends StatelessWidget {
  final String status;
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;
  final Map<String, dynamic> orderDetails; // 모든 정보를 포함한 맵

  const NonOrderItemButton({
    Key? key,
    required this.status,
    required this.date,
    required this.orderId,
    required this.orders,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == "상품준비중") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NonCancelPage(date: date, orderId: orderId, orders: orders,),
                  ),
                );
              },
              child: Text(
                '취소하기',
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
                // TODO 전달할 param확인

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => NonInquiryService(),
                //   ),
                // );
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
      );
    } else if (status == "배송중") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NonExchangeReturnPage(date: date, orderId: orderId, orders: orders, orderDetails: orderDetails,),
                  ),
                );
              },
              child: Text(
                '교환/반품 요청',
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DeliveryScreen(),
                //   ),
                // );
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
                // TODO 전달할 param확인

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => InquiryService(),
                //   ),
                // );
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
      );
    } else if (status == "배송완료") {
      return Column(
        children: [
          Container(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: Text(
                '구매확정',
                style: TextStyle(
                  color: Color(0xFFFF6192),
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6192)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
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
                        builder: (context) => NonExchangeReturnPage(date: date, orderId: orderId, orders: orders, orderDetails: orderDetails,),
                      ),
                    );
                  },
                  child: Text(
                    '교환/반품 요청',
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DeliveryScreen(),
                    //   ),
                    // );
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
                    // TODO 전달할 param확인

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => NonInquiryService(),
                    //   ),
                    // );
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
        ],
      );
    } else if (status == "구매확정") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DeliveryScreen(),
                //   ),
                // );
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
                // TODO 전달할 param확인

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => NonInquiryService(),
                //   ),
                // );
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
      );
    }
    return const SizedBox();
  }
}
