import 'package:BliU/data/push_data.dart';
import 'package:BliU/screen/cart/cart_screen.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/exhibition/exhibition_screen.dart';
import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/my_coupon/my_coupon_screen.dart';
import 'package:BliU/screen/order_list/order_list_screen.dart';
import 'package:BliU/screen/alarm/view_model/alarm_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AlarmScreen extends ConsumerStatefulWidget {
  const AlarmScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AlarmScreenState();
}

class AlarmScreenState extends ConsumerState<AlarmScreen> {
  final ScrollController _scrollController = ScrollController();

  List<PushData> pushList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('알림'),
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
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: pushList.isNotEmpty,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: pushList.length,
                  itemBuilder: (context, index) {
                    final pushData = pushList[index];

                    return GestureDetector(
                      onTap: () {
                        /**
                            home - 홈화면
                            order_list - 주문 배송 페이지
                            cart_list - 장바구니
                            coupon_list - 쿠폰함
                            exhibition - 기획전
                         * */
                        switch (pushData.ptLink) {
                          case "home":
                            Navigator.popUntil(context, ModalRoute.withName("/"));
                            ref.read(mainScreenProvider.notifier).selectNavigation(2);
                            break;
                          case "order_list":
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const OrderListScreen()),
                            );
                            break;
                          case "cart_list":
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CartScreen()),
                            );
                            break;
                          case "coupon_list":
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyCouponScreen()),
                            );
                            break;
                          case "exhibition":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExhibitionScreen(etIdx: pushData.etIdx ?? 0),
                              ),
                            );
                            break;
                        }
                      },
                      child: Container(
                        // 눌린 상태에 따라 색상 변경
                        color: pushData.pRead == "Y" ? Colors.white : const Color(0xFFF5F9F9),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: Responsive.getWidth(context, 50),
                                  height: Responsive.getWidth(context, 50),
                                  child: SvgPicture.asset(
                                    'assets/images/home/cate_ic_store.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: Responsive.getWidth(context, 15),),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: Responsive.getWidth(context, 315),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pushData.ptSubject ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          color: Colors.black,
                                          fontSize: Responsive.getFont(context, 15),
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Responsive.getHeight(context, 8),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          pushData.ptLabel ?? "",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            color: const Color(0xFF7B7B7B),
                                            fontSize: Responsive.getFont(context, 14),
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: Responsive.getHeight(context, 8),),
                                      Text(
                                        pushData.ptWdate ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          color: const Color(0xFF7B7B7B),
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: Responsive.getWidth(context, 21),),
                              Padding(
                                padding: EdgeInsets.only(top: Responsive.getHeight(context, 28)),
                                child: SvgPicture.asset(
                                  'assets/images/ic_link.svg',
                                  width: Responsive.getWidth(context, 14),
                                  height: Responsive.getHeight(context, 14),
                                  fit: BoxFit.contain,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF7B7B7B),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
            Visibility(
                visible: pushList.isNotEmpty,
                child: MoveTopButton(scrollController: _scrollController)),
            Visibility(
                visible: pushList.isEmpty,
                child: const NonDataScreen(text: '등록된 알림이 없습니다.',)
            ),
          ],
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx ?? "",
    };

    final pushResponseDTO = await ref.read(alarmViewModelProvider.notifier).getList(requestData);
    setState(() {
      pushList = pushResponseDTO?.list ?? [];
    });
  }
}
