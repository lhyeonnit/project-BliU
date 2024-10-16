import 'package:BliU/data/order_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/mypage/component/top/component/order_list_item.dart';
import 'package:BliU/screen/mypage/viewmodel/order_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<String> categories = ['전체', '배송중', '배송완료', '취소/교환반품'];
  int selectedCategoryIndex = 0;

  List<OrderData> orderList = [];

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;

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
      'ot_code': '', // 비회원 주문조회의 경우에만 전달해주세요.
      'ct_status': ctStatus,
      'pg': _page,
    };

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

      final Map<String, dynamic> requestData = {
        'pg': _page
      };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
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
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: isSelected ? const Color(0xFFFF6192) : Colors.black, // 텍스트 색상
                              height: 1.2,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedCategoryIndex = index;
                              _getList();
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final orderData = orderList[index];

                    return OrderListItem(
                      orderData: orderData,
                    );
                  }
                ),
              ],
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
