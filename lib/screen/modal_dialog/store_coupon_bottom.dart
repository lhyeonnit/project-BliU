import 'dart:convert';

import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/data/store_data.dart';
import 'package:BliU/screen/coupon_receive/item/coupon_card.dart';
import 'package:BliU/screen/modal_dialog/view_model/store_coupon_bottom_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreCouponBottom extends ConsumerStatefulWidget {
  const StoreCouponBottom({super.key});

  static void showBottomSheet(BuildContext context, StoreData storeData, void Function(bool) allCheckCallback) {
    var isAllBool = false;
    Future<void> future = showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      // set this to true
      useSafeArea: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            snap: true,
            builder: (context, scrollController) {
              return StoreCouponBottomContent(
                storeData: storeData,
                scrollController: scrollController,
                allCheckCallback: (isAll) {
                  isAllBool = isAll;
                },
              );
            },
          ),
        );
      },
    );
    future.then((void value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        allCheckCallback(isAllBool);
      });
    });
  }

  @override
  ConsumerState<StoreCouponBottom> createState() => StoreCouponBottomState();
}

class StoreCouponBottomState extends ConsumerState<StoreCouponBottom> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class StoreCouponBottomContent extends ConsumerStatefulWidget {
  final StoreData storeData;
  final ScrollController scrollController;
  final void Function(bool) allCheckCallback;

  const StoreCouponBottomContent({super.key, required this.storeData, required this.scrollController, required this.allCheckCallback});

  @override
  ConsumerState<StoreCouponBottomContent> createState() => StoreCouponBottomContentState();
}

class StoreCouponBottomContentState extends ConsumerState<StoreCouponBottomContent> {
  late StoreData _storeData;
  bool _isAllDownload = false;
  List<CouponData> _couponList = [];

  @override
  void initState() {
    super.initState();
    _storeData = widget.storeData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'st_idx': _storeData.stIdx,
    };

    final productCouponResponseDTO = await ref.read(storeCouponBottomViewModelProvider.notifier).getList(requestData);
    setState(() {
      int downAbleCount = productCouponResponseDTO?.downAbleCount ?? 0;
      _couponList = productCouponResponseDTO?.list ?? [];
      _isAllDownload = downAbleCount == 0 ? false : true;
      if (_isAllDownload) {
        widget.allCheckCallback(true);
      }
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

    final defaultResponseDTO = await ref.read(storeCouponBottomViewModelProvider.notifier).couponDown(requestData);
    if (defaultResponseDTO != null) {
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
      if (defaultResponseDTO.result == true) {
        _getList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 15),
                  child: Image.asset('assets/images/product/empty_coupon.png',
                    width: 180,
                    height: 180,
                  ),
                ),
                Text(
                  '지금은 쿠폰이 없어요!',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF7B7B7B),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
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
    );
  }
}