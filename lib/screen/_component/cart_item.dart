import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/responsive.dart';

class CartItem extends StatefulWidget {
  final Map<String, dynamic> item; // 장바구니 항목 데이터
  final int index;
  final Function(int) onIncrementQuantity;
  final Function(int) onDecrementQuantity;
  final Function(int) onDelete;

  const CartItem({
    Key? key,
    required this.item,
    required this.index,
    required this.onIncrementQuantity,
    required this.onDecrementQuantity,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool _isSelected = false; // 선택 여부 상태 관리

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: Responsive.getWidth(context, 380),
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected; // 체크박스 선택 상태 변경
                });
              },
              child: Container(
                padding: EdgeInsets.all(6),
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: _isSelected ? Color(0xFFFF6191) : Color(0xFFCCCCCC)),
                  color: _isSelected ? Color(0xFFFF6191) : Colors.white,
                ),
                child: SvgPicture.asset(
                  'assets/images/check01_off.svg', // 올바른 경로
                  color: _isSelected
                      ? Colors.white
                      : Color(0xFFCCCCCC), // 체크 여부에 따라 색상 변경
                  height: 10, // 아이콘의 높이
                  width: 10, // 아이콘의 너비
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: Responsive.getWidth(context, 10)),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Image.asset(
                'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: Responsive.getWidth(context, 20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Responsive.getWidth(context, 204),
                    child: Text(
                      widget.item['productName'], // widget.item 사용
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 14),
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.item['item'], // widget.item 사용
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 13),
                      color: Color(0xFF7B7B7B),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: Responsive.getWidth(context, 96),
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      border: Border.all(color: Color(0xFFE3E3E3)),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: Responsive.getWidth(context, 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => widget.onDecrementQuantity(widget.index),
                          child: Icon(Icons.remove, size: 15),
                        ),
                        Text(
                          widget.item['quantity'].toString(), // widget.item 사용
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => widget.onIncrementQuantity(widget.index),
                          child: Icon(Icons.add, size: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.item['price']}원', // widget.item 사용
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(width: Responsive.getWidth(context, 10)),
            GestureDetector(
              onTap: () => widget.onDelete(widget.index),
              child: SvgPicture.asset('assets/images/ic_del.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
