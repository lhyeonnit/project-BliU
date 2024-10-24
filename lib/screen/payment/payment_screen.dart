import 'dart:convert';

import 'package:BliU/data/cart_data.dart';
import 'package:BliU/data/cart_item_data.dart';
import 'package:BliU/data/coupon_data.dart';
import 'package:BliU/data/daum_post_data.dart';
import 'package:BliU/data/iamport_pay_data.dart';
import 'package:BliU/data/pay_order_detail_data.dart';
import 'package:BliU/dto/pay_order_result_detail_dto.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/bottom/component/terms_detail.dart';
import 'package:BliU/screen/payment/component/payment_coupon.dart';
import 'package:BliU/screen/payment/component/payment_order_item.dart';
import 'package:BliU/screen/payment/component/webview_with_daum_post_webivew.dart';
import 'package:BliU/screen/payment/payment_complete_screen.dart';
import 'package:BliU/screen/payment/viewmodel/payment_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final PayOrderDetailData payOrderDetailData;
  final int memberType;

  const PaymentScreen({required this.payOrderDetailData, required this.memberType, super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends ConsumerState<PaymentScreen> {
  int _totalPrice = 0;
  CouponData? _selectedCouponData;
  int _discountPoint = 0;

  bool _isLoading = false;

  int _payType = 1; //1 카드결제, 2 휴대폰, 3 계좌이체, 4 네이버페이

  bool _allAgree = false;
  bool _agree1 = false;
  bool _agree2 = false;
  bool _agree3 = false;

  final ScrollController _scrollController = ScrollController();

  late bool _isUseAddress = false;

  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _recipientPhoneController = TextEditingController();
  final TextEditingController _addressRoadController = TextEditingController();
  final TextEditingController _addressDetailController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  String _savedZip = ""; // 저장된 우편번호

  final TextEditingController _pointController = TextEditingController();
  List<CouponData> _couponList = [];
  String _couponText = "0원 할인 적용";
  int _point = 0;

  int _userDeliveryPrice = 0;

  @override
  void initState() {
    super.initState();

    // 주소 셋팅
    if (widget.payOrderDetailData.userDeliveyAdd != null) {
      final userDeliveyAdd = widget.payOrderDetailData.userDeliveyAdd!;
      _isUseAddress = true;
      _recipientNameController.text = userDeliveyAdd.matName ?? "";
      _recipientPhoneController.text = userDeliveyAdd.matHp ?? "";

      _savedZip = userDeliveyAdd.matZip ?? "";
      _addressRoadController.text = userDeliveyAdd.matAdd1 ?? "";
      _addressDetailController.text = userDeliveyAdd.matAdd2 ?? "";
      _memoController.text = userDeliveyAdd.matMemo1 ?? "";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _getMy();
    _getOrderCoupon();
    if (widget.payOrderDetailData.userDeliveyAdd != null) {
      _addressChange();
    }
  }

  void _getMy() async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
    };

    final memberInfoResponseDTO = await ref.read(paymentViewModelProvider.notifier).getMy(requestData);
    setState(() {
      _point = memberInfoResponseDTO?.data?.myPoint ?? 0;
    });
  }

  void _getOrderCoupon() async {
    final pref = await SharedPreferencesManager.getInstance();

    List<Map<String, dynamic>> storeArr = [];
    final cartList = widget.payOrderDetailData.list ?? [];
    for (var cartItem in cartList) {
      Map<String, dynamic> storeMap = {
        'st_idx': cartItem.stIdx,
      };
      int productPrice = 0;
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        productPrice += ((product.ptPrice ?? 0) * (product.ptCount ?? 0));
      }

      if (productPrice > 0) {
        storeMap['store_all_price'] = productPrice;
        storeArr.add(storeMap);
      }
    }

    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'store_arr': json.encode(storeArr),
      'all_price': _getTotalProductPrice(),
    };

    final couponResponseDTO = await ref
        .read(paymentViewModelProvider.notifier)
        .getOrderCoupon(requestData);
    _couponList = couponResponseDTO?.list ?? [];
  }

  void _addressChange() async {
    List<CartData> cartList = widget.payOrderDetailData.list ?? [];
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
      'ot_idx': widget.payOrderDetailData.otIdx,
      'cart_arr': json.encode(cartArr),
      'mt_zip': _savedZip,
      'mt_add1': _addressRoadController.text,
      'all_delivery_price': widget.payOrderDetailData.allDeliveryPrice,
    };

    final responseData = await ref
        .read(paymentViewModelProvider.notifier)
        .orderLocal(requestData);
    if (responseData != null) {
      setState(() {
        _userDeliveryPrice = responseData['data']['user_delivey_add'] ?? 0;
      });
    }
  }

  void _addressSearch() async {
    // 주소 검색 API 호출
    DaumPostData? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewWithDaumPostWebView(), // 주소 검색 창으로 이동
      ),
    );

    if (result != null) {
      setState(() {
        _addressRoadController.text = result.roadAddress;
        _savedZip = result.zonecode;
        _addressChange();
      });
    }
  }

  int _getTotalProductPrice() {
    // 선택된 기준으로 가격 가져오기
    int totalProductPrice = 0;
    final cartList = widget.payOrderDetailData.list ?? [];
    for (var cartItem in cartList) {
      for (var product in cartItem.productList ?? [] as List<CartItemData>) {
        totalProductPrice += ((product.ptPrice ?? 0) * (product.ptCount ?? 0));
      }
    }
    return totalProductPrice;
  }

  int _getTotalDeliveryPrice() {
    int totalDeliveryPrice = widget.payOrderDetailData.allDeliveryPrice ?? 0;
    // final cartList = widget.payOrderDetailData.list ?? [];
    // for (var cartItem in cartList) {
    //   totalDeliveryPrice += cartItem.stDeliveryPrice ?? 0;
    // }

    totalDeliveryPrice += _userDeliveryPrice;
    return totalDeliveryPrice;
  }

  void _pointCheck(String point) {
    if (point.isNotEmpty) {
      int pointValue = int.parse(point);
      int totalProductPrice = _getTotalProductPrice();
      if (pointValue > totalProductPrice) {
        pointValue = totalProductPrice;
      }
      _pointController.text = pointValue.toString();

      setState(() {
        _discountPoint = pointValue;
      });
    } else {
      setState(() {
        _discountPoint = 0;
      });
    }
  }

  void _agreeCheck() {
    if (_agree1 && _agree2 && _agree3) {
      _allAgree = true;
    } else {
      _allAgree = false;
    }
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
    if (!_allAgree) {
      Utils.getInstance().showSnackBar(context, '결제동의해 주세요.');
      return;
    }

    if (_payType == 0) {
      Utils.getInstance().showSnackBar(context, '결제수단을 선택해 주세요.');
      return;
    }

    if (_recipientNameController.text.isEmpty) {
      Utils.getInstance().showSnackBar(context, '수령인명을 입력해 주세요.');
      return;
    }

    if (_recipientPhoneController.text.isEmpty) {
      Utils.getInstance().showSnackBar(context, '수령인 휴대폰 번호를 입력해 주세요.');
      return;
    }

    if (_addressRoadController.text.isEmpty ||
        _addressDetailController.text.isEmpty) {
      Utils.getInstance().showSnackBar(context, '수령인 주소를 입력해 주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String payMethod = "card";
    switch (_payType) {
      //1 카드결제, 2 휴대폰, 3 계좌이체, 4 네이버페이
      case 1:
        payMethod = "card";
        break;
      case 2:
        payMethod = "phone";
        break;
      case 3:
        payMethod = "trans";
        break;
      case 4: // 네이버 결제
        break;
    }

    List<CartData> cartList = widget.payOrderDetailData.list ?? [];

    // 주문 고유 번호를 취득위해서 다시조회
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";
    final memberInfo = pref.getMemberInfo();

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
      'type': mtIdx.isNotEmpty ? 1 : 2,
      'ot_idx': widget.payOrderDetailData.otIdx,
      'mt_idx': mtIdx,
      'temp_mt_id': pref.getToken(),
      'cart_arr': json.encode(cartArr),
    };

    final payOrderDetailDTO = await ref.read(paymentViewModelProvider.notifier).orderDetail(requestData);
    if (payOrderDetailDTO != null) {
      final payOrderDetailData = payOrderDetailDTO.data;

      if (payOrderDetailData != null) {
        // 총 결제 금액
        int totalAmount = _totalPrice;
        // 주문 이름 생성 (상품 이름을 연결)
        String orderName = "";
        int itemCount = 0;
        for (var cart in cartList) {
          for (var item in cart.productList ?? []) {
            if (orderName.isEmpty) {
              orderName = item.ptName ?? "";
            }
            itemCount += 1;
          }
        }
        if (itemCount > 1) {
          orderName = "$orderName 외 ${itemCount - 1}";
        }

        String mtSaveAdd = "N";
        if (_isUseAddress) {
          mtSaveAdd = "Y";
        }

        if (_selectedCouponData != null) {
          Map<String, dynamic> requestCouponData = {
            'ot_code': payOrderDetailData.otCode,
            'coupon_idx': _selectedCouponData?.couponIdx,
            'mt_idx': mtIdx,
          };

          await ref
              .read(paymentViewModelProvider.notifier)
              .couponUse(requestCouponData);
        }

        if (_discountPoint > 0) {
          Map<String, dynamic> requestPointData = {
            'ot_code': payOrderDetailData.otCode,
            'use_point': _discountPoint,
            'mt_idx': mtIdx,
          };

          await ref
              .read(paymentViewModelProvider.notifier)
              .pointUse(requestPointData);
        }

        Map<String, dynamic> requestData1 = {
          'type': mtIdx.isNotEmpty ? 1 : 2,
          'ot_code': payOrderDetailData.otCode,
          'mt_idx': mtIdx,
          'temp_mt_id': pref.getToken(),
          'mt_rname': _recipientNameController.text,
          'mt_rhp': _recipientPhoneController.text,
          'mt_zip': _savedZip,
          'mt_add1': _addressRoadController.text,
          'mt_add2': _addressDetailController.text,
          'mt_save_add': mtSaveAdd,
          'memo': _memoController.text,
        };

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
          if (response['result'] == true) {
            if (!mounted) return;

            IamportPayData iamportPayData = IamportPayData(
                payMethod: payMethod,
                name: orderName,
                merchantUid: payOrderDetailData.otCode ?? "",
                amount: totalAmount,
                buyerName: memberInfo?.mtName ?? "",
                buyerTel: "",
                buyerEmail: "",
                buyerAddr: "",
                buyerPostcode: "");

            // TODO 결제모듈 차후 다시 테스트
            // final Map<String, String>? paymentResult = await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PaymentIamport(iamportPayData : iamportPayData)),
            // );
            // if (paymentResult != null) {
            //   if (paymentResult['imp_success'] == 'true' || paymentResult['success'] == 'true') {
            //
            //     Map<String, dynamic> orderRequestData = {
            //       'orderId': payOrderDetailData.otCode ?? "",
            //       'imp_uid': paymentResult['imp_uid'].toString(),
            //       'merchant_uid': paymentResult['merchant_uid'].toString(),
            //     };
            //     final defaultResponseDTO = await ref.read(paymentViewModelProvider.notifier).orderCheck(orderRequestData);
            //     // 결제검증 결과값 ex)  return res.status(200).json({'result': true, 'data':{'message': '결제 완료.'}});
            //     if (defaultResponseDTO?.result == true) {
            //       _paymentComplete(payOrderDetailData);
            //     } else {
            //       if (!mounted) return;
            //       Utils.getInstance().showSnackBar(context, defaultResponseDTO?.message ?? "");
            //     }
            //   } else {
            //     if (!mounted) return;
            //     Utils.getInstance().showSnackBar(context, paymentResult["error_msg"].toString());
            //   }
            // }

            // TODO 테스트용
            Map<String, dynamic> orderRequestData = {
              'orderId': payOrderDetailData.otCode ?? "",
              'imp_uid': '',
              'merchant_uid': '',
            };
            final defaultResponseDTO = await ref.read(paymentViewModelProvider.notifier).orderCheck(orderRequestData);
            // 결제검증 결과값 ex)  return res.status(200).json({'result': true, 'data':{'message': '결제 완료.'}});
            if (defaultResponseDTO?.result == true) {
              _paymentComplete(payOrderDetailData);
              return;
            } else {
              if (!mounted) return;
              Utils.getInstance().showSnackBar(context, defaultResponseDTO?.message ?? "");
            }
          } else {
            if (!mounted) return;
            Utils.getInstance().showSnackBar(context, response['data']['message'] ?? "");
          }
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _paymentComplete(PayOrderDetailData payOrderDetailData) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";

    Map<String, dynamic> requestData2 = {
      'type': mtIdx.isNotEmpty ? 1 : 2,
      'ot_code': payOrderDetailData.otCode,
      'mt_idx': mtIdx,
      'temp_mt_id': pref.getToken(),
    };
    final PayOrderResultDetailDTO? payOrderResult = await ref.read(paymentViewModelProvider.notifier).orderEnd(requestData2);

    if (payOrderResult != null) {
      if (payOrderResult.result == true) {
        final payOrderResultDetailData = payOrderResult.data;
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
              PaymentCompleteScreen(
                memberType: mtIdx.isNotEmpty ? 1 : 2,
                payType: _payType,
                payOrderResultDetailData: payOrderResultDetailData,
                savedRecipientName: _recipientNameController.text,
                savedRecipientPhone: _recipientPhoneController.text,
                savedAddressRoad: _addressRoadController.text,
                savedAddressDetail: _addressDetailController.text,
                savedMemo: _memoController.text,
              )
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _getTotalProductPrice();
    final shippingCost = _getTotalDeliveryPrice();

    int couponDiscount = 0;
    if (_selectedCouponData != null) {
      String couponDiscountStr = _selectedCouponData!.couponDiscount ?? "";
      int couponDiscountValue = _selectedCouponData!.couponPrice ?? 0;
      if (couponDiscountStr.contains("%")) {
        //할인율
        if (couponDiscountValue > 0) {
          double couponDiscountDouble = (couponDiscountValue / 100);
          couponDiscount = (totalAmount * couponDiscountDouble).toInt();
        }
      } else {
        couponDiscount = couponDiscountValue;
      }
    }
    final pointsDiscount = _discountPoint; // 포인트 할인
    final total = totalAmount + shippingCost - couponDiscount - pointsDiscount;

    _totalPrice = total;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: ListView(
                controller: _scrollController,
                children: [
                  ListTileTheme(
                    horizontalTitleGap: 0,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      shape: const Border(
                        top: BorderSide(color: Colors.transparent, width: 0),
                        bottom: BorderSide(color: Colors.transparent, width: 0),
                      ),
                      title: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '주문상품',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                          ),
                          child: PaymentOrderItem(
                            cartList: widget.payOrderDetailData.list ?? [],
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
                  ListTileTheme(
                    horizontalTitleGap: 0,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      shape: const Border(
                        top: BorderSide(color: Colors.transparent, width: 0),
                        bottom: BorderSide(color: Colors.transparent, width: 0),
                      ),
                      title: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                            Visibility(
                              visible: widget.memberType == 1,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isUseAddress = !_isUseAddress;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      height: 22,
                                      width: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                                        border: Border.all(
                                          color: _isUseAddress ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                        ),
                                        color: _isUseAddress ? const Color(0xFFFF6191) : Colors.white,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/images/check01_off.svg', // 체크박스 아이콘
                                        colorFilter: ColorFilter.mode(
                                          _isUseAddress ? Colors.white : const Color(0xFFCCCCCC),
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
                            ),
                          ],
                        ),
                      ),
                      iconColor: Colors.black,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 4),
                                            child: Text(
                                              '수령인',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 13),
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '*',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              color: const Color(0xFFFF6192),
                                              fontSize: Responsive.getFont(context, 13),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: SizedBox(
                                        height: 44,
                                        child: TextField(
                                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                          controller: _recipientNameController,
                                          maxLines: 1,
                                          style: TextStyle(
                                            decorationThickness: 0,
                                            height: 1.2,
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                            hintText: '수령인',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              color: const Color(0xFF595959),
                                            ),
                                            enabledBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 4),
                                            child: Text(
                                              '휴대폰',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 13),
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '*',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              color: const Color(0xFFFF6192),
                                              fontSize: Responsive.getFont(context, 13),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: SizedBox(
                                        height: 44,
                                        child: TextField(
                                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                          controller: _recipientPhoneController,
                                          keyboardType: TextInputType.phone,
                                          maxLines: 1,
                                          style: TextStyle(
                                            decorationThickness: 0,
                                            height: 1.2,
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                            hintText: '‘-’ 없이 번호만 입력',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              color: const Color(0xFF595959),
                                            ),
                                            enabledBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 4),
                                            child: Text(
                                              '주소',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 13),
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '*',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              color: const Color(0xFFFF6192),
                                              fontSize: Responsive.getFont(context, 13),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 7,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _addressSearch();
                                                  },
                                                  child: SizedBox(
                                                    height: 44,
                                                    child: TextField(
                                                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                                      controller: _addressRoadController,
                                                      enabled: false,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        decorationThickness: 0,
                                                        height: 1.2,
                                                        fontFamily: 'Pretendard',
                                                        fontSize: Responsive.getFont(context, 14),
                                                      ),
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.symmetric( horizontal: 15),
                                                        //hintText: '주소를 검색해 주세요.',
                                                        hintStyle: TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: Responsive.getFont(context, 14),
                                                          color: const Color(0xFF595959),
                                                        ),
                                                        border: const OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                                          borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _addressSearch();
                                                  },
                                                  child: Container(
                                                    height: 44,
                                                    margin: const EdgeInsets.only(left: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                                                      border: Border.all(color: const Color(0xFFE1E1E1)),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '주소검색',
                                                        style: TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: Responsive.getFont(context, 14),
                                                          fontWeight: FontWeight.normal,
                                                          height: 1.2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 44,
                                            margin: const EdgeInsets.only(top: 10),
                                            child: TextField(
                                              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                              controller: _addressDetailController,
                                              maxLines: 1,
                                              style: TextStyle(
                                                decorationThickness: 0,
                                                height: 1.2,
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 14),
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                                hintText: '상세주소 입력',
                                                hintStyle: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: Responsive.getFont(context, 14),
                                                  color: const Color(0xFF595959),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                                                ),
                                                focusedBorder: const OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
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
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 20),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TextField(
                                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                  style: TextStyle(
                                    decorationThickness: 0,
                                    height: 1.2,
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                  ),
                                  controller: _memoController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                                    hintText: '배송 메모 입력',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: const Color(0xFF595959),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      borderSide: BorderSide(color: Color(0xFFE1E1E1)),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '결제수단',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      iconColor: Colors.black,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        height: 44,
                                        margin: const EdgeInsets.only(right: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _payType = 1;
                                            });
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: _payType == 1
                                                        ? const Color(0xFFFF6192)
                                                        : const Color(0xFFDDDDDD)),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                    '카드결제',
                                                    style: TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        color: _payType == 1
                                                            ? const Color(0xFFFF6192)
                                                            : Colors.black,
                                                        fontSize: Responsive.getFont(context, 14)),
                                                  ))),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      margin: const EdgeInsets.only(left: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _payType = 2;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(6),
                                            border: Border.all(
                                                color: _payType == 2
                                                    ? const Color(0xFFFF6192)
                                                    : const Color(0xFFDDDDDD)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '휴대폰',
                                              style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  color: _payType == 2
                                                      ? const Color(0xFFFF6192)
                                                      : Colors.black,
                                                  fontSize: Responsive.getFont(context, 14)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 44,
                                margin: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 4),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _payType = 3;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: _payType == 3
                                                          ? const Color(0xFFFF6192)
                                                          : const Color(0xFFDDDDDD)),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                      '계좌이체',
                                                      style: TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          color: _payType == 3
                                                              ? const Color(0xFFFF6192)
                                                              : Colors.black,
                                                          fontSize: Responsive.getFont(context, 14)),
                                                    ))),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        height: 44,
                                        margin: const EdgeInsets.only(left: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _payType = 4;
                                            });
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: _payType == 4 ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '네이버페이',
                                                  style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      color: _payType == 4 ? const Color(0xFFFF6192) : Colors.black,
                                                      fontSize: Responsive.getFont(context, 14)),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.memberType == 1,
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: const Color(0xFFF5F9F9),
                    ),
                  ),
                  Visibility(
                    visible: widget.memberType == 1,
                    child: ListTileTheme(
                      horizontalTitleGap: 0,
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        shape: const Border(
                          top: BorderSide(color: Colors.transparent, width: 0),
                          bottom: BorderSide(color: Colors.transparent, width: 0),
                        ),
                        title: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '할인적용',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        iconColor: Colors.black,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFFEEEEEE),
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '쿠폰',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 13),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      '보유 쿠폰 ${_couponList.length}장',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 13),
                                        color: const Color(0xFF7B7B7B),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_couponList.isNotEmpty) {
                                      CouponData? selectedCoupon = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentCoupon(couponList: _couponList),
                                        ),
                                      );
                                      if (selectedCoupon != null) {
                                        setState(() {
                                          _couponText = "${selectedCoupon.couponDiscount} 할인 적용";
                                          _selectedCouponData = selectedCoupon;
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 44,
                                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                                        border: Border.all(color: const Color(0xFFDDDDDD))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _couponText,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            fontWeight: FontWeight.normal,
                                            height: 1.2,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/images/ic_link.svg',
                                          width: 14,
                                          height: 14,
                                          colorFilter: const ColorFilter.mode(
                                            Color(0xFF7B7B7B),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '포인트 사용',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 13),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      '보유 포인트 ${Utils.getInstance().priceString(_point)}P',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 13),
                                        color: const Color(0xFF7B7B7B),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          height: 44,
                                          margin: const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                                            border: Border.all(color: const Color(0xFFDDDDDD)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            textBaseline: TextBaseline.alphabetic,
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                                  style: TextStyle(
                                                    decorationThickness: 0,
                                                    height: 1.2,
                                                    fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 14),
                                                  ),
                                                  controller: _pointController,
                                                  keyboardType: TextInputType.number,
                                                  // 숫자 입력만 가능하게 설정
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    // 테두리 제거
                                                    hintText: '0',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: Responsive.getFont(context, 14),
                                                      color:
                                                      const Color(0xFF707070),
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.right,
                                                  // 텍스트를 오른쪽 정렬
                                                  onChanged: (text) {
                                                    final value = int.parse(text);
                                                    final maxUsePoint = widget.payOrderDetailData.maxUsePoint ?? 0;
                                                    if (value > maxUsePoint) {
                                                      _pointController.text =
                                                          maxUsePoint.toString();
                                                      _pointCheck(
                                                          maxUsePoint.toString());
                                                    } else {
                                                      _pointCheck(text);
                                                    }
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(right: 15, left: 10),
                                                child: Text(
                                                  'P',
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: Responsive.getFont(context, 14),
                                                    fontWeight: FontWeight.normal,
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          height: 44,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                              border: Border.all(color: const Color(0xFFDDDDDD))),
                                          child: GestureDetector(
                                            onTap: () {
                                              final maxUsePoint = widget.payOrderDetailData.maxUsePoint ?? 0;
                                              if (_point > 0) {
                                                if (_point > maxUsePoint) {
                                                  _pointController.text = maxUsePoint.toString();
                                                  _pointCheck(maxUsePoint.toString());
                                                } else {
                                                  _pointController.text = _point.toString();
                                                  _pointCheck(_point.toString());
                                                }
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                '전액사용',
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: Responsive.getFont(context, 14),
                                                  fontWeight: FontWeight.normal,
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
                          ),
                        ],
                      ),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '결제금액',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      iconColor: Colors.black,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: _buildInfoRow(
                                    '상품 금액',
                                    '${Utils.getInstance().priceString(totalAmount)}원', context),
                              ),
                              _buildInfoRow(
                                  '배송비',
                                  '${Utils.getInstance().priceString(shippingCost)}원', context),
                              Visibility(
                                visible: widget.memberType == 1,
                                child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: _buildInfoRow(
                                        '할인금액',
                                        couponDiscount != 0
                                            ? '- ${Utils.getInstance().priceString(couponDiscount)}원'
                                            : '${Utils.getInstance().priceString(couponDiscount)}원', // 0이 아니면 '-' 추가
                                        context)),
                              ),
                              Visibility(
                                visible: widget.memberType == 1,
                                child: _buildInfoRow(
                                    '포인트할인',
                                    pointsDiscount != 0
                                        ? '- ${Utils.getInstance().priceString(pointsDiscount)}원'
                                        : '${Utils.getInstance().priceString(pointsDiscount)}원', // 0이 아니면 '-' 추가
                                    context),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: const Divider(color: Color(0xFFEEEEEE)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '결제 금액',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      '${Utils.getInstance().priceString(total)}원',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                  Theme(
                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                    child: ListTileTheme(
                      horizontalTitleGap: 0,
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        shape: const Border(
                          top: BorderSide(color: Colors.transparent, width: 0),
                          bottom: BorderSide(color: Colors.transparent, width: 0),
                        ),
                        leading: GestureDetector(
                          onTap: () {
                            setState(() {
                              _allAgree = !_allAgree;
                              _agree1 = _allAgree;
                              _agree2 = _allAgree;
                              _agree3 = _allAgree;
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
                                  color: _allAgree ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                ),
                                color: _allAgree ? const Color(0xFFFF6191) : Colors.white,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/check01_off.svg', // 체크박스 아이콘
                                colorFilter: ColorFilter.mode(
                                  _allAgree ? Colors.white : const Color(0xFFCCCCCC),
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                        iconColor: Colors.black,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFFEEEEEE),
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 7.5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _agree1 = !_agree1;
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
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                                border: Border.all(
                                                  color: _agree1
                                                      ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                                ),
                                                color: _agree1
                                                    ? const Color(0xFFFF6191) : Colors.white,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/images/check01_off.svg',
                                                // 체크박스 아이콘
                                                colorFilter: ColorFilter.mode(
                                                  _agree1
                                                      ? Colors.white
                                                      : const Color(0xFFCCCCCC),
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
                                      child: Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/images/ic_link.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
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
                                            _agree2 = !_agree2;
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
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                                border: Border.all(
                                                  color: _agree2 ? const Color(0xFFFF6191) : const Color(0xFFCCCCCC),
                                                ),
                                                color: _agree2 ? const Color(0xFFFF6191) : Colors.white,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/images/check01_off.svg',
                                                // 체크박스 아이콘
                                                colorFilter: ColorFilter.mode(
                                                  _agree2 ? Colors.white : const Color(0xFFCCCCCC),
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
                                          MaterialPageRoute(builder: (context) => const TermsDetail(type: 0),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/images/ic_link.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
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
                                            _agree3 = !_agree3;
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
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                                border: Border.all(
                                                  color: _agree3
                                                      ? const Color(0xFFFF6191)
                                                      : const Color(0xFFCCCCCC),
                                                ),
                                                color: _agree3
                                                    ? const Color(0xFFFF6191)
                                                    : Colors.white,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/images/check01_off.svg',
                                                // 체크박스 아이콘
                                                colorFilter: ColorFilter.mode(
                                                  _agree3
                                                      ? Colors.white
                                                      : const Color(0xFFCCCCCC),
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
                                                fontSize: Responsive.getFont(
                                                    context, 14),
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
                                      child: Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/images/ic_link.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
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
                  GestureDetector(
                    onTap: () {
                      _payment();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '결제하기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
