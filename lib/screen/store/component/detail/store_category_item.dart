import 'package:BliU/screen/store/viewmodel/store_category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/data/dto/store_favorite_product_data.dart'; // ProductDTO 클래스가 있는 파일

class StoreCategoryItem extends ConsumerWidget {


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(storeCategoryViewModelProvider);

    if (model == null || model.productDetail == null) {
      return Center(child: CircularProgressIndicator()); // 로딩 중일 때 처리
    }

    return Container(
          width: Responsive.getWidth(context, 184),
          child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            childAspectRatio: 0.55,
          ),
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.productDetail!.length,
          itemBuilder: (context, index) {
            if (index >= model.productDetail!.length) {
              return Center(
                  child: CircularProgressIndicator()); // 추가 로딩 시 로딩 인디케이터
            }

            final ProductDTO product = model.productDetail![index];

            return GestureDetector(
              onTap: () {
                // 상품 클릭 시 상세 화면 이동 처리
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.network(
                            product.ptImg,
                            fit: BoxFit.contain,
                            height: Responsive.getHeight(context, 184),
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/images/home/exhi.png'),
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
                    SizedBox(height: 12),
                    Text(
                      product.stName,
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 12),
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.ptName,
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 14),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height:12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${product.ptDiscountPer}%',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFFFF6192),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2),
                        Text(
                          '${product.ptPrice}원',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/home/item_like.svg',
                          width: Responsive.getWidth(context, 13),
                          height: Responsive.getHeight(context, 11),
                        ),
                        SizedBox(width: 3),
                        Text(
                          '${product.ptLike}',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 12),
                            color: Colors.grey,
                          ),
                        ),
                        if (product.ptReviewCount > 0) ...[
                          SizedBox(width: 10),
                          SvgPicture.asset(
                            'assets/images/home/item_comment.svg',
                            width: Responsive.getWidth(context, 13),
                            height: Responsive.getHeight(context, 12),
                          ),
                          SizedBox(width: 3),
                          Text(
                            '${product.ptReviewCount}',
                            style: TextStyle(
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
    );
  }
}
