import 'package:BliU/data/cancel_detail_data.dart';
import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelItem extends ConsumerStatefulWidget {
  final OrderData? orderData;
  final CancelDetailData? cancelDetailData;
  final OrderDetailData? orderDetailData;

  const CancelItem({
    super.key,
    this.orderData,
    this.cancelDetailData,
    required this.orderDetailData,
  });

  @override
  ConsumerState<CancelItem> createState() => CancelItemState();
}

class CancelItemState extends ConsumerState<CancelItem> {
  late String cancelReturnReason;
  @override
  void initState() {
    super.initState();
    cancelReturnReason = widget.cancelDetailData?.octCancelMemo2 ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                widget.orderData?.ctWdate ?? widget.cancelDetailData?.ctWdate ?? '',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.getFont(context, 16),
                  height: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.orderDetailData?.otCode ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: const Color(0xFF7B7B7B),
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: cancelReturnReason.isNotEmpty,
            child: Row(
              children: [
                Text(
                    "취소반려",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    height: 1.2,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      widget.cancelDetailData?.octCancelMemo2 ?? '',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: const Color(0xFFFF6192),
                        height: 1.2,
                      ),
                    ),
                ),
              ],
            ),
        ),
        // 주문 아이템 리스트
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.orderDetailData?.ctStatusTxt ?? widget.cancelDetailData?.ctStatusTxt ?? "",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: Responsive.getFont(context, 15),
                  height: 1.2,
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
                        child: Image.network(
                          widget.orderDetailData?.ptImg ?? widget.cancelDetailData?.product?.ptImg ?? "",
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          }
                        ),
                      ),
                    ),
                    // 상품 정보 텍스트
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.orderDetailData?.stName ?? widget.cancelDetailData?.product?.stName ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 12),
                              color: const Color(0xFF7B7B7B),
                              height: 1.2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 10),
                            child: Text(
                              widget.orderDetailData?.ptName ?? widget.cancelDetailData?.product?.ptName ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Text(
                            "${widget.orderDetailData?.ctOptValue ?? widget.cancelDetailData?.product?.ctOptValue ?? ""} ${widget.orderDetailData?.ctOptQty ?? widget.cancelDetailData?.product?.ctOptQty}개",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 13),
                              color: const Color(0xFF7B7B7B),
                              height: 1.2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              // '${order['price']}원',
                              "${Utils.getInstance().priceString(widget.orderDetailData?.ptPrice ?? widget.cancelDetailData?.product?.ptPrice ?? 0)}원",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.getFont(context, 14),
                                height: 1.2,
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
      ],
    );
  }
}
