import 'package:flutter/material.dart';

import '../../../../utils/responsive.dart';

class OrderItemButton extends StatelessWidget {
  final String status;
  const OrderItemButton({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == "상품준비중") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {},
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
              onPressed: () {},
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
              onPressed: () {},
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
              onPressed: () {},
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
              onPressed: () {},
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
                  onPressed: () {},
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
                  onPressed: () {},
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
                  onPressed: () {},
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
              onPressed: () {},
              child: Text(
                '리뷰쓰기',
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
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () {},
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
              onPressed: () {},
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
