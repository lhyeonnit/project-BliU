import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/responsive.dart';

class CartItem extends StatefulWidget {
  final Map<String, dynamic> item; // 장바구니 항목 데이터
  final int index;
  final Function(int) onIncrementQuantity;
  final Function(int) onDecrementQuantity;
  final Function(int) onDelete;
  final Function(int, bool) onToggleSelection; // 선택 상태 변경 콜백 추가
  final bool isSelected; // 선택 상태를 부모로부터 전달받음

  const CartItem({
    super.key,
    required this.item,
    required this.index,
    required this.onIncrementQuantity,
    required this.onDecrementQuantity,
    required this.onDelete,
    required this.onToggleSelection,
    required this.isSelected,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: Responsive.getWidth(context, 380),
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.onToggleSelection(widget.index, !widget.isSelected); // 부모로 선택 상태 전달
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                      color: widget.isSelected
                          ? const Color(0xFFFF6191)
                          : const Color(0xFFCCCCCC)),
                  color: widget.isSelected
                      ? const Color(0xFFFF6191)
                      : Colors.white,
                ),
                child: SvgPicture.asset(
                  'assets/images/check01_off.svg', // 체크박스 아이콘 경로
                  color: widget.isSelected
                      ? Colors.white
                      : const Color(0xFFCCCCCC), // 체크 여부에 따라 색상 변경
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
              decoration: const BoxDecoration(
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
                  SizedBox(
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
                  const SizedBox(height: 10),
                  Text(
                    widget.item['item'], // widget.item 사용
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 13),
                      color: const Color(0xFF7B7B7B),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: Responsive.getWidth(context, 96),
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                      border: Border.all(color: const Color(0xFFE3E3E3)),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: Responsive.getWidth(context, 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              widget.onDecrementQuantity(widget.index),
                          child: const Icon(Icons.remove, size: 15),
                        ),
                        Text(
                          widget.item['quantity'].toString(), // widget.item 사용
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              widget.onIncrementQuantity(widget.index),
                          child: const Icon(Icons.add, size: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.item['price']}원', // widget.item 사용
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
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
