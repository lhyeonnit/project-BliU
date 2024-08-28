import 'package:BliU/screen/store/viewmodel/store_category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/data/dto/store_favorite_product_data.dart'; // ProductDTO 클래스가 있는 파일

class StoreCategoryItem extends ConsumerWidget {
  final int tabIndex;

  StoreCategoryItem({required this.tabIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeCategoryViewModelProvider);
    final viewModel = ref.read(storeCategoryViewModelProvider.notifier);

    if (state == null || state.productDetail == null) {
      return Center(child: CircularProgressIndicator()); // 로딩 중일 때 처리
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
          viewModel.loadMore(
            tabIndex: tabIndex,
            mtIdx: 2, // 예시값
          );
        }
        return true;
      },
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 30.0,
          childAspectRatio: 0.8,
        ),
        itemCount: state.productDetail!.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.productDetail!.length) {
            return Center(child: CircularProgressIndicator()); // 추가 로딩 시 로딩 인디케이터
          }

          final ProductDTO product = state.productDetail![index];

          return GestureDetector(
            onTap: () {
              // 상품 클릭 시 상세 화면 이동 처리
            },
            child: Container(
              height: 301,
              width: Responsive.getWidth(context, 184),
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
                          height: Responsive.getHeight(context, 200),
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/home/exhi.png'),
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
                  SizedBox(height: Responsive.getHeight(context, 12)),
                  Text(
                    product.ptName,
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 14),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Responsive.getHeight(context, 12)),
                  Row(
                    children: [
                      Text(
                        '${product.ptDiscountPer}%',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Color(0xFFFF6192),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: Responsive.getWidth(context, 2)),
                      Text(
                        '${product.ptSellingPrice}원',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
