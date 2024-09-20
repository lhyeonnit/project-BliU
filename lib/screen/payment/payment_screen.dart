import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/cart_item_data.dart';
import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/data/payment_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/payment/component/payment_address_info.dart';
import 'package:BliU/screen/payment/component/payment_discount.dart';
import 'package:BliU/screen/payment/component/payment_money.dart';
import 'package:BliU/screen/payment/component/payment_order_item.dart';
import 'package:BliU/screen/payment/component/payment_toss.dart';
import 'package:BliU/screen/payment/payment_complete_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final List<CartData> cartDetails;
  const PaymentScreen({required this.cartDetails, super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends ConsumerState<PaymentScreen> {
  int totalPrice = 0;
  CouponData? selectedCouponData;
  int discountPoint = 0;

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
  String? savedAddressRoad; // 저장된 도로명 주소
  String? savedAddressDetail; // 저장된 상세주소
  String? savedMemo; // 저장된 메모

  // 배송지 정보 저장 함수
  void _saveAddress(
      String name, String phone, String road, String detail, String memo) {
    setState(() {
      savedRecipientName = name;
      savedRecipientPhone = phone;
      savedAddressRoad = road;
      savedAddressDetail = detail;
      savedMemo = memo;
    });
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
        title: const Text("결제하기"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
                    cartDetails: widget.cartDetails,
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: const Color(0xFFF5F9F9),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '배송지 정보',
                            style: TextStyle(
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    border: Border.all(
                                      color: isUseAddress
                                          ? const Color(0xFFFF6191)
                                          : const Color(0xFFCCCCCC),
                                    ),
                                    color: isUseAddress
                                        ? const Color(0xFFFF6191)
                                        : Colors.white,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/check01_off.svg', // 체크박스 아이콘
                                    color: isUseAddress
                                        ? Colors.white
                                        : const Color(0xFFCCCCCC),
                                    height: 10,
                                    width: 10,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '다음에도 이 배송지 사용',
                                style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),
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
                  title: '할인적용',
                  content: PaymentDiscount(
                    onCouponSelected: onCouponSelected,
                    onPointChanged: onPointChanged,
                    cartDetails: widget.cartDetails,
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
                    cartDetails: widget.cartDetails,
                    discountCouponData: selectedCouponData,
                    discountPoint: discountPoint,
                  ),
                ),
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
                  margin: const EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
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
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.white,
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
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
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
                              color: Colors.white,
                              fontSize: Responsive.getFont(context, 14),
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
                                color: Colors.white,
                                fontSize: Responsive.getFont(context, 14),
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


    // 총 결제 금액
    int totalAmount = totalPrice;
    // 세금 제외 금액 설정 (현재는 0으로 설정)
    int taxFreeAmount = 0;
    // 주문 이름 생성 (상품 이름을 연결)
    String orderName = "";
    int itemCount = 0;
    for (var cart in widget.cartDetails) {
      for(var item in cart.productList ?? [] as List<CartItemData>) {
        if (item.isSelected && orderName.isEmpty) {
          orderName = item.ptTitle ?? "";
          itemCount += 1;
        }
      }
    }
    if (itemCount > 0) {
      orderName = "$orderName 외 ${itemCount - 1}";
    }

    // 고유 주문 ID 생성
    String orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";

    // TODO 고객 정보 설정 (여기서는 고정값 사용) 고객정보 가져오기 필요
    String customerKey = "unique_customer_key";
    String customerName = "고객 이름";

    final paymentData = PaymentData(
      customerKey: customerKey,
      orderId: orderId,
      amount: totalAmount,
      taxFreeAmount: taxFreeAmount,
      orderName: orderName,
      customerName: customerName,
    );

    final paymentResult = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentToss(paymentData: paymentData,)),
    );

    if (paymentResult != null) {
      // TODO 결제 결과값 전달?
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentCompleteScreen(
              cartDetails: widget.cartDetails,
              savedAddressDetail: savedAddressDetail,
              savedAddressRoad: savedAddressRoad,
              savedMemo: savedMemo,
              savedRecipientName: savedRecipientName,
              savedRecipientPhone: savedRecipientPhone,
            )),
      );
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold,
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
