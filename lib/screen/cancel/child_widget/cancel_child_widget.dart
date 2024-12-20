import 'package:BliU/data/order_data.dart';
import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CancelChildWidget extends ConsumerStatefulWidget {
  final OrderData? orderData;
  final OrderDetailData? orderDetailData;

  const CancelChildWidget({
    super.key,
    this.orderData,
    required this.orderDetailData,
  });

  @override
  ConsumerState<CancelChildWidget> createState() => CancelChildWidgetState();
}

class CancelChildWidgetState extends ConsumerState<CancelChildWidget> {
  late String cancelReturnReason;
  @override
  void initState() {
    super.initState();
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
                widget.orderData?.ctWdate ?? '',
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
        // 주문 아이템 리스트
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.orderDetailData?.ctStatusTxt ?? "",
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
                        child: CachedNetworkImage(
                          imageUrl: widget.orderDetailData?.ptImg ?? "",
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
                            widget.orderDetailData?.stName ?? "",
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
                              widget.orderDetailData?.ptName ?? "",
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
                            "${widget.orderDetailData?.ctOptValue ?? ""} ${widget.orderDetailData?.ctOptQty}개",
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
                              "${Utils.getInstance().priceString(widget.orderDetailData?.ptPrice ?? 0)}원",
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
