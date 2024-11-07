import 'package:BliU/screen/main/page_screen/home/view_model/home_body_ai_view_model.dart';
import 'package:BliU/screen/product_list/item/product_list_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBodyAiChildWidget extends ConsumerWidget {
  const HomeBodyAiChildWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homeBodyAiViewModelProvider);
    final productList = model.productListResponseDTO?.list ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Text(
            'AI 추천 상품',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        Container(
          height: 310,
          margin: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: productList.length, // 리스트의 길이를 사용
            itemBuilder: (context, index) {
              final productData = productList[index];
              return Container(
                width: 160,
                margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                padding: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ProductListItem(productData: productData),
              );
            },
          ),
        ),
      ],
    );
  }
}