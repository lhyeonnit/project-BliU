import 'package:BliU/data/cancel_detail_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/cancel_item.dart';
import 'package:BliU/screen/mypage/component/top/component/exchange_return_info.dart';
import 'package:BliU/screen/mypage/viewmodel/cancel_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CancelDetailScreen extends ConsumerStatefulWidget {
  final OrderData? orderData;

  const CancelDetailScreen({super.key, required this.orderData,});

  @override
  ConsumerState<CancelDetailScreen> createState() => CancelDetailScreenState();
}

class CancelDetailScreenState extends ConsumerState<CancelDetailScreen> {
  OrderDetailData? orderDetailData;
  CancelDetailData? cancelDetailData;
  final ScrollController _scrollController = ScrollController();
  int? userType;

  @override
  void initState() {
    super.initState();
    orderDetailData = widget.orderData?.detailList?[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('취소'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: SvgPicture.asset("assets/images/product/ic_close.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 주문 날짜 및 ID
                      CancelItem(
                        cancelDetailData: cancelDetailData,
                        orderDetailData: orderDetailData,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFEEEEEE),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '배송비',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${Utils.getInstance().priceString((cancelDetailData?.order?.otDeliveryCharge ?? 0) + (cancelDetailData?.order?.otDeliveryChargeExtra ?? 0))}원",
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      ExchangeReturnInfo(cancelDetailData: cancelDetailData, userType: userType,),
                    ],
                  ),
                ),
              ],
            ),
            MoveTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getCancelDetail();
  }

  void _getCancelDetail() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'odt_code': orderDetailData?.odtCode,
    };

    final cancelDetailResponseDTO = await ref.read(cancelDetailModelProvider.notifier).getCancelDetail(requestData);

    if (cancelDetailResponseDTO != null) {
      if (cancelDetailResponseDTO.result == true) {
        cancelDetailData = cancelDetailResponseDTO.data;
        userType = memberType;
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, cancelDetailResponseDTO.message ?? "");
      }
    }
  }
}
