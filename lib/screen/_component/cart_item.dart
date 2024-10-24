import 'package:BliU/data/cart_item_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartItem extends StatefulWidget {
  final CartItemData item; // 장바구니 항목 데이터
  final Function(int) onIncrementQuantity;
  final Function(int) onDecrementQuantity;
  final Function(int) onDelete;
  final Function(int, bool) onToggleSelection; // 선택 상태 변경 콜백 추가
  final bool isSelected; // 선택 상태를 부모로부터 전달받음

  const CartItem({
    super.key,
    required this.item,
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
  int _getProductPrice() {
    // 선택된 기준으로 가격 가져오기
    int productPrice = widget.item.ptPrice ?? 0;
    int productCount = widget.item.ptCount ?? 0;
    productPrice = (productPrice * productCount);
    return productPrice;
  }
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
                  widget.onToggleSelection(widget.item.ctIdx ?? 0, !widget.isSelected); // 부모로 선택 상태 전달
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                    color: widget.isSelected ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC)
                  ),
                  color: widget.isSelected ? const Color(0xFFFF6191) : Colors.white,
                ),
                child: SvgPicture.asset(
                  'assets/images/check01_off.svg', // 체크박스 아이콘 경로
                  colorFilter: ColorFilter.mode(
                    widget.isSelected ? Colors.white : const Color(0xFFCCCCCC),
                    BlendMode.srcIn,
                  ),
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
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child: Image.network(
                  widget.item.ptImg ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const SizedBox();
                  }
                ),
              )
            ),
            SizedBox(width: Responsive.getWidth(context, 20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Responsive.getWidth(context, 204),
                    child: Text(
                      widget.item.ptTitle ?? "", // widget.item 사용
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: Colors.black,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.ptOption ?? "", // widget.item 사용
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 13),
                      color: const Color(0xFF7B7B7B),
                      height: 1.2,
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
                              widget.onDecrementQuantity(widget.item.ctIdx ?? 0),
                          child: const Icon(Icons.remove, size: 15),
                        ),
                        Text(
                          widget.item.ptCount.toString(), // widget.item 사용
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            height: 1.2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              widget.onIncrementQuantity(widget.item.ctIdx ?? 0),
                          child: const Icon(Icons.add, size: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${Utils.getInstance().priceString(_getProductPrice())}원', // widget.item 사용
                    style:  TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 16.0) ,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Responsive.getWidth(context, 10)),
            GestureDetector(
              onTap: () => widget.onDelete(widget.item.ctIdx ?? 0),
              child: SvgPicture.asset('assets/images/ic_del.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
