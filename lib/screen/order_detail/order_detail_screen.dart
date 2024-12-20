import 'package:BliU/data/change_order_detail_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/exchange_return/child_widget/exchange_return_info_child_widget.dart';
import 'package:BliU/screen/order_detail/child_widget/order_detail_child_widget.dart';
import 'package:BliU/screen/order_detail/view_model/order_detail_view_model.dart';
import 'package:BliU/screen/order_list/item/order_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final OrderData orderData;
  final OrderDetailData detailList;

  const OrderDetailScreen({
    super.key,
    required this.orderData,
    required this.detailList,
  });

  @override
  ConsumerState<OrderDetailScreen> createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  OrderDetailInfoData? orderDetailInfoData;
  ChangeOrderDetailData? changeOrderDetailData;
  int? userType;
  String? type;

  @override
  void initState() {
    super.initState();
    type = widget.detailList.type;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }
  String _statusTitle() {
    if (type == "C") {
      return "취소";
    } else if (type == "R") {
      return "반품/환불";
    } else if (type == "X") {
      return "교환";
    } else {
      return "주문상세";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          _statusTitle(),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
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
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주문 날짜 및 ID
                Container(
                  padding: const EdgeInsets.only(left: 16, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.orderData.ctWdate ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          orderDetailInfoData?.product?[0].otCode ?? "",
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
                // 주문 아이템 리스트
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: (widget.orderData.detailList ?? []).map((orderDetailData) {
                      return OrderItem(
                        orderData: widget.orderData,
                        orderDetailData: orderDetailData,
                        changeOrderDetailData: changeOrderDetailData,
                        isList: false,
                      );
                    }).toList(),
                  ),
                ),
                // 배송비 정보
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFEEEEEE),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        "${Utils.getInstance().priceString((orderDetailInfoData?.order?.otDeliveryCharge ?? 0) + (orderDetailInfoData?.order?.otDeliveryChargeExtra ?? 0))}원",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: type == "-",
                  child: const SizedBox(height: 20),
                ),
                Visibility(
                  visible: type != "-",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        height: 10,
                        width: double.infinity,
                        color: const Color(0xFFF5F9F9),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("요청일",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                              ),
                            ),
                            Text(changeOrderDetailData?.info?.octWdate ?? changeOrderDetailData?.info?.ortWdate ?? '',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.only(top: 10, bottom: 4),
                        child: Text(changeOrderDetailData?.info?.octCancelTxt ?? changeOrderDetailData?.info?.ortReturnTxt ?? "",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(changeOrderDetailData?.info?.octCancelMemo1 ?? changeOrderDetailData?.info?.ortReturnMemo1 ?? '',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: changeOrderDetailData?.returnIdx != null,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.only(top: 10),
                              height: 100, // 세로 크기 제한
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: changeOrderDetailData?.info?.ortImg?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final imageUrl = changeOrderDetailData?.info?.ortImg?[index] ?? '';
                                    return AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0), // 이미지 간격 설정
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return SvgPicture.asset(
                                              'assets/images/no_imge.svg',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.fitWidth,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: type == "R",
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(changeOrderDetailData?.info?.ortReturnBankInfo ?? '',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text('환불 받을 계좌',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: type != "-" && type != "X",
                  child: ExchangeReturnInfoChildWidget(
                    userType: userType,
                    returnInfoData: changeOrderDetailData?.returnInfoData,
                    orderDetailData: widget.detailList,

                  ),
                ),
                Visibility(
                  visible: type == "X",
                  child: const SizedBox(height: 20),
                ),
                OrderDetailChildWidget(userType: userType ?? 0, type: type, orderDetailInfoData: orderDetailInfoData, ),
              ],
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getOrderDetail();

    if (type == "C") {
      _getCancelDetail();
    } else if (type == "R" || type == "X") {
      _getReturnDetail();
    }
  }

  void _getOrderDetail() async {

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'ot_code': widget.orderData.detailList?[0].otCode,
    };

    final orderDetailInfoResponseDTO = await ref.read(orderDetailViewModelProvider.notifier).getOrderDetail(requestData);
    if (orderDetailInfoResponseDTO != null) {
      if (orderDetailInfoResponseDTO.result == true) {
        setState(() {
          orderDetailInfoData = orderDetailInfoResponseDTO.data;
          userType = memberType;
        });
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, orderDetailInfoResponseDTO.message ?? "");
      }
    }
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
      'odt_code': widget.detailList.odtCode,
    };

    final cancelDetailResponseDTO = await ref.read(orderDetailViewModelProvider.notifier).getCancelDetail(requestData);
    if (cancelDetailResponseDTO != null) {
      if (cancelDetailResponseDTO.result == true) {
        setState(() {
          changeOrderDetailData = cancelDetailResponseDTO.data;
          userType = memberType;
        });
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, cancelDetailResponseDTO.message ?? "");
      }
    }
  }
  void _getReturnDetail() async {

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'odt_code': widget.detailList.odtCode,
      'ct_type': type,
    };

    final exchangeReturnDetailResponseDTO = await ref.read(orderDetailViewModelProvider.notifier).getReturnDetail(requestData);
    if (exchangeReturnDetailResponseDTO != null) {
      if (exchangeReturnDetailResponseDTO.result == true) {
        setState(() {
          userType = memberType;
          changeOrderDetailData = exchangeReturnDetailResponseDTO.data;
        });
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, exchangeReturnDetailResponseDTO.message ?? "");
      }
    }
  }
}
