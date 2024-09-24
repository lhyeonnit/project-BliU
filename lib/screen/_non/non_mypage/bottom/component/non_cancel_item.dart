import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class NonCancelItem extends StatefulWidget {
  final String date;
  final String orderId;
  final List<Map<String, dynamic>> orders;

  const NonCancelItem({
    Key? key,
    required this.date,
    required this.orderId,
    required this.orders,
  }) : super(key: key);
  @override
  State<NonCancelItem> createState() => _NonCancelItemState();
}

class _NonCancelItemState extends State<NonCancelItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${widget.date}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${widget.orderId}',
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF7B7B7B),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 주문 아이템 리스트
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: widget.orders.map((order) {
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['items'][0]['store'] ?? "",
                                style: TextStyle(
                                    fontSize:
                                    Responsive.getFont(context, 12),
                                    color: Color(0xFF7B7B7B)),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(top: 4, bottom: 10),
                                child: Text(
                                  order['items'][0]['name'] ?? "",
                                  style: TextStyle(
                                    fontSize:
                                    Responsive.getFont(context, 14),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                order['items'][0]['size'] ?? "",
                                style: TextStyle(
                                  fontSize:
                                  Responsive.getFont(context, 13),
                                  color: Color(0xFF7B7B7B),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  '${order['price']}원',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    Responsive.getFont(context, 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
