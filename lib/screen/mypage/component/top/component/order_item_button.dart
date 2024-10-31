import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/mypage/component/bottom/component/inquiry_service.dart';
import 'package:BliU/screen/mypage/component/top/cancel_screen.dart';
import 'package:BliU/screen/mypage/component/top/component/my_review_edit.dart';
import 'package:BliU/screen/mypage/component/top/delivery_screen.dart';
import 'package:BliU/screen/mypage/component/top/exchange_return_screen.dart';
import 'package:BliU/screen/review_write/review_write_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/order_item_button_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItemButton extends ConsumerStatefulWidget {
  final OrderData orderData;
  final OrderDetailData orderDetailData;

  const OrderItemButton({super.key, required this.orderData, required this.orderDetailData});

  @override
  ConsumerState<OrderItemButton> createState() => OrderItemButtonState();
}

class OrderItemButtonState extends ConsumerState<OrderItemButton> {
  late OrderData _orderData;
  late OrderDetailData _orderDetailData;
  late int _ctStatus;

  @override
  void initState() {
    super.initState();
    _orderData = widget.orderData;
    _orderDetailData = widget.orderDetailData;
    _ctStatus = _orderDetailData.ctStats ?? 0;
    //_ctStatus = 81; //테스트용
  }

  void _requestOrderComplete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('구매확정'),
        content: const Text('해당 주문을 구매확정 하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final pref = await SharedPreferencesManager.getInstance();
              final mtIdx = pref.getMtIdx() ?? "";

              Map<String, dynamic> requestData = {
                'type' : mtIdx.isNotEmpty ? 1 : 2,
                'mt_idx' : mtIdx,
                'temp_mt_id' : pref.getToken(),
                'ct_idx' : _orderDetailData.ctIdx,
              };

              final defaultResponseDTO = await ref.read(orderItemButtonViewModelProvider.notifier).requestOrder(requestData);
              if (defaultResponseDTO != null) {
                if (!mounted) return;
                Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
                if (defaultResponseDTO.result == true) {
                  Navigator.pop(context);
                  setState(() {
                    _ctStatus = 8;
                  });
                }
              }
            },
            child: const Text('확인'),
          )
        ],
      ),
    );
  }

  void _getReviewDetail(int rtIdx) async {
    final pref = await SharedPreferencesManager.getInstance();

    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'rt_idx': rtIdx,
    };

    final reviewDetailResponseDTO = await ref.read(orderItemButtonViewModelProvider.notifier).getDetail(requestData);
    if (reviewDetailResponseDTO != null) {
      if (reviewDetailResponseDTO.result == true) {
        final reviewData = reviewDetailResponseDTO.data;
        if(!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyReviewEdit(reviewData: reviewData!,)
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_ctStatus == 3) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CancelScreen(orderData: _orderData, orderDetailData: _orderDetailData),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '취소하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InquiryService(qnaType: '3', ptIdx: _orderDetailData.ptIdx),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '문의하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_ctStatus == 5) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExchangeReturnScreen(orderData: _orderData, orderDetailData: _orderDetailData),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '교환/반품 요청',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryScreen(odtCode: _orderDetailData.otCode ?? "", deliveryType: 1,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '배송조회',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InquiryService(qnaType: '3', ptIdx: _orderDetailData.ptIdx),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '문의하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_ctStatus == 7) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                _requestOrderComplete();
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6192)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '구매확정',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: const Color(0xFFFF6192),
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExchangeReturnScreen(orderData: _orderData, orderDetailData: _orderDetailData),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '교환/반품 요청',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryScreen(odtCode: _orderDetailData.otCode ?? "", deliveryType: 1,),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '배송조회',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InquiryService(qnaType: '3', ptIdx: _orderDetailData.ptIdx,),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '문의하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                      fontSize: Responsive.getFont(context, 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (_ctStatus == 8) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                if (_orderDetailData.reviewWrite == "N") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewWriteScreen(orderDetailData: _orderDetailData),
                    ),
                  );
                } else {
                  // 수정 페이지로
                  _getReviewDetail(_orderDetailData.rtIdx ?? 0);
                }
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6192)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '리뷰쓰기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: const Color(0xFFFF6192),
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryScreen(odtCode: _orderDetailData.otCode ?? "", deliveryType: 1,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '배송조회',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InquiryService(qnaType: '3', ptIdx: _orderDetailData.ptIdx,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDDDDDD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '문의하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 14),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_ctStatus == 81 || _ctStatus == 82) {
      return SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliveryScreen(odtCode: _orderDetailData.otCode ?? "", deliveryType: 2,),
              ),
            );
          },
          style: TextButton.styleFrom(
            side: const BorderSide(color: Color(0xFFDDDDDD)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            backgroundColor: Colors.white,
          ),
          child: Text(
            '배송조회',
            style: TextStyle(
              fontFamily: 'Pretendard',
              color: Colors.black,
              fontSize: Responsive.getFont(context, 14),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
