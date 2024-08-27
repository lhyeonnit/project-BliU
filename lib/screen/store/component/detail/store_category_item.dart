import 'package:BliU/screen/store/viewmodel/store_category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:BliU/utils/responsive.dart';


class StoreCategoryItem extends ConsumerWidget {
  final int tabIndex;

  StoreCategoryItem({required this.tabIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeCategoryViewModelProvider)[tabIndex];
    final viewModel = ref.read(storeCategoryViewModelProvider.notifier);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          viewModel.loadMore(tabIndex);
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
        itemCount: state.products.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final product = state.products[index];
          return GestureDetector(
            onTap: () {
              // 상품 클릭 시 이동 처리 등
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
                        child: Image.asset(
                          'assets/images/home/exhi.png',
                          fit: BoxFit.contain,
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
                  SizedBox(
                    height: Responsive.getHeight(context, 12),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상품명 $product',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Responsive.getHeight(context, 12)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '15%',
                            style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Color(0xFFFF6192),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: Responsive.getWidth(context, 2)),
                          Text(
                            '32,800원',
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
