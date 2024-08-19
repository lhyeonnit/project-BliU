//장바구니
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  bool _isAllSelected = false;
  int _totalItems = 3;
  int _selectedItemsCount = 1;

  List<Map<String, dynamic>> _cartItems = [
    {
      'storeName': '타이니숲',
      'productName': '타이니숲 에스더버니 12종 10,900원 균일가 상하복/원피스/티셔츠',
      'price': 32800,
      'quantity': 1,
      'image': 'assets/images/cart_item1.png',
    },
    {
      'storeName': '타이니숲',
      'productName': '타이니숲 에스더버니 12종 10,900원 균일가 상하복/원피스/티셔츠',
      'price': 32800,
      'quantity': 1,
      'image': 'assets/images/cart_item2.png',
    },
    {
      'storeName': '타이니숲',
      'productName': '타이니숲 에스더버니 12종 10,900원 균일가 상하복/원피스/티셔츠',
      'price': 32800,
      'quantity': 1,
      'image': 'assets/images/cart_item3.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isAtBottom = true;
      });
    } else {
      setState(() {
        _isAtBottom = false;
      });
    }
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = 100400;
    int shippingCost = 2500;
    int totalPayment = totalPrice + shippingCost;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('장바구니'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 150), // 하단에 고정된 버튼 공간 확보
            children: [
              // 전체선택 및 전체삭제 UI
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isAllSelected,
                          onChanged: (value) {
                            setState(() {
                              _isAllSelected = value!;
                              _selectedItemsCount =
                                  _isAllSelected ? _totalItems : 0;
                            });
                          },
                        ),
                        Text(
                          '전체선택($_selectedItemsCount/$_totalItems)',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // 전체삭제 동작
                      },
                      icon: Icon(Icons.delete, color: Colors.black),
                      label: Text(
                        '전체삭제',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              // 브랜드 타이틀
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '타이니숲',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey[300]),
              // 장바구니 항목들
              ..._cartItems.map((item) {
                int index = _cartItems.indexOf(item);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {
                            // 선택된 항목 처리
                          },
                        ),
                        Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              'Image not available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['productName'],
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () => _decrementQuantity(index),
                                  ),
                                  Text(item['quantity'].toString()),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () => _incrementQuantity(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _cartItems.removeAt(index);
                                });
                              },
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '${item['price']}원',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              if (_isAtBottom)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('배송비 $shippingCost원',
                                style: TextStyle(fontSize: 14.0)),
                            Text('총 결제금액 $totalPayment원',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Divider(thickness: 1, color: Colors.grey[300]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('총 상품 금액', style: TextStyle(fontSize: 16.0)),
                          Text('$totalPrice원',
                              style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('총 배송비', style: TextStyle(fontSize: 16.0)),
                          Text('$shippingCost원',
                              style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('총 결제예상금액', style: TextStyle(fontSize: 16.0)),
                          Text('$totalPayment원',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (!_isAtBottom)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('총 상품 금액: ', style: TextStyle(fontSize: 16.0)),
                            Text('$totalPrice원',
                                style: TextStyle(fontSize: 16.0)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('총 배송비: ', style: TextStyle(fontSize: 16.0)),
                            Text('$shippingCost원',
                                style: TextStyle(fontSize: 16.0)),
                          ],
                        ),
                        TextButton(onPressed: () {}, child: Text(
                        '주문하기'
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
