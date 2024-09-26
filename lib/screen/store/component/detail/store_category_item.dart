import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/dto/store_response_dto.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:BliU/utils/responsive.dart';

class StoreCategoryItem extends ConsumerStatefulWidget {
  final int index;

  StoreCategoryItem({super.key, required this.index});

  @override
  _StoreCategoryItemState createState() => _StoreCategoryItemState();
}

class _StoreCategoryItemState extends ConsumerState<StoreCategoryItem>
    with TickerProviderStateMixin {
  List<ProductData> pList = [];
  int count = 0;
  StoreResponseDTO? storeData;

  @override
  Widget build(BuildContext context) {
    try {
      pList = storeData?.data.list ?? [];
      count = storeData?.data.list!.length ?? 0;
    } catch (e) {
      print("e = ${e.toString()}");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            '상품 ${count}', // 상품 개수 텍스트
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                color: Colors.black),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            childAspectRatio: 0.55,
            mainAxisSpacing: 10,
          ),
          physics: const NeverScrollableScrollPhysics(),
          //itemCount: model.productList!.length,
          itemCount: count,
          itemBuilder: (context, index) {
            final storeProduct = pList[index];
            if (index >= count) {
              return const Center(
                  child: CircularProgressIndicator()); // 추가 로딩 시 로딩 인디케이터
            }
            return GestureDetector(
              onTap: () {
                // 상품 클릭 시 상세 화면 이동 처리
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ProductDetailScreen(ptIdx: 3),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(5)),
                        child: Container(
                          width: 184,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              storeProduct.ptImg ?? "",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      'assets/images/home/exhi.png'),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          'assets/images/home/like_btn.svg',
                          height: Responsive.getHeight(context, 34),
                          width: Responsive.getWidth(context, 34),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 3),
                    child: Text(
                      storeProduct.stName ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                  ),
                  Text(
                    storeProduct.ptName ?? "",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${storeProduct.ptDiscountPer}%',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: const Color(0xFFFF6192),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3),
                          child: Text(
                            '${storeProduct.ptPrice}원',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/item_like.svg',
                        width: Responsive.getWidth(context, 13),
                        height: Responsive.getHeight(context, 11),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${storeProduct.ptLike}',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 12),
                          color: Colors.grey,
                        ),
                      ),
                      if ((storeProduct.ptReviewCount ?? 0) > 0) ...[
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/images/home/item_comment.svg',
                          width: Responsive.getWidth(context, 13),
                          height: Responsive.getHeight(context, 12),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${storeProduct.ptReviewCount}',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 12),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
