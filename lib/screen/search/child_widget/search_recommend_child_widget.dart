import 'package:BliU/screen/main/page_screen/home/view_model/home_body_ai_view_model.dart';
import 'package:BliU/screen/product_list/item/product_list_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchRecommendChildWidget extends ConsumerWidget {
  const SearchRecommendChildWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.read(homeBodyAiViewModelProvider);
        final productList = model.productListResponseDTO?.list ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40, left: 16),
              child: Text(
                '이런 아이템은 어떠세요?',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 18),
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: productList.length, // 리스트의 길이를 사용
                  itemBuilder: (context, index) {
                    final productData = productList[index];
                    return Container(
                      margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                      padding: const EdgeInsets.only(right: 12),
                      width: 160,
                      child: ProductListItem(productData: productData, bottomVisible: false),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
