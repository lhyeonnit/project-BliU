import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/store_data.dart';
import 'package:BliU/screen/product/coupon_receive_screen.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductInfoTitle extends StatefulWidget {
  final StoreData? storeData;
  final ProductData? productData;

  const ProductInfoTitle(
      {super.key, required this.storeData, required this.productData});

  @override
  _ProductInfoTitleState createState() => _ProductInfoTitleState();
}

class _ProductInfoTitleState extends State<ProductInfoTitle> {
  bool _isDeliveryInfoVisible = false;

  void _toggleDeliveryInfo() {
    setState(() {
      _isDeliveryInfoVisible = !_isDeliveryInfoVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 로고 버튼
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StoreDetailScreen()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 9, right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFDDDDDD)),
                      shape: BoxShape.circle, // 이미지를 동그랗게 만들기
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.storeData?.stProfile ?? "",
                          ),
                          fit: BoxFit.cover)),
                ),
              ),
              // 나머지 텍스트와 공유 버튼을 포함한 컬럼
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 첫 번째 줄: 브랜드명, 공유 버튼
                    Row(
                      children: [
                        // 브랜드명 및 화살표 버튼
                        GestureDetector(
                          onTap: () {
                            // 브랜드명 버튼 동작
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const StoreDetailScreen()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                widget.storeData?.stName ?? "", // 브랜드명
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: Color(0xFF7B7B7B),
                                  fontSize: Responsive.getFont(context, 13),
                                  height: 1.2,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: SvgPicture.asset(
                                      'assets/images/product/ic_more_arrow.svg')),
                            ],
                          ),
                        ),
                        const Spacer(), // 공간을 채워서 오른쪽 정렬
                        // 공유 버튼
                        GestureDetector(
                          child: SvgPicture.asset(
                              'assets/images/product/ic_share.svg'),
                          onTap: () {
                            // TODO 공유 버튼 동작
                          },
                        ),
                      ],
                    ),
                    // 상품 제목
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 12),
                      child: Text(
                        widget.productData?.ptName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 16),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    // 가격 정보
                    Row(
                      children: [
                        (widget.productData?.ptDiscountPer ?? 0) > 0
                            ? Row(
                                children: [
                                  Text(
                                    "${widget.productData?.ptDiscountPer ?? 0}%",
                                    // 할인률
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 18),
                                      color: Color(0xFFFF6192),
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Container(
                          margin: EdgeInsets.only(left: 8, right: 5),
                          child: Text(
                            '${Utils.getInstance().priceString(widget.productData?.ptPrice ?? 0)}원', // 할인된 가격
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          '${Utils.getInstance().priceString(widget.productData?.ptSellingPrice ?? 0)}원', // 원래 가격
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFFABABAB),
                            decoration: TextDecoration.lineThrough, // 취소선
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 구분선
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFEEEEEE), width: 1),
            ),
          ),
          // 배송비 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleDeliveryInfo,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        child: Text(
                          '배송비', // 배송비 텍스트
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              '${Utils.getInstance().priceString(widget.productData?.deliveryInfo?.deliveryDetail?.deliveryBasicPrice ?? 0)}원 (${Utils.getInstance().priceString(widget.productData?.deliveryInfo?.deliveryDetail?.deliveryMinPrice ?? 0)}원 이상 ${(widget.productData?.deliveryInfo?.deliveryPrice ?? 0) == 0 ? '무료배송)' : '${Utils.getInstance().priceString((widget.productData?.deliveryInfo?.deliveryPrice ?? 0))}원)'}', // 배송비 정보
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: SvgPicture.asset(
                                  'assets/images/product/ic_more_arrow.svg',
                                  color: Color(0xFF7B7B7B),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // TODO 배송비 정보
                Visibility(
                  visible: _isDeliveryInfoVisible,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFDDDDDD)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '택배사: CJ대한통운',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 12),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '배송비: 기본 배송비 0000원 / 50,000원 이상 무료',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 10),
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '도서산간 추가배송비: 3000원',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 10),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              '제주 추가배송비: 3000원',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 10),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          '배송 기간: 평균 2-5일 이내 발송 (영업일 기준), 재고현황에 따라 배송이 다소 지연될 수 있습니다.',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 10),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 40),
                        child: Text(
                          '쿠폰',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CouponReceiveScreen(
                                ptIdx: widget.productData?.ptIdx,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFDDDDDD)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 8),
                            child: Text(
                              '쿠폰 다운로드',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
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
          ),
        ],
      ),
    );
  }
}
