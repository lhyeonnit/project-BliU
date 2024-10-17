import 'package:BliU/data/order_delivery_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/viewmodel/delivery_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  final String odtCode;

  const DeliveryScreen({super.key, required this.odtCode});

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  final ScrollController _scrollController = ScrollController();
  OrderDeliveryData? orderDeliveryData;

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
        title: const Text('배송현황'),
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
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Text(
                      '스마트택배 배송현황',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 18),
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('운송장번호',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              Text(orderDeliveryData?.ctDeliveryNumber ?? "",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black,
                                  height: 1.2,
                                )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('택배사',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black,
                                  height: 1.2,
                                )
                              ),
                              Text(orderDeliveryData?.ctDeliveryCom ?? "",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 10,
                    width: double.infinity,
                    color: const Color(0xFFF5F9F9),
                  ),

                  // 테이블 헤더
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '시간',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          '현재위치',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          '배송상태',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 데이터 리스트 표시 (배경색 반복)
                  Container(
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (orderDeliveryData?.delivery ?? []).map((item) {
                        int index =
                            (orderDeliveryData?.delivery ?? []).indexOf(item);
                        Color rowColor = index % 2 == 1
                            ? Colors.white // 짝수 행 색상
                            : const Color(0xFFF5F9F9); // 홀수 행 색상

                        return Container(
                          color: rowColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.time ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      item.where ?? '',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  item.kind ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    orderDelivery();
  }

  void orderDelivery() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'odt_code': widget.odtCode,
    };

    final orderDeliveryResponseDTO =
        await ref.read(deliveryViewModelProvider.notifier).getList(requestData);
    if (orderDeliveryResponseDTO != null) {
      if (orderDeliveryResponseDTO.result == true) {
        setState(() {
          orderDeliveryData = orderDeliveryResponseDTO.data;
        });
      } else {
        if (!context.mounted) return;
        Utils.getInstance()
            .showSnackBar(context, orderDeliveryResponseDTO.message ?? "");
      }
    }
  }
}
