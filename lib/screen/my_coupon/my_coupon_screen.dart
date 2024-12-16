import 'package:BliU/screen/my_coupon/view_model/my_coupon_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyCouponScreen extends ConsumerStatefulWidget {
  const MyCouponScreen({super.key});

  @override
  ConsumerState<MyCouponScreen> createState() => MyCouponScreenState();
}

class MyCouponScreenState extends ConsumerState<MyCouponScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _categories = ['사용가능', '완료/만료'];

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
    final requestData = await _makeRequestData();
    ref.read(myCouponViewModelProvider.notifier).listLoad(requestData);
  }

  void _nextLoad() async {
    if (_scrollController.position.extentAfter < 200) {
      final requestData = await _makeRequestData();
      ref.read(myCouponViewModelProvider.notifier).listNextLoad(requestData);
    }
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    final model = ref.read(myCouponViewModelProvider);

    String couponStatus = "Y";
    if (model.selectedCategoryIndex == 1) {
      couponStatus = "N";
    }

    final Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'coupon_status': couponStatus,
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
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, widget) {
            final viewModel = ref.read(myCouponViewModelProvider.notifier);
            final model = ref.watch(myCouponViewModelProvider);
            final selectedCategoryIndex = model.selectedCategoryIndex;
            final couponCount = model.couponCount;
            final couponList = model.couponList;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final bool isSelected = selectedCategoryIndex == index;

                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.setSelectedCategoryIndex(index);
                                  _getList();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
                                      width: 1.0,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
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
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: couponList.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '쿠폰 $couponCount',
                            style: const TextStyle(
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: couponList.isNotEmpty,
                        child: Expanded(
                          flex: 1,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: couponList.length,
                            itemBuilder: (context, index) {
                              final productCouponData = couponList[index];

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
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      color: const Color(0xFFDDDDDD),
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                            fontSize:
                                                            Responsive.getFont(context, 16),
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
                                                    fontSize:
                                                    Responsive.getFont(context, 12),
                                                    color: const Color(0xFFA4A4A4),
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: couponStatus != "사용가능" ? true : false,
                                          child: Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
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
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: couponList.isEmpty,
                  //child: const NonDataScreen(text: '등록된 쿠폰이 없습니다.'),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 200, bottom: 15),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
