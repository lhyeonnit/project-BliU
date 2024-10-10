import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/product/viewmodel/product_list_card_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListCard extends ConsumerStatefulWidget {
  final ProductData productData;
  final bool? bottomVisible;
  const ProductListCard({super.key, required this.productData, this.bottomVisible});

  @override
  ConsumerState<ProductListCard> createState() => _ProductListCardState();
}

class _ProductListCardState extends ConsumerState<ProductListCard> {
  late ProductData productData;
  @override
  void initState() {
    super.initState();

    productData = widget.productData;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(ptIdx: productData.ptIdx),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: Image.network(
                      productData.ptImg ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return const SizedBox();
                      }
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {

                      final pref = await SharedPreferencesManager.getInstance();
                      final mtIdx = pref.getMtIdx() ?? "";
                      if (mtIdx.isNotEmpty) {
                        final item = productData;
                        final likeChk = item.likeChk;

                        Map<String, dynamic> requestData = {
                          'mt_idx' : mtIdx,
                          'pt_idx' : item.ptIdx,
                        };

                        final defaultResponseDTO = await ref.read(productListCardViewModelProvider.notifier).productLike(requestData);
                        if(defaultResponseDTO != null) {
                          if (defaultResponseDTO.result == true) {
                            setState(() {
                              if (likeChk == "Y") {
                                productData.likeChk = "N";
                              } else {
                                productData.likeChk = "Y";
                              }
                            });
                          }
                        }
                      }
                    },
                    child: Image.asset(
                      productData.likeChk == "Y" ? 'assets/images/home/like_btn_fill.png' : 'assets/images/home/like_btn.png',
                      height: Responsive.getHeight(context, 34),
                      width: Responsive.getWidth(context, 34),
                      // 하트 내부를 채울 때만 색상 채우기, 채워지지 않은 상태는 투명 처리
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    productData.stName ?? "",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 12),
                      color: Colors.grey,
                      height: 1.2,
                    ),
                  ),
                ),
                Text(
                  productData.ptName ?? "",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${productData.ptDiscountPer ?? 0}%',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFFFF6192),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          "${Utils.getInstance().priceString(productData.ptPrice ?? 0)}원",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.bottomVisible ?? true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/item_like.svg',
                        width: Responsive.getWidth(context, 13),
                        height: Responsive.getHeight(context, 11),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 2, bottom: 2),
                        child: Text(
                          '${productData.ptLike ?? ""}',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 12),
                            color: Colors.grey,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (productData.ptReview ?? 0) == 0 ? false : true,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/home/item_comment.svg',
                                width: Responsive.getWidth(context, 13),
                                height: Responsive.getHeight(context, 12),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 2, bottom: 2),
                                child: Text(
                                  '${productData.ptReview ?? ""}',
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
              ],
            ),
            Visibility(
              visible: true,// TODO 오늘출발 수정 필요
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/images/product/ic_today_start.png',
                  width: 65,
                  height: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
