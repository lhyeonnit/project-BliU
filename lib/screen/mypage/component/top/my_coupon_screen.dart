import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/screen/mypage/viewmodel/my_coupon_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyCouponScreen extends ConsumerStatefulWidget {
  const MyCouponScreen({super.key});

  @override
  ConsumerState<MyCouponScreen> createState() => _MyCouponScreenState();
}

class _MyCouponScreenState extends ConsumerState<MyCouponScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _categories = ['사용가능', '완료/만료'];
  int _selectedCategoryIndex = 0;

  List<CouponData> _couponList = [];
  int _couponCount = 0;

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
    _hasNextPage = true;

    final requestData = await _makeRequestData();

    final productCouponResponseDTO = await ref.read(myCouponViewModelProvider.notifier).getList(requestData);
    _couponCount = productCouponResponseDTO?.count ?? 0;
    _couponList = productCouponResponseDTO?.list ?? [];

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

      final requestData = await _makeRequestData();

      final productCouponResponseDTO = await ref.read(myCouponViewModelProvider.notifier).getList(requestData);
      if (productCouponResponseDTO != null) {
        if ((productCouponResponseDTO.list ?? []).isNotEmpty) {
          setState(() {
            _couponList.addAll(productCouponResponseDTO.list ?? []);
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

    String couponStatus = "Y";
    if (_selectedCategoryIndex == 1) {
      couponStatus = "N";
    }

    final Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'coupon_status': couponStatus,
      'pg': _page
    };

    return requestData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('쿠폰'),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final bool isSelected = _selectedCategoryIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                          _getList();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
                            width: 1.0,
                          ),
                          color: Colors.white,
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '쿠폰 $_couponCount',
                style: const TextStyle(
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _couponList.length,
                itemBuilder: (context, index) {

                  final productCouponData = _couponList[index];

                  final couponDiscount = productCouponData.couponDiscount ?? "0";
                  final ctName = productCouponData.ctName ?? "";
                  final couponName = productCouponData.couponName ?? "";
                  final ctDate = "${productCouponData.ctDate ?? ""}까지 사용가능";
                  final couponStatus = productCouponData.couponStatus ?? "";

                  String detailMessage = "구매금액 ${Utils.getInstance().priceString(productCouponData.ctMinPrice ?? 0)}원 이상인경우 사용 가능";
                  if (productCouponData.ctMaxPrice != null) {
                    detailMessage = "최대 ${Utils.getInstance().priceString(productCouponData.ctMaxPrice ?? 0)} 할인 가능\n$detailMessage";
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.solid, color: const Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          couponDiscount,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 16),
                                            fontWeight: FontWeight.bold,
                                            color: couponStatus == "사용가능" ? const Color(0xFFFF6192) : const Color(0xFFA4A4A4),
                                            height: 1.2,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 6),
                                            child: Text(
                                              ctName.isEmpty ? couponName : ctName,
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 16),
                                                fontWeight: FontWeight.bold,
                                                color: couponStatus == "사용가능" ? Colors.black : const Color(0xFFA4A4A4),
                                                height: 1.2,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        ctDate,
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          color: couponStatus == "사용가능" ? Colors.black : const Color(0xFFA4A4A4),
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      detailMessage,
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 12),
                                        color: const Color(0xFFA4A4A4),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (couponStatus != "사용가능") // 다운로드된 경우에만 텍스트 표시
                                      SizedBox(
                                        child: Text(
                                          productCouponData.couponStatus ?? "",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 12),
                                            color: Colors.grey,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
