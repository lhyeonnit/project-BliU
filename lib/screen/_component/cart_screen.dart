import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/responsive.dart';
import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [
    {
      'storeName': '타이니숲',
      'productName': '타이니숲 에스더버니 12종 상하복/원피스/티셔츠',
      'price': 32800,
      'quantity': 1,
      'item': '베이지 / 110 1개',
      'storeId': 1,
      'shippingCost': 2500, // 스토어별 배송비
    },
    {
      'storeName': '타이니숲',
      'productName': '타이니숲 에스더버니 12종 상하복/원피스/티셔츠',
      'price': 32800,
      'quantity': 1,
      'item': '베이지 / 110 1개',
      'storeId': 1,
      'shippingCost': 2500, // 스토어별 배송비
    },
    {
      'storeName': '다른 스토어',
      'productName': '다른 스토어 상품 이름',
      'price': 20000,
      'quantity': 1,
      'item': '블루 / M 1개',
      'storeId': 2,
      'shippingCost': 3000, // 스토어별 배송비
    },
  ];

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

  @override
  void initState() {
    super.initState();
    _getTotalPrice;
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
      _getTotalPrice;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
        _getTotalPrice;
      }
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _getTotalPrice;
    });
  }

  ScrollController _scrollController = ScrollController();

  bool _isAllSelected = false;
  int _totalItems = 3;
  int _selectedItemsCount = 1;

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
    int totalPrice = _getTotalPrice();
    int totalShippingCost = _getTotalShippingCost();
    int totalPayment = _getTotalPayment();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: Text("장바구니"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: BoxDecoration(
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
                  padding: EdgeInsets.only(bottom: 150), // 하단 고정 버튼 공간 확보
                  children: [
                    // 전체선택 및 전체삭제 UI
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                height: 22,
                                width: 22,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(
                                    color: _isAllSelected
                                        ? Color(0xFFCCCCCC)
                                        : Color(0xFFFF6191),
                                  ),
                                  color: _isAllSelected
                                      ? Colors.white
                                      : Color(0xFFFF6191),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isAllSelected = !_isAllSelected;
                                      _selectedItemsCount =
                                          _isAllSelected ? _totalItems : 0;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/check01_off.svg', // 올바른 경로
                                    color: _isAllSelected
                                        ? Color(0xFFCCCCCC)
                                        : Colors.white, // 체크 여부에 따라 색상 변경
                                    height: 10, // 아이콘의 높이
                                    width: 10, // 아이콘의 너비
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '전체선택($_selectedItemsCount/$_totalItems)',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14)),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // 전체삭제 동작
                            },
                            icon: SvgPicture.asset(
                              'assets/images/ic_delet.svg',
                            ),
                            label: Text(
                              '전체삭제',
                              style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // 장바구니 항목들
                    ...storeGroupedItems.entries.map((entry) {
                      int storeId = entry.key;
                      List<Map<String, dynamic>> items = entry.value;

                      // 각 스토어의 배송비 계산
                      int shippingCost =
                          items.isNotEmpty ? items.first['shippingCost'] : 0;

                      // 각 스토어의 총 상품 금액 계산
                      int totalPrice = items.fold(
                          0,
                          (sum, item) =>
                              sum +
                              (item['price'] as int) *
                                  (item['quantity'] as int));

                      // 총 결제 금액 (총 상품 금액 + 배송비)
                      int totalPayment = totalPrice + shippingCost;

                      // 마지막 스토어인지 확인
                      bool isLastStore =
                          storeGroupedItems.entries.last.key == storeId;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 스토어명
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)), // 사진의 모서리 둥글게 설정
                                    border: Border.all(
                                      color: Color(0xFFDDDDDD), // 테두리 색상 설정
                                      width: 1.0, // 테두리 두께 설정
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)), // 사진의 모서리만 둥글게 설정
                                    child: Image.asset(
                                      'assets/images/home/exhi.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: Responsive.getWidth(context, 10)),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    items.first['storeName'],
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                    ),
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
                                onIncrementQuantity: _incrementQuantity,
                                onDecrementQuantity: _decrementQuantity,
                                onDelete: _deleteItem,
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10.0),

                          // 배송비 및 결제금액
                          Container(
                            width: Responsive.getWidth(context, 380),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F9F9),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '배송비 $shippingCost원',
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 13),
                                    color: Color(0xFF7B7B7B),
                                  ),
                                ),
                                SizedBox(
                                    width: Responsive.getWidth(context, 10)),
                                Text(
                                  '총 결제금액',
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                  ),
                                ),
                                SizedBox(
                                    width: Responsive.getWidth(context, 10)),
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
                          SizedBox(height: 20.0),

                          // 마지막 스토어가 아닐 때만 구분선 추가
                          if (!isLastStore)
                            Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                        ],
                      );
                    }).toList(),

                    Divider(thickness: 10, color: Color(0xFFF5F9F9)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('총 상품 금액', style: TextStyle(fontSize: Responsive.getFont(context, 14),)),
                              Text('$totalPrice원',
                                  style: TextStyle(fontSize: Responsive.getFont(context, 14),)),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('총 배송비', style: TextStyle(fontSize: Responsive.getFont(context, 14),)),
                              Text('$totalShippingCost원',
                                  style: TextStyle(fontSize: Responsive.getFont(context, 14),)),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('총 결제예상금액',
                                  style: TextStyle(fontSize: Responsive.getFont(context, 14),)),
                              Text('$totalPayment원',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      fontWeight: FontWeight.bold)),
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

          // 하단 고정된 결제 정보 및 주문하기 버튼
          Container(
            decoration: BoxDecoration(
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
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                // 상단의 회색 바 추가
                Container(
                  margin: EdgeInsets.symmetric(vertical: 17.0),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // 총 상품 금액, 총 배송비, 주문하기 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('총 상품 금액: ',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14))),
                    Text('$totalPrice원',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14))),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('총 배송비: ',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14))),
                    Text('$totalShippingCost원',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14))),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), // 모서리를 둥글게 설정
                    ),
                  ),
                  child: Text(
                    '주문하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
