import 'dart:convert';

import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/coupon_receive/item/coupon_card.dart';
import 'package:BliU/screen/coupon_receive/view_model/coupon_receive_view_model.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CouponReceiveScreen extends ConsumerStatefulWidget {
  const CouponReceiveScreen({super.key});

  @override
  ConsumerState<CouponReceiveScreen> createState() => CouponReceiveScreenState();
}

class CouponReceiveScreenState extends ConsumerState<CouponReceiveScreen> {
  late int _ptIdx;
  bool _isAllDownload = false;

  List<CouponData> _couponList = [];

  @override
  void initState() {
    super.initState();
    _ptIdx = 0;
    try {
      _ptIdx = int.parse(Get.parameters["pt_idx"].toString());
    } catch(e) {
      //
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text('쿠폰 받기'),
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
      ),
      body: SafeArea(
        child: Utils.getInstance().isWebView(
          Stack(
            children: [
              Visibility(
                visible: _couponList.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: ListView.builder(
                    itemCount: _couponList.length,
                    itemBuilder: (context, index) {
                      final couponData = _couponList[index];

                      final couponDiscount = couponData.couponDiscount ?? "0";
                      final ctName = couponData.ctName ?? "";
                      final ctDate = "${couponData.ctDate ?? ""}까지 사용가능";

                      String detailMessage = "구매금액 ${Utils.getInstance().priceString(couponData.ctMinPrice ?? 0)}원 이상인경우 사용 가능";
                      if (couponData.ctMaxPrice != null) {
                        detailMessage = "최대 ${Utils.getInstance().priceString(couponData.ctMaxPrice ?? 0)} 할인 가능\n$detailMessage";
                      }

                      return CouponItem(
                        discount: couponDiscount,
                        title: ctName,
                        expiryDate: ctDate,
                        discountDetails: detailMessage,
                        isDownload: couponData.down == "Y" ? true : false,
                        onDownload: () {
                          if ((couponData.ctCode ?? "").isNotEmpty) {
                            _couponDownload([(couponData.ctCode ?? "")]);
                          }
                        },
                        couponKey: index.toString(), // 고유한 키 전달
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: _couponList.isEmpty,
                child: const NonDataScreen(text: '등록된 쿠폰이 없습니다.',),
              ),
              Visibility(
                visible: _couponList.isNotEmpty,
                child: Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        _allCouponDownload();
                      },
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                        decoration: BoxDecoration(
                          color: _isAllDownload
                              ? Colors.black // 모든 쿠폰이 다운로드된 경우 회색으로 비활성화
                              : const Color(0xFFDDDDDD), // 다운로드할 쿠폰이 있으면 활성화
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '전체받기',
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
                ),
              ),
              Visibility(
                visible: _couponList.isEmpty,
                child: Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                        decoration: const BoxDecoration(
                          color: Colors.black, // 다운로드할 쿠폰이 있으면 활성화
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'pt_idx': _ptIdx,
    };

    final productCouponResponseDTO = await ref.read(couponReceiveViewModelProvider.notifier).getList(requestData);
    setState(() {
      int downAbleCount = productCouponResponseDTO?.downAbleCount ?? 0;
      _couponList = productCouponResponseDTO?.list ?? [];
      _isAllDownload = downAbleCount == 0 ? false : true;
    });
  }

  // 전체쿠폰 다운로드
  void _allCouponDownload() async {
    List<String> ctCodes = [];
    for (var couponData in _couponList) {
      if (couponData.down == "Y") {
        ctCodes.add(couponData.ctCode ?? "");
      }
    }
    if (ctCodes.isNotEmpty) {
      _couponDownload(ctCodes);
    }
  }
  
  void _couponDownload(List<String> ctCodes) async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'ct_codes': json.encode(ctCodes),
    };

    final defaultResponseDTO = await ref.read(couponReceiveViewModelProvider.notifier).couponDown(requestData);
    if (defaultResponseDTO != null) {
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
      if (defaultResponseDTO.result == true) {
        _getList();
      }
    }
  }
}
