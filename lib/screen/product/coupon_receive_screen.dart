import 'package:BliU/data/product_coupon_data.dart';
import 'package:BliU/screen/product/component/detail/coupon_card.dart';
import 'package:BliU/screen/product/viewmodel/coupon_receive_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponReceiveScreen extends ConsumerStatefulWidget {
  final int? ptIdx;
  const CouponReceiveScreen({super.key, required this.ptIdx});

  @override
  _CouponReceiveScreenState createState() => _CouponReceiveScreenState();
}

class _CouponReceiveScreenState extends ConsumerState<CouponReceiveScreen> {
  late int ptIdx;
  bool isAllDownload = false;
  @override
  void initState() {
    super.initState();
    ptIdx = widget.ptIdx ?? 0;
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('쿠폰 받기'),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, widget) {
                      final model = ref.watch(couponReceiveModelProvider);
                      List<ProductCouponData> list = model?.productCouponResponseDTO?.list ?? [];
                      // TODO 전체다운 받아지는지 확인
                      setState(() {
                        //isAllDownload = true;
                      });


                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final productCouponData = list[index];
                          return CouponCard(// TODO 해당뷰 확인 필요
                            discount: productCouponData.couponDiscount ?? "0",
                            title: productCouponData.ctName ?? "",
                            expiryDate: productCouponData.ctDate ?? "",
                            discountDetails: (productCouponData.ctMaxPrice ?? 0).toString(),
                            isDownloaded: productCouponData.down == "Y" ? true : false,
                            // 상태 전달
                            onDownload: () {
                              setState(() {
                                // TODO 다운로드 로직 필요
                                list[index].down = "Y";
                              });
                            },
                            couponKey: index.toString(), // 고유한 키 전달
                          );
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                _allCouponDownload();
              },
              child: Container(
                width: double.infinity,
                height: Responsive.getHeight(context, 48),
                margin: const EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                decoration: BoxDecoration(
                  color: isAllDownload
                      ? const Color(0xFFDDDDDD) // 모든 쿠폰이 다운로드된 경우 회색으로 비활성화
                      : Colors.black, // 다운로드할 쿠폰이 있으면 활성화
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    '전체받기',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getList() async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx' : pref.getMtIdx(),
      'pt_idx' : ptIdx,
    };

    ref.read(couponReceiveModelProvider.notifier).getList(requestData);
  }

  // 전체쿠폰 다운로드
  void _allCouponDownload() async {

  }
}