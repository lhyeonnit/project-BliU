import 'package:BliU/data/change_order_detail_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/order_list/view_model/order_item_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderItem extends ConsumerStatefulWidget {
  final OrderData orderData;
  final OrderDetailData orderDetailData;
  final ChangeOrderDetailData? changeOrderDetailData;
  final bool? isList;

  const OrderItem({super.key, required this.orderData, required this.orderDetailData, this.changeOrderDetailData, required this.isList});

  @override
  ConsumerState<OrderItem> createState() => OrderItemState();
}


class OrderItemState extends ConsumerState<OrderItem> {
  late int _ctStatus;
  late String _ptType;

  @override
  void initState() {
    super.initState();
    _ctStatus = widget.orderDetailData.ctStats ?? 0;
    _ptType = widget.orderDetailData.ptType ?? "";
    //_ctStatus = 81; //테스트용
  }

  void _requestOrderComplete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('구매확정'),
        content: const Text('해당 주문을 구매확정 하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소',
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black,
                fontSize: Responsive.getFont(context, 14),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final pref = await SharedPreferencesManager.getInstance();
              final mtIdx = pref.getMtIdx() ?? "";

              Map<String, dynamic> requestData = {
                'type' : mtIdx.isNotEmpty ? 1 : 2,
                'mt_idx' : mtIdx,
                'temp_mt_id' : pref.getToken(),
                'ct_idx' : widget.orderDetailData.ctIdx,
              };

              final defaultResponseDTO = await ref.read(orderItemViewModelProvider.notifier).requestOrder(requestData);
              if (!mounted) return;
              Navigator.pop(context);
              if (defaultResponseDTO != null) {
                if (!mounted) return;
                Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
                if (defaultResponseDTO.result == true) {
                  setState(() {
                    _ctStatus = 8;
                    widget.orderDetailData.reviewWrite = "Y";
                  });
                }
              }
            },
            child: Text('확인',
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black,
                fontSize: Responsive.getFont(context, 14),
              ),
            ),
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

    final reviewDetailResponseDTO = await ref.read(orderItemViewModelProvider.notifier).getDetail(requestData);
    if (reviewDetailResponseDTO != null) {
      if (reviewDetailResponseDTO.result == true) {
        final reviewData = reviewDetailResponseDTO.data;
        if(!mounted) return;
        Navigator.pushNamed(context, '/my_review_edit', arguments: reviewData!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 7),
                child: Text(
                  widget.orderDetailData.ctStatusTxt ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    color: (widget.isList ?? true) ? Colors.black : const Color(0xFFFF6192),
                    fontSize: Responsive.getFont(context, 15),
                  ),
                ),
              ),
              Visibility(
                visible: !(widget.isList ?? true),
                child: Text(
                  widget.changeOrderDetailData?.octCancelMemo2 ?? widget.changeOrderDetailData?.ortReturnMemo2 ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: Colors.black,
                    fontSize: Responsive.getFont(context, 15),
                  ),
                ),
              )
            ],
          ),
        ),
        // 상품 정보
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 이미지
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.orderDetailData.ptImg ?? "",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return SvgPicture.asset(
                        'assets/images/no_imge.svg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
              ),
              // 상품 정보 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.orderDetailData.stName ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: const Color(0xFF7B7B7B)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Text(
                        widget.orderDetailData.ptName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      "${widget.orderDetailData.ctOptValue} ${widget.orderDetailData.ctOptQty}개",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 13),
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "${Utils.getInstance().priceString(widget.orderDetailData.ptPrice ?? 0)}원",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.getFont(context, 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 상태에 따라 버튼 표시
        orderItemButton(),
      ],
    );
  }

  Widget orderItemButton() {
    if (_ptType == "A") {
      return const SizedBox();
    }
    if (_ctStatus == 3) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                final map = {'orderData' : widget.orderData, 'orderDetailData': widget.orderDetailData};
                Navigator.pushNamed(context, '/cancel', arguments: map);
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
                final map = {'qnaType' : '3', 'ptIdx': widget.orderDetailData.ptIdx};
                Navigator.pushNamed(context, '/inquiry_service', arguments: map);
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
                final map = {'orderData' : widget.orderData, 'orderDetailData': widget.orderDetailData};
                Navigator.pushNamed(context, '/exchange_return', arguments: map);
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
                final map = {'odtCode' : widget.orderDetailData.otCode ?? "", 'deliveryType': 1};
                Navigator.pushNamed(context, '/delivery', arguments: map);
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
                final map = {'qnaType' : '3', 'ptIdx': widget.orderDetailData.ptIdx};
                Navigator.pushNamed(context, '/inquiry_service', arguments: map);
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
                    final map = {'orderData' : widget.orderData, 'orderDetailData': widget.orderDetailData};
                    Navigator.pushNamed(context, '/exchange_return', arguments: map);
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
                    final map = {'odtCode' : widget.orderDetailData.otCode ?? "", 'deliveryType': 1};
                    Navigator.pushNamed(context, '/delivery', arguments: map);
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
                    final map = {'qnaType' : '3', 'ptIdx': widget.orderDetailData.ptIdx};
                    Navigator.pushNamed(context, '/inquiry_service', arguments: map);
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
                if (widget.orderDetailData.reviewWrite == "Y") {
                  final rtIdx = widget.orderDetailData.rtIdx ?? 0;
                  if (rtIdx > 0) {
                    // 수정 페이지로
                    _getReviewDetail(widget.orderDetailData.rtIdx ?? 0);
                  } else {
                    Navigator.pushNamed(context, '/review_write', arguments: widget.orderDetailData);
                  }
                } else {
                  Utils.getInstance().showSnackBar(context, "리뷰를 쓸 수 없는 주문입니다.");
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
                final map = {'odtCode' : widget.orderDetailData.otCode ?? "", 'deliveryType': 1};
                Navigator.pushNamed(context, '/delivery', arguments: map);
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
                final map = {'qnaType' : '3', 'ptIdx': widget.orderDetailData.ptIdx};
                Navigator.pushNamed(context, '/inquiry_service', arguments: map);
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
            final map = {'odtCode' : widget.orderDetailData.otCode ?? "", 'deliveryType': 2};
            Navigator.pushNamed(context, '/delivery', arguments: map);
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
