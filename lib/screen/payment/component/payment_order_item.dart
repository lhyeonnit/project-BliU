import 'package:BliU/data/cart_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class PaymentOrderItem extends StatefulWidget {
  final List<CartData> cartDetails;

  const PaymentOrderItem({
    super.key,
    required this.cartDetails,
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
    selectedItems = widget.cartDetails;
  }

  @override
  Widget build(BuildContext context) {
    Map<int, List<Map<String, dynamic>>> storeGroupedItems = {};

    // for (var item in selectedItems) {
    //   int storeId = item['storeId'];
    //   if (!storeGroupedItems.containsKey(storeId)) {
    //     storeGroupedItems[storeId] = [];
    //   }
    //   storeGroupedItems[storeId]!.add(item);
    // }

    return Column(
      children: [
        ...storeGroupedItems.entries.map((entry) {
          int storeId = entry.key;
          List<Map<String, dynamic>> items = entry.value;

          bool isLastStore = storeGroupedItems.entries.last.key == storeId;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 스토어 정보 (스토어명, 스토어 로고)
              Container(
                margin: const EdgeInsets.only(
                    right: 16, left: 16, bottom: 10, top: 20),
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
                        child: Image.asset(
                          items.first['storeLogo'], // 스토어 로고
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: Text(
                        items.first['storeName'], // 스토어 이름
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 각 상품 정보
              ...items
                  .where((item) => item['isSelected'] == true)
                  .map((item) {
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
                          borderRadius:
                          const BorderRadius.all(Radius.circular(6)),
                          child: Image.asset(
                            'assets/images/home/exhi.png', // 실제 이미지 경로
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['productName'], // 상품 이름
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 15),
                              child: Row(
                                children: [
                                  Text(
                                    item['item'], // 아이템 설명
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 13),
                                      color: const Color(0xFF7B7B7B),
                                    ),
                                  ),
                                  Text(
                                    ' ${item['quantity']}개', // 수량
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 13),
                                      color: const Color(0xFF7B7B7B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${item['price']}원', // 가격 정보
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              // 스토어별 구분선
              if (!isLastStore)
                const Divider(
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
