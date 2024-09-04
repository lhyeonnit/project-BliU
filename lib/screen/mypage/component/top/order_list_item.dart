import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderListItem extends StatelessWidget {
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;

  const OrderListItem({
    Key? key,
    required this.date,
    required this.orderId,
    required this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE)), // 구분선 추가
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 날짜, 주문번호, 주문 상세 버튼을 하나로 묶음
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        orderId,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Color(0xFF7B7B7B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 주문 상세 보기 기능
                },
                child: Row(
                  children: [
                    Text(
                      '주문상세',
                      style: TextStyle(
                        color: const Color(0xFFFF6192),
                        fontSize: Responsive.getFont(context, 14),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      child: SvgPicture.asset(
                        'assets/images/my/ic_link_p.svg',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 같은 날짜의 주문들을 묶어서 표시
          Column(
            children: orders.map((order) {
              return _buildOrderItem(context, order);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 각 주문 아이템 빌드
  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            '${order['status']}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: Responsive.getFont(context, 15),
            ),
          ),
        ),
        // 상품 정보
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 이미지
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(
                    order['items'][0]['image'] ??
                        'assets/images/product/default.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 상품 정보 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['items'][0]['store'] ?? "",
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 12),
                          color: Color(0xFF7B7B7B)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 10),
                      child: Text(
                        order['items'][0]['name'] ?? "",
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      order['items'][0]['size'] ?? "",
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 13),
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        '${order['price']}원',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.getFont(context, 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 상태에 따라 버튼 표시
        _buildStatusButton(context, order['status']),
      ],
    );
  }

  // 상태에 따라 다른 버튼 표시
  Widget _buildStatusButton(BuildContext context, String status) {
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
