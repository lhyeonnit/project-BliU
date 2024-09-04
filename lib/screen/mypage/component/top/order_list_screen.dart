import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/order_list_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<String> categories = ['전체', '배송중', '배송완료', '취소/교환반품'];
  int selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  // 더미 데이터 정의
  List<Map<String, dynamic>> orderData = [
    {
      "date": "23.03.10",
      "orderId": "123456789101",
      "status": "상품준비중",
      "price": "32,800",
      "items": [
        {
          "name": "[꼬마별빛] [균일특가+무배] 꼬마별빛 에스더버니 12종 10,900원 균일가 상하",
          "store": "우아동금손",
          "size": "베이지 / 110 1개",
          "image": "assets/images/home/exhi.png"
        }
      ],
    },
    {
      "date": "23.03.10",
      "orderId": "123456789101",
      "status": "배송중",
      "price": "32,800",
      "items": [
        {
          "name": "[꼬마별빛] [균일특가+무배] 꼬마별빛 에스더버니 12종 10,900원 균일가 상하",
          "store": "우아동금손",
          "size": "베이지 / 110 1개",
          "image": "assets/images/home/exhi.png"
        }
      ],
    },
    {
      "date": "23.03.09",
      "orderId": "123456789103",
      "status": "배송완료",
      "price": "32,800",
      "items": [
        {
          "name": "[꼬마별빛] [균일특가+무배] 꼬마별빛 에스더버니 12종 10,900원 균일가 상하",
          "store": "우아동금손",
          "size": "베이지 / 110 1개",
          "image": "assets/images/home/exhi.png"
        }
      ],
    },
    {
      "date": "23.03.08",
      "orderId": "123456789254",
      "status": "구매확정",
      "price": "32,800",
      "items": [
        {
          "name": "[꼬마별빛] [균일특가+무배] 꼬마별빛 에스더버니 12종 10,900원 균일가 상하",
          "store": "우아동금손",
          "size": "베이지 / 110 1개",
          "image": "assets/images/home/exhi.png"
        }
      ],
    },
    {
      "date": "23.03.07",
      "orderId": "123456789104",
      "status": "취소요청",
      "price": "32,800",
      "items": [
        {
          "name": "[꼬마별빛] [균일특가+무배] 꼬마별빛 에스더버니 12종 10,900원 균일가 상하",
          "store": "우아동금손",
          "size": "베이지 / 110 1개",
          "image": "assets/images/home/exhi.png"
        }
      ],
    },
  ];

  // 카테고리에 따라 데이터를 필터링하고 날짜별로 그룹화하는 함수
  Map<String, List<Map<String, dynamic>>> getFilteredOrders() {
    Map<String, List<Map<String, dynamic>>> groupedOrders = {};

    // 선택된 카테고리에 따른 필터링
    String selectedCategory = categories[selectedCategoryIndex];

    // 전체 주문 목록을 필터링하여 상태에 맞는 주문만 표시
    List<Map<String, dynamic>> filteredOrders = orderData.where((order) {
      if (selectedCategory == '전체') return true;

      // "배송완료" 카테고리에는 "구매확정"도 포함
      if (selectedCategory == '배송완료' && order["status"] == '구매확정') {
        return true;
      }

      // "취소/교환반품" 카테고리에는 "취소요청", "교환요청", "반품요청"도 포함
      if (selectedCategory == '취소/교환반품' &&
          (order["status"] == '취소요청' ||
              order["status"] == '교환요청' ||
              order["status"] == '반품요청')) {
        return true;
      }

      return order["status"] == selectedCategory;
    }).toList();

    // 필터링된 주문 목록을 날짜별로 그룹화
    for (var order in filteredOrders) {
      String date = order["date"];
      if (groupedOrders.containsKey(date)) {
        groupedOrders[date]!.add(order);
      } else {
        groupedOrders[date] = [order];
      }
    }

    return groupedOrders;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('주문/배송'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                padding: const EdgeInsets.only(right: 10),
                icon: SvgPicture.asset("assets/images/product/ic_cart.svg"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 10,
                top: 20,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final bool isSelected = selectedCategoryIndex == index;

                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: FilterChip(
                            label: Text(
                              categories[index],
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: isSelected
                                    ? const Color(0xFFFF6192)
                                    : Colors.black, // 텍스트 색상
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCategoryIndex = index;
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: Colors.white,
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFFFF6192)
                                    : const Color(0xFFDDDDDD),
                                // 테두리 색상
                                width: 1.0,
                              ),
                            ),
                            showCheckmark: false, // 체크 표시 없애기
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                  ...getFilteredOrders().entries.map((entry) {
                    String date = entry.key; // 날짜 (Map의 key)
                    List<Map<String, dynamic>> orders = entry.value; // 해당 날짜의 주문 목록
                    String orderId = orders.first["orderId"]; // 해당 날짜의 첫 번째 주문의 주문번호 가져오기

                    return OrderListItem(
                      date: date, // 날짜를 전달
                      orderId: orderId, // 해당 날짜의 주문번호를 전달
                      orders: orders, // 같은 날짜에 해당하는 주문 목록을 전달
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
