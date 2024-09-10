import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/payment_data.dart';
import '../../utils/responsive.dart';
import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'storeName': '타이니숲',
      'storeLogo': 'assets/images/home/exhi.png',
      'productName': '타이니숲 에스더버니 12종 상하복/원피스/티셔츠',
      'price': 32800,
      'quantity': 1,
      'item': '베이지 / 110',
      'storeId': 1,
      'shippingCost': 2500, // 스토어별 배송비
      'isSelected': false, // 선택 상태 초기화
    },
    {
      'storeName': '타이니숲',
      'storeLogo': 'assets/images/home/exhi.png',
      'productName': '타이니숲 에스더버니 12종 상하복/원피스/티셔츠',
      'price': 32800,
      'quantity': 1,
      'item': '베이지 / 110',
      'storeId': 1,
      'shippingCost': 2500, // 스토어별 배송비
      'isSelected': false, // 선택 상태 초기화
    },
    {
      'storeName': '다른 스토어',
      'storeLogo': 'assets/images/home/exhi.png',
      'productName': '다른 스토어 상품 이름',
      'price': 20000,
      'quantity': 1,
      'item': '블루 / M',
      'storeId': 2,
      'shippingCost': 3000, // 스토어별 배송비
      'isSelected': false, // 선택 상태 초기화
    },
  ];

  // 선택된 항목들의 총 상품 금액 계산
  int _getSelectedTotalPrice() {
    return _cartItems
        .where((item) => item['isSelected'] == true)
        .fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));
  }

  // 선택된 항목들의 총 배송비 계산
  int _getSelectedTotalShippingCost() {
    Set<int> selectedStoreIds = {};
    return _cartItems.where((item) => item['isSelected'] == true).fold(0, (sum, item) {
      if (!selectedStoreIds.contains(item['storeId'])) {
        selectedStoreIds.add(item['storeId']);
        return sum + (item['shippingCost'] as int);
      }
      return sum;
    });
  }

  // 선택된 항목들의 총 결제 금액 계산
  int _getSelectedTotalPayment() {
    return _getSelectedTotalPrice() + _getSelectedTotalShippingCost();
  }

  int _getTotalPrice() {
    return _cartItems.fold(0, (sum, item) {
      return sum + (item['price'] as int) * (item['quantity'] as int);
    });
  }

  int _getTotalShippingCost() {
    Set<int> storeIds = {};
    return _cartItems.fold(0, (sum, item) {
      if (!storeIds.contains(item['storeId'])) {
        storeIds.add(item['storeId']);
        return sum + (item['shippingCost'] as int);
      }
      return sum;
    });
  }

  int _getTotalPayment() {
    return _getTotalPrice() + _getTotalShippingCost();
  }

  final ScrollController _scrollController = ScrollController();

  bool _isAllSelected = false;
  int _selectedItemsCount = 0;
  void _toggleSelectAll() {
    setState(() {
      _isAllSelected = !_isAllSelected;
      _selectedItemsCount = _isAllSelected ? _cartItems.length : 0;

      // 모든 아이템의 선택 상태 업데이트
      for (var item in _cartItems) {
        item['isSelected'] = _isAllSelected;
      }
    });
  }
  void _toggleSelection(int index, bool isSelected) {
    setState(() {
      _cartItems[index]['isSelected'] = isSelected;

      // 선택된 항목 수 업데이트
      if (isSelected) {
        _selectedItemsCount++;
      } else {
        _selectedItemsCount--;
      }

      // 전체 선택 상태 동기화
      _isAllSelected = _selectedItemsCount == _cartItems.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    // 스토어별로 묶기
    Map<int, List<Map<String, dynamic>>> storeGroupedItems = {};
    for (var item in _cartItems) {
      int storeId = item['storeId'];
      if (!storeGroupedItems.containsKey(storeId)) {
        storeGroupedItems[storeId] = [];
      }
      storeGroupedItems[storeId]!.add(item);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: const Text("장바구니"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 50), // 하단 고정 버튼 공간 확보
                  children: [
                    // 전체선택 및 전체삭제 UI
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _toggleSelectAll,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                    border: Border.all(
                                      color: _isAllSelected
                                          ? const Color(0xFFFF6191)
                                          :  const Color(0xFFCCCCCC),
                                    ),
                                    color: _isAllSelected
                                        ? const Color(0xFFFF6191)
                                        : Colors.white,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/check01_off.svg', // 체크박스 아이콘
                                    color: _isAllSelected
                                        ? Colors.white
                                        : const Color(0xFFCCCCCC),
                                    height: 10, // 아이콘의 높이
                                    width: 10, // 아이콘의 너비
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '전체선택($_selectedItemsCount/${_cartItems.length})',
                                style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _cartItems.removeWhere((item) => item['isSelected'] == true);
                                _selectedItemsCount = 0;
                                _isAllSelected = false;
                              });
                            },
                            icon: SvgPicture.asset('assets/images/ic_delet.svg'),
                            label: Text(
                              '전체삭제',
                              style: TextStyle(fontSize: Responsive.getFont(context, 14), color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 장바구니 항목들
                    ...storeGroupedItems.entries.map((entry) {
                      int storeId = entry.key;
                      List<Map<String, dynamic>> items = entry.value;

                      // 각 스토어의 배송비 계산
                      int shippingCost = items.isNotEmpty ? items.first['shippingCost'] : 0;

                      // 각 스토어의 총 상품 금액 계산
                      int totalPrice = items.fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));

                      // 총 결제 금액 (총 상품 금액 + 배송비)
                      int totalPayment = totalPrice + shippingCost;

                      // 마지막 스토어인지 확인
                      bool isLastStore = storeGroupedItems.entries.last.key == storeId;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 스토어명
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)), // 사진의 모서리 둥글게 설정
                                    border: Border.all(
                                      color: const Color(0xFFDDDDDD), // 테두리 색상 설정
                                      width: 1.0, // 테두리 두께 설정
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)), // 사진의 모서리만 둥글게 설정
                                    child: Image.asset(
                                      items.first['storeLogo'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: Responsive.getWidth(context, 10)),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    items.first['storeName'],
                                    style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 각 스토어의 상품들
                          Column(
                            children: items.asMap().entries.map((entry) {
                              int index = _cartItems.indexOf(entry.value);
                              Map<String, dynamic> item = entry.value;

                              return CartItem(
                                item: item,
                                index: index,
                                isSelected: item['isSelected'],
                                onIncrementQuantity: (index) {
                                  setState(() {
                                    _cartItems[index]['quantity']++;
                                  });
                                },
                                onDecrementQuantity: (index) {
                                  setState(() {
                                    if (_cartItems[index]['quantity'] > 1) {
                                      _cartItems[index]['quantity']--;
                                    }
                                  });
                                },
                                onDelete: (index) {
                                  setState(() {
                                    _cartItems.removeAt(index);
                                  });
                                },
                                onToggleSelection: _toggleSelection, // 개별 선택 상태 변경 함수 전달
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10.0),
                          // 배송비 및 결제금액
                          Container(
                            width: Responsive.getWidth(context, 380),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F9F9),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '배송비 $shippingCost원',
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 13),
                                    color: const Color(0xFF7B7B7B),
                                  ),
                                ),
                                SizedBox(width: Responsive.getWidth(context, 10)),
                                Text(
                                  '총 결제금액',
                                  style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                                ),
                                SizedBox(width: Responsive.getWidth(context, 10)),
                                Text(
                                  '$totalPayment원',
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          if (!isLastStore)
                            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                        ],
                      );
                    }),
                    const Divider(thickness: 10, color: Color(0xFFF5F9F9)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('총 상품 금액', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                              Text('${_getSelectedTotalPrice()}원', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('총 배송비', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                              Text('${_getSelectedTotalShippingCost()}원', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                            child: const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('총 결제예상금액', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                              Text('${_getSelectedTotalPayment()}원', style: TextStyle(fontSize: Responsive.getFont(context, 14), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                MoveTopButton(scrollController: _scrollController),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFF4F4F4),
                  blurRadius: 6.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, -3), // 위쪽으로 그림자 위치 조정
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 17.0),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('총 상품 금액: ', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                    Text('${_getSelectedTotalPayment()}원', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('총 배송비: ', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                    Text('${_getSelectedTotalShippingCost()}원', style: TextStyle(fontSize: Responsive.getFont(context, 14))),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _selectedItemsCount > 0
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          cartDetails: _cartItems,
                        ),
                      ),
                    );
                  }
                      : null, // 선택된 항목이 없으면 비활성화
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: _selectedItemsCount > 0 ? Colors.black : Color(0xFFDDDDDD), // 선택된 항목이 없으면 회색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    '주문하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PaymentData _preparePaymentData() {
    // 총 결제 금액
    int totalAmount = _getTotalPayment();

    // 세금 제외 금액 설정 (현재는 0으로 설정)
    int taxFreeAmount = 0;

    // 주문 이름 생성 (상품 이름을 연결)
    String orderName = _cartItems.map((item) => item['productName']).join(", ");

    // 고유 주문 ID 생성
    String orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";

    // 고객 정보 설정 (여기서는 고정값 사용)
    String customerKey = "unique_customer_key";
    String customerName = "고객 이름";

    return PaymentData(
      customerKey: customerKey,
      orderId: orderId,
      amount: totalAmount,
      taxFreeAmount: taxFreeAmount,
      orderName: orderName,
      customerName: customerName,
    );
  }
}