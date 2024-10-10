import 'dart:convert';

import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/cart_item_data.dart';
import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/data/iamport_pay_data.dart';
import 'package:BliU/data/pay_order_detail_data.dart';
import 'package:BliU/dto/pay_order_result_detail_dto.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/bottom/component/terms_detail.dart';
import 'package:BliU/screen/payment/component/payment_address_info.dart';
import 'package:BliU/screen/payment/component/payment_discount.dart';
import 'package:BliU/screen/payment/component/payment_iamport.dart';
import 'package:BliU/screen/payment/component/payment_money.dart';
import 'package:BliU/screen/payment/component/payment_order_item.dart';
import 'package:BliU/screen/payment/payment_complete_screen.dart';
import 'package:BliU/screen/payment/viewmodel/payment_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final PayOrderDetailData payOrderDetailData;

  const PaymentScreen({required this.payOrderDetailData, super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends ConsumerState<PaymentScreen> {
  int totalPrice = 0;
  CouponData? selectedCouponData;
  int discountPoint = 0;
  // TODO 결제수단에 따라 보내는값 변경
  int payType = 0;//1 카드결제, 2 휴대폰, 3 계좌이체, 4 네이버페이

  bool allAgree = false;
  bool agree1 = false;
  bool agree2 = false;
  bool agree3 = false;

  void onResultTotalPrice(int totalPrice) {
    this.totalPrice = totalPrice;
  }

  void onCouponSelected(CouponData couponData) {
    setState(() {
      selectedCouponData = couponData;
    });
  }

  void onPointChanged(int point) {
    setState(() {
      discountPoint = point;
    });
  }

  final ScrollController _scrollController = ScrollController();
  late bool isUseAddress = false;
  String? savedRecipientName; // 저장된 수령인 이름
  String? savedRecipientPhone; // 저장된 전화번호
  String? savedZip; // 저장된 전화번호
  String? savedAddressRoad; // 저장된 도로명 주소
  String? savedAddressDetail; // 저장된 상세주소
  String? savedMemo; // 저장된 메모

  // 배송지 정보 저장 함수
  void _saveAddress(String name, String phone, String zip, String road,
      String detail, String memo) {
    setState(() {
      savedRecipientName = name;
      savedRecipientPhone = phone;
      savedZip = zip;
      savedAddressRoad = road;
      savedAddressDetail = detail;
      savedMemo = memo;
    });
  }

  void _agreeCheck() {
    if (agree1 && agree2 && agree3) {
      allAgree = true;
    } else {
      allAgree = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            _showCancelDialog(context);
          },
        ),
        titleSpacing: -1.0,
        title: const Text("결제하기"),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
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
            padding: const EdgeInsets.only(bottom: 80.0),
            child: ListView(
              children: [
                CustomExpansionTile(
                  title: '주문상품',
                  content: PaymentOrderItem(
                    cartList: widget.payOrderDetailData.list ?? [],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: const Color(0xFFF5F9F9),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    shape: const Border(
                      top: BorderSide(color: Colors.transparent, width: 0),
                      bottom: BorderSide(color: Colors.transparent, width: 0),
                    ),
                    title: Container(
                      padding: const EdgeInsets.symmetric(vertical: 19.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '배송지 정보',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isUseAddress = !isUseAddress;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                    border: Border.all(
                                      color: isUseAddress ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                    ),
                                    color: isUseAddress ? const Color(0xFFFF6191) : Colors.white,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/check01_off.svg', // 체크박스 아이콘
                                    colorFilter: ColorFilter.mode(
                                      isUseAddress ? Colors.white : const Color(0xFFCCCCCC),
                                      BlendMode.srcIn,
                                    ),
                                    height: 10,
                                    width: 10,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '다음에도 이 배송지 사용',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFEEEEEE),
                            ),
                          ),
                        ),
                        child: PaymentAddressInfo(
                          onSave: _saveAddress,
                          initialName: savedRecipientName ?? '',
                          initialPhone: savedRecipientPhone ?? '',
                          initialZip: savedZip ?? '',
                          initialRoadAddress: savedAddressRoad ?? '',
                          initialDetailAddress: savedAddressDetail ?? '',
                          initialMemo: savedMemo ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: const Color(0xFFF5F9F9),
                ),
                CustomExpansionTile(
                  title: '결제수단',
                  content: Container(
                    padding: const EdgeInsets.symmetric(vertical: 19.5, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payType = 1;
                                      });
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                              color: payType == 1 ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              '카드결제',
                                              style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  color: payType == 1 ? const Color(0xFFFF6192) : Colors.black,
                                                  fontSize: Responsive.getFont(context, 14)
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                )
                            ),
                            Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payType = 2;
                                      });
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                              color: payType == 2 ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              '휴대폰',
                                              style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  color: payType == 2 ? const Color(0xFFFF6192) : Colors.black,
                                                  fontSize: Responsive.getFont(context, 14)
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payType = 3;
                                      });
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                              color: payType == 3 ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              '계좌이체',
                                              style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  color: payType == 3 ? const Color(0xFFFF6192) : Colors.black,
                                                  fontSize: Responsive.getFont(context, 14)
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payType = 4;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: payType == 4 ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)),
                                      ),
                                      child: Center(
                                          child: Text(
                                            '네이버페이',
                                            style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                color: payType == 4 ? const Color(0xFFFF6192) : Colors.black,
                                                fontSize: Responsive.getFont(context, 14)
                                            ),
                                          )
                                      )
                                    ),
                                  ),
                                )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: const Color(0xFFF5F9F9),
                ),
                CustomExpansionTile(
                  title: '할인적용',
                  content: PaymentDiscount(
                    onCouponSelected: onCouponSelected,
                    onPointChanged: onPointChanged,
                    cartList: widget.payOrderDetailData.list ?? [],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: const Color(0xFFF5F9F9),
                ),
                CustomExpansionTile(
                  title: '결제 금액',
                  content: PaymentMoney(
                    onResultTotalPrice: onResultTotalPrice,
                    cartList: widget.payOrderDetailData.list ?? [],
                    discountCouponData: selectedCouponData,
                    discountPoint: discountPoint,
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: const Color(0xFFF5F9F9),
                ),
                Theme(
                  data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                  child: ListTileTheme(
                    //data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    horizontalTitleGap: 0,
                    //data: ListTileTheme.of(context),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      shape: const Border(
                        top: BorderSide(color: Colors.transparent, width: 0),
                        bottom: BorderSide(color: Colors.transparent, width: 0),
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          setState(() {
                            allAgree = !allAgree;
                            agree1 = allAgree;
                            agree2 = allAgree;
                            agree3 = allAgree;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(
                                color: allAgree ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                              ),
                              color: allAgree ? const Color(0xFFFF6191) : Colors.white,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/check01_off.svg', // 체크박스 아이콘
                              colorFilter: ColorFilter.mode(
                                allAgree ? Colors.white : const Color(0xFFCCCCCC),
                                BlendMode.srcIn,
                              ),
                              height: 10,
                              width: 10,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      title: Container(
                        padding: const EdgeInsets.symmetric(vertical: 19.5),
                        child: Text(
                          "주문내용 확인 및 결제동의",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      collapsedBackgroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 7.5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          agree1 = !agree1;
                                          _agreeCheck();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            height: 22,
                                            width: 22,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                              border: Border.all(
                                                color: agree1 ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                              ),
                                              color: agree1 ? const Color(0xFFFF6191) : Colors.white,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/check01_off.svg', // 체크박스 아이콘
                                              colorFilter: ColorFilter.mode(
                                                agree1 ? Colors.white : const Color(0xFFCCCCCC),
                                                BlendMode.srcIn,
                                              ),
                                              height: 10,
                                              width: 10,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '개인정보 수집 이용 동의',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              height: 1.2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const TermsDetail(type: 0),
                                        ),
                                      );
                                    },
                                    child:Container(
                                      width: 50,
                                      alignment: Alignment.centerRight,
                                      child: SvgPicture.asset(
                                        'assets/images/ic_link.svg',
                                        colorFilter: const ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    )
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          agree2 = !agree2;
                                          _agreeCheck();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            height: 22,
                                            width: 22,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                              border: Border.all(
                                                color: agree2 ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                              ),
                                              color: agree2 ? const Color(0xFFFF6191) : Colors.white,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/check01_off.svg', // 체크박스 아이콘
                                              colorFilter: ColorFilter.mode(
                                                agree2 ? Colors.white : const Color(0xFFCCCCCC),
                                                BlendMode.srcIn,
                                              ),
                                              height: 10,
                                              width: 10,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '개인정보 제 3자 정보 제공 동의',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              height: 1.2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const TermsDetail(type: 0),
                                          ),
                                        );
                                      },
                                      child:Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/images/ic_link.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 16, top: 7.5, right: 16, bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          agree3 = !agree3;
                                          _agreeCheck();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            height: 22,
                                            width: 22,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                              border: Border.all(
                                                color: agree3 ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                              ),
                                              color: agree3 ? const Color(0xFFFF6191) : Colors.white,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/check01_off.svg', // 체크박스 아이콘
                                              colorFilter: ColorFilter.mode(
                                                agree3 ? Colors.white : const Color(0xFFCCCCCC),
                                                BlendMode.srcIn,
                                              ),
                                              height: 10,
                                              width: 10,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '결제대행 서비스 이용약관 동의',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              height: 1.2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const TermsDetail(type: 0),
                                          ),
                                        );
                                      },
                                      child:Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/images/ic_link.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40)
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                MoveTopButton(scrollController: _scrollController),
                Container(
                  width: double.infinity,
                  height: Responsive.getHeight(context, 48),
                  margin: const EdgeInsets.only(
                      right: 16.0, left: 16, top: 8, bottom: 9),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _payment();
                    },
                    child: Center(
                      child: Text(
                        '결제하기',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      // 다른 영역을 클릭해도 닫힘
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      // 배경을 어둡게
      transitionDuration: const Duration(milliseconds: 100),
      // 애니메이션 시간
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter, // 화면 상단 중앙에 배치
          child: Material(
            color: Colors.transparent, // 배경을 투명하게
            child: Container(
              margin: const EdgeInsets.only(top: 50), // 상단에서의 간격
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xCC000000), // 알림창 배경색
                borderRadius: BorderRadius.circular(22), // 둥근 모서리
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로로 배치
                mainAxisSize: MainAxisSize.min, // 알림창 크기를 내용에 맞춤
                children: [
                  Text(
                    '주문을 취소하시겠습니까?',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // 팝업 닫기
                          },
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: Colors.white,
                              fontSize: Responsive.getFont(context, 14),
                              height: 1.2,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(
                              "확인",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: Colors.white,
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _payment() async {
    /***
     *
     * 결제 상세 -> 결제 요청(이전에 쿠폰 사용 포인트 사용 요청) -> 결제 모듈에서 결제 완료후 -> 결제 검증 -> 결제 완료
     *
     */

    // TODO 필수입력란 확인 필요
    List<CartData> cartList = widget.payOrderDetailData.list ?? [];

    // TODO 포인트, 쿠폰 사용 API작업 필요

    // 주문 고유 번호를 취득위해서 다시조회
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    List<Map<String, dynamic>> cartArr = [];

    for (var cartItem in cartList) {
      Map<String, dynamic> cartMap = {
        'st_idx': cartItem.stIdx,
      };
      List<int> ctIdxs = [];
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        ctIdxs.add(product.ctIdx ?? 0);
      }

      if (ctIdxs.isNotEmpty) {
        cartMap['ct_idxs'] = ctIdxs;
        cartArr.add(cartMap);
      }
    }

    Map<String, dynamic> requestData = {
      'type': 1,
      'ot_idx': widget.payOrderDetailData.otIdx,
      'mt_idx': mtIdx,
      'temp_mt_id': '',
      'cart_arr': json.encode(cartArr),
    };

    final payOrderDetailDTO = await ref.read(paymentViewModelProvider.notifier).orderDetail(requestData);
    if (payOrderDetailDTO != null) {
      final payOrderDetailData = payOrderDetailDTO.data;

      if (payOrderDetailData != null) {
        // 총 결제 금액
        int totalAmount = totalPrice;
        // 세금 제외 금액 설정 (현재는 0으로 설정)
        int taxFreeAmount = 0;
        // 주문 이름 생성 (상품 이름을 연결)
        String orderName = "";
        int itemCount = 0;
        for (var cart in cartList) {
          for (var item in cart.productList ?? [] as List<CartItemData>) {
            if (orderName.isEmpty) {
              orderName = item.ptTitle ?? "";
              itemCount += 1;
            }
          }
        }
        if (itemCount > 0) {
          orderName = "$orderName 외 ${itemCount - 1}";
        }

        // TODO 고객 정보 설정 (여기서는 고정값 사용) 고객정보 가져오기 필요
        //String customerKey = "unique_customer_key";
        //String customerName = "고객 이름";

        IamportPayData iamportPayData = IamportPayData(
            name: orderName,
            merchantUid: payOrderDetailData.otCode ?? "",
            amount: totalAmount,
            buyerName: "",
            buyerTel: "",
            buyerEmail: "",
            buyerAddr: "",
            buyerPostcode: ""
        );

        if (!mounted) return;

        final Map<String, String>? paymentResult = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentIamport(iamportPayData : iamportPayData)),
        );
        if (paymentResult != null) {
          // if (paymentResult['result'] == true) {
          //   final Success success = paymentResult["successData"];
          //
          //   _paymentComplete(paymentData, success);
          // } else {
          //   Utils.getInstance().showSnackBar(context, paymentResult["errorMessage"]);
          // }
          // TODO 일단 무조건 통과하게 변경
          _paymentComplete(payOrderDetailData);
        }
      }
    }
  }

  void _paymentComplete(PayOrderDetailData payOrderDetailData) async {
    // TODO 결제 결과값 전달?
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    List<CartData> cartList = widget.payOrderDetailData.list ?? [];

    String mtSaveAdd = "N";
    if (isUseAddress) {
      mtSaveAdd = "Y";
    }

    Map<String, dynamic> requestData1 = {
      'type': 1,
      'ot_code': payOrderDetailData.otCode,
      'mt_idx': mtIdx,
      'temp_mt_id': '',
      'mt_rname': savedRecipientName,
      'mt_rhp': savedRecipientPhone,
      'mt_zip': savedZip,
      'mt_add1': savedAddressRoad,
      'mt_add2': savedAddressDetail,
      'mt_save_add': mtSaveAdd,
      'memo': savedMemo,
    };

    //print("requestData == $requestData1");
    final Map<String, dynamic>? response = await ref
        .read(paymentViewModelProvider.notifier)
        .reqOrder(requestData1);
    if (response != null) {
      /*
      *
      "result": true,
      "data": {
          "ot_code": "240923G7FPKC",
          "ot_sprice": 32520
      }
      * **/
      // TODO 결제 검증 -> 결제 완료 API 순서로 진행
      // 결제검증 결과값 ex)  return res.status(200).json({'result': true, 'data':{'message': '결제 완료.'}});

      Map<String, dynamic> requestData2 = {
        'type': 1,
        'ot_code': payOrderDetailData.otCode,
        'mt_idx': mtIdx,
        'temp_mt_id': '',
      };
      final PayOrderResultDetailDTO? payOrderResult = await ref
          .read(paymentViewModelProvider.notifier)
          .orderEnd(requestData2);

      if (payOrderResult != null) {
        if (payOrderResult.result == true) {
          final payOrderResultDetailData = payOrderResult.data;
          if(!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                PaymentCompleteScreen(
                  payOrderResultDetailData: payOrderResultDetailData,
                  savedAddressDetail: savedAddressDetail,
                  savedAddressRoad: savedAddressRoad,
                  savedMemo: savedMemo,
                  savedRecipientName: savedRecipientName,
                  savedRecipientPhone: savedRecipientPhone,
                )
            ),
          );
        }
      }
    }
  }
}

// Custom ExpansionTile Widget
class CustomExpansionTile extends StatelessWidget {
  final String title;
  final Widget content;

  const CustomExpansionTile({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 19.5),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFEEEEEE),
                ),
              ),
            ),
            child: content,
          ),
        ],
      ),
    );
  }
}
