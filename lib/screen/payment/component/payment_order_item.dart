import 'package:BliU/data/cart_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';

class PaymentOrderItem extends StatefulWidget {
  final List<CartData> cartList;

  const PaymentOrderItem({
    super.key,
    required this.cartList,
  });

  @override
  _PaymentOrderItemState createState() => _PaymentOrderItemState();
}

class _PaymentOrderItemState extends State<PaymentOrderItem> {
  List<CartData> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // 선택된 아이템들을 저장
    selectedItems = widget.cartList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...selectedItems.map((item) {
          final productList = item.productList ?? [];
          bool isLast = (selectedItems.length - 1) == selectedItems.indexOf(item);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 스토어 정보 (스토어명, 스토어 로고)
              Container(
                margin: const EdgeInsets.only(right: 16, left: 16, bottom: 10, top: 20),
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: const Color(0xFFDDDDDD),
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Image.network(
                          item.stProfile ?? "", // 스토어 로고
                          fit: BoxFit.contain,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          }
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: Text(
                        item.stName ?? "", // 스토어 이름
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 각 상품 정보
              ...productList.map((pItem) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          child: Image.network(
                            pItem.ptImg ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return const SizedBox();
                            }
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pItem.ptName ?? "", // 상품 이름
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 15),
                              child: Row(
                                children: [
                                  Text(
                                    pItem.ptOption ?? "", // 아이템 설명
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 13),
                                      color: const Color(0xFF7B7B7B),
                                      height: 1.2,
                                    ),
                                  ),
                                  Text(
                                    ' ${pItem.ptCount ?? 0}개', // 수량
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 13),
                                      color: const Color(0xFF7B7B7B),
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${Utils.getInstance().priceString(pItem.ptPrice ?? 0)}원', // 가격 정보
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 16),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Visibility(
                visible: !isLast,
                child: const Divider(
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
