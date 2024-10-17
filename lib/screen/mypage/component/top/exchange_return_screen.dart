import 'dart:io';

import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/data/order_detail_info_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/cancel_item.dart';
import 'package:BliU/screen/mypage/component/top/component/exchange_detail_item.dart';
import 'package:BliU/screen/mypage/component/top/component/return_detail_item.dart';
import 'package:BliU/screen/mypage/viewmodel/exchange_return_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

//교환 반품
class ExchangeReturnScreen extends ConsumerStatefulWidget {
  final OrderData orderData;
  final OrderDetailData orderDetailData;

  const ExchangeReturnScreen({super.key, required this.orderData, required this.orderDetailData});

  @override
  ConsumerState<ExchangeReturnScreen> createState() => ExchangeReturnScreenState();
}

class ExchangeReturnScreenState extends ConsumerState<ExchangeReturnScreen> {
  OrderDetailInfoData? orderDetailInfoData;
  List<CategoryData> exchangeCategory = [];
  List<CategoryData> returnCategory = [];
  List<CategoryData> exchangeDeliveryCostCategory = [];

  final ScrollController _scrollController = ScrollController();

  List<String> categories = ['교환', '반품/환불'];
  int selectedIndex = 0;
  String reason = ''; // 요청사유
  int reasonIdx = 0;
  String returnAccount = '';
  String returnBank = '';
  String details = ''; // 상세내용
  int shippingCost = 0;
  List<File> images = [];

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
        title: const Text('교환/반품 요청'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
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
            padding: const EdgeInsets.only(bottom: 80), // 하단 버튼 공간 확보
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 주문 날짜 및 ID
                CancelItem(
                  orderData: widget.orderData,
                  orderDetailData: widget.orderDetailData,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 교환 버튼
                      _buildCustomButton(
                        context,
                        text: "교환",
                        isSelected: selectedIndex == 0,
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      // 반품/환불 버튼
                      _buildCustomButton(
                        context,
                        text: "반품/환불",
                        isSelected: selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _buildSelectedPage(),
              ],
            ),
          ),
          // 하단 고정 버튼
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                MoveTopButton(scrollController: _scrollController),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      _orderReturn();
                    },
                    child: Container(
                      height: Responsive.getHeight(context, 48),
                      margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
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

  void _afterBuild(BuildContext context) {
    _getOrderDetail();
  }

  void _getOrderDetail() async {

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    Map<String, dynamic> requestData1 = {
      'type': memberType,
      'mt_idx': mtIdx,
      'temp_mt_id': appToken,
      'ot_code': widget.orderDetailData.otCode,
    };

    Map<String, dynamic> requestData2 = {
      'ct_type': 1,
    };

    Map<String, dynamic> requestData3 = {
      'ct_type': 2,
    };

    final orderDetailInfoResponseDTO = await ref
        .read(exchangeReturnViewModelProvider.notifier)
        .getOrderDetail(requestData1);
    final exchangeCategoryResponseDTO = await ref
        .read(exchangeReturnViewModelProvider.notifier)
        .getCategory(requestData2);
    final returnCategoryResponseDTO = await ref
        .read(exchangeReturnViewModelProvider.notifier)
        .getCategory(requestData3);
    final exchangeDeliveryCostCategoryResponseDTO = await ref
        .read(exchangeReturnViewModelProvider.notifier)
        .getExchangeDeliveryCostCategory();

    if (orderDetailInfoResponseDTO != null) {
      if (orderDetailInfoResponseDTO.result == true) {
        orderDetailInfoData = orderDetailInfoResponseDTO.data;
      } else {
        if (!context.mounted) return;
        Utils.getInstance()
            .showSnackBar(context, orderDetailInfoResponseDTO.message ?? "");
      }
    }
    if (exchangeCategoryResponseDTO != null) {
      if (exchangeCategoryResponseDTO.result == true) {
        exchangeCategory = exchangeCategoryResponseDTO.list ?? [];
      }
    }
    if (returnCategoryResponseDTO != null) {
      if (returnCategoryResponseDTO.result == true) {
        returnCategory = returnCategoryResponseDTO.list ?? [];
      }
    }
    if (exchangeDeliveryCostCategoryResponseDTO != null) {
      if (exchangeDeliveryCostCategoryResponseDTO.result == true) {
        exchangeDeliveryCostCategory =
            exchangeDeliveryCostCategoryResponseDTO.list ?? [];
      }
    }
    setState(() {});
  }

  void _orderReturn() async {
    if (reasonIdx == 0) {
      Utils.getInstance().showSnackBar(context, "사유를 선택해 주세요");
      return;
    }

    if (details.isEmpty) {
      Utils.getInstance().showSnackBar(context, "세부 내용을 입력해 주세요.");
      return;
    }

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String? appToken = pref.getToken();
    int memberType = (mtIdx != null) ? 1 : 2;
    String ctType = selectedIndex == 0 ? 'X' : 'R';
    String ortReturnInfo = "";
    if (ctType == "X") {
      ortReturnInfo = shippingCost.toString();
    }

    final List<MultipartFile> files = images.map((img) => MultipartFile.fromFileSync(img.path)).toList();

    final formData = FormData.fromMap({
      'type': memberType,
      'mt_idx': mtIdx,
      'odt_code': widget.orderDetailData.odtCode,
      'ct_type': ctType,
      'ct_idx': reasonIdx,
      'ct_reason': details,
      'ort_return_info': ortReturnInfo,
      'ct_img': files,
      'ort_return_bank_info': "$returnBank $returnAccount",
      'temp_mt_id': appToken,
    });

    final defaultResponseDTO = await ref.read(exchangeReturnViewModelProvider.notifier).orderReturn(formData);
    if (!mounted) return;
    Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
    if (defaultResponseDTO.result) {
      Navigator.pop(context);
    }
  }

  Widget _buildSelectedPage() {
    if (selectedIndex == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ExchangeItem(
          orderDetailInfoData: orderDetailInfoData,
          exchangeCategory: exchangeCategory,
          exchangeDeliveryCostCategory: exchangeDeliveryCostCategory,
          onDataCollected: (String collectedReason,
              int collectedReasonIdx,
              String collectedDetails,
              int collectedShippingCost,
              List<File> collectedImages) {
            setState(() {
              reason = collectedReason;
              reasonIdx = collectedReasonIdx;
              details = collectedDetails;
              shippingCost = collectedShippingCost;
              images = collectedImages;
            });
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ReturnItem(
          orderDetailInfoData: orderDetailInfoData,
          returnCategory: returnCategory,
          onDataCollected: (String collectedReason,
              int collectedReasonIdx,
              String collectedDetails,
              String collectedReturnBank,
              String collectedReturnAccount,
              List<File> collectedImages) {
            setState(() {
              reason = collectedReason;
              reasonIdx = collectedReasonIdx;
              details = collectedDetails;
              returnBank = collectedReturnBank;
              returnAccount = collectedReturnAccount;
              images = collectedImages;
            });
          },
        ),
      );
    }
  }

  Widget _buildCustomButton(BuildContext context,
      {required String text,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD), // 테두리 색상
              width: 1.0,
            ),
            color: Colors.white, // 배경색
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                // 선택 시 텍스트 색상 변경
                fontWeight: FontWeight.normal,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
