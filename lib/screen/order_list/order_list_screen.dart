import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/order_detail/order_detail_screen.dart';
import 'package:BliU/screen/order_list/item/order_item.dart';
import 'package:BliU/screen/order_list/view_model/order_list_view_model.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => OrderListScreenState();
}

class OrderListScreenState extends ConsumerState<OrderListScreen> {
  final ScrollController _scrollController = ScrollController();

  String? _otCode;//비회원일 경우 사용

  final List<String> categories = ['전체', '배송중', '배송완료', '취소/교환반품'];
  int selectedCategoryIndex = 0;
  int? count;
  List<OrderData> orderList = [];
  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _otCode = Get.parameters["ot_code"].toString();
    _scrollController.addListener(_nextLoad);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    _hasNextPage = true;

    final Map<String, dynamic> requestData = await _makeRequestData();

    setState(() {
      orderList = [];
    });

    final orderResponseDTO = await ref.read(orderListViewModelProvider.notifier).getList(requestData);
    orderList = orderResponseDTO?.list ?? [];
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {
    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 200){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final Map<String, dynamic> requestData = await _makeRequestData();

      final orderResponseDTO = await ref.read(orderListViewModelProvider.notifier).getList(requestData);
      if (orderResponseDTO != null) {
        if ((orderResponseDTO.list ?? []).isNotEmpty) {
          setState(() {
            orderList.addAll(orderResponseDTO.list ?? []);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    // 전체 시 all 전체 5 배송중 7 배송완료 99 취소/교환반품
    String ctStatus = "";
    switch (selectedCategoryIndex) {
      case 0:
        ctStatus = "all";
        break;
      case 1:
        ctStatus = "5";
        break;
      case 2:
        ctStatus = "7";
        break;
      case 3:
        ctStatus = "99";
        break;
    }
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'ot_code': _otCode ?? "",
      'ct_status': ctStatus,
      'pg': _page,
    };

    return requestData;
  }

  void _viewWillAppear(BuildContext context) {
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            title: const Text('주문/배송'),
            titleTextStyle: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.2,
            ),
            leading: IconButton(
              icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
              onPressed: () {
                Navigator.pop(context); // 뒤로가기 동작
              },
            ),
            titleSpacing: -1.0,
            actions: const [
              TopCartButton(),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
              child: Container(
                color: const Color(0x0D000000), // 하단 구분선 색상
                height: 1.0, // 구분선의 두께 설정
                child: Container(
                  height: 1.0, // 그림자 부분의 높이
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 6.0,
                        spreadRadius: 0.1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Utils.getInstance().isWebView(
            Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 38,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categories.map((i) => categoryItem(i)).toList(),
                          ),
                        ),
                        // ListView.builder(
                        //   scrollDirection: Axis.horizontal,
                        //   itemCount: categories.length,
                        //   itemBuilder: (context, index) {
                        //     final bool isSelected = selectedCategoryIndex == index;
                        //
                        //     return Padding(
                        //       padding: const EdgeInsets.only(right: 4.0),
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           setState(() {
                        //             selectedCategoryIndex = index;
                        //             _getList();
                        //           });
                        //         },
                        //         child: Container(
                        //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(19),
                        //             border: Border.all(
                        //               color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
                        //               width: 1.0,
                        //             ),
                        //             color: Colors.white,
                        //           ),
                        //           child: Text(
                        //             categories[index],
                        //             style: TextStyle(
                        //               fontFamily: 'Pretendard',
                        //               fontSize: Responsive.getFont(context, 14),
                        //               color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                        //               height: 1.2,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ),
                      const Divider(
                        height: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                      Visibility(
                        visible: orderList.isNotEmpty,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: orderList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final orderData = orderList[index];
                            final detailList = orderData.detailList ?? [];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFEEEEEE)), // 구분선 추가
                                ),
                              ),
                              child: Column(
                                children: (detailList).map((orderDetailData) {
                                  return  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: orderListItem(orderData, orderDetailData),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: orderList.isNotEmpty,
                  child: MoveTopButton(scrollController: _scrollController),
                ),
                Visibility(
                  visible: orderList.isEmpty,
                  child: const NonDataScreen(text: '주문내역이 없습니다.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryItem(String category) {
    final index = categories.indexOf(category);
    final bool isSelected = selectedCategoryIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategoryIndex = index;
            _getList();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
              width: 1.0,
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              categories[index],
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderListItem(OrderData orderData, OrderDetailData detailList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 날짜, 주문번호, 주문 상세 버튼을 하나로 묶음
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    orderData.ctWdate ?? "",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.getFont(context, 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      detailList.otCode ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(orderData: orderData, detailList: detailList,),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    '주문상세',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: const Color(0xFFFF6192),
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 2, top: 2),
                    child: SvgPicture.asset('assets/images/my/ic_link_p.svg'),
                  ),
                ],
              ),
            ),
          ],
        ),
        // 같은 날짜의 주문들을 묶어서 표시
        OrderItem(
          orderData: orderData,
          orderDetailData: detailList,
          isList: true,
        ),
      ],
    );
  }
}
