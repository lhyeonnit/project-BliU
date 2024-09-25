import 'package:BliU/screen/store/component/detail/store_category_item.dart';
import 'package:BliU/screen/store/component/detail/store_group_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../viewmodel/store_category_view_model.dart';

class StoreCategory extends HookConsumerWidget {
  const StoreCategory({super.key});

  final List<String> categories = const [
    '전체',
    '아우터',
    '상의',
    '하의',
    '원피스',
    '슈즈',
    '세트/한벌옷',
    '언더웨어/홈웨어',
    '악세서리',
    '베이비 잡화'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(
        initialLength: categories.length); // useTabController 사용
    final model =
        ref.watch(storeCategoryViewModelProvider); // ViewModel 상태 가져오기

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TabBar(
            controller: tabController,
            labelStyle: TextStyle( fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              fontWeight: FontWeight.w600,
            ),
            overlayColor: WidgetStateColor.transparent,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            dividerColor: Color(0xFFDDDDDD),
            unselectedLabelColor: const Color(0xFF7B7B7B),
            isScrollable: true,
            indicatorWeight: 2.0,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tabs: categories.map((category) {
              return Tab(text: category);
            }).toList(),
          ),
        ),
        StoreGroupSelection(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            '상품 ${model?.productList?.length ?? 0}', // 상품 개수 텍스트
            style: TextStyle( fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14), color: Colors.black),
          ),
        ),
        const SizedBox(height: 20,),
        Container(
          // 기본 세로 길이를 301로 설정하고, 상품이 더 있으면 301씩 추가
          height: (model?.productList?.length ?? 0) > 0
              ? 365 * ((model!.productList!.length + 1) ~/ 2).toDouble()
              : 0.0,
          child: TabBarView(
            controller: tabController,
            children: List.generate(
              categories.length,
                  (index) {
                // 상품 리스트
                return StoreCategoryItem();
              },
            ),
          ),
        ),
      ],
    );
  }
}
