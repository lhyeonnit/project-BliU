import 'package:BliU/screen/category/viewmodel/category_view_model.dart';
import 'package:BliU/screen/product/product_list_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> requestData = {
      'category_type' : '2'
    };
    ref.read(categoryModelProvider.notifier).getCategory(requestData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 기본 뒤로가기 버튼을 숨김
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('카테고리'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final model = ref.watch(categoryModelProvider);
          final categories = model?.categoryResponseDTO?.list ?? [];

          return Row(
            children: [
              // 왼쪽 상위 카테고리 목록
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final categoryData = categories[index];

                    return ListTile(
                      title: Text(categoryData.ctName ?? ""),
                      onTap: () {
                        // 왼쪽 상위 카테고리 클릭 시 동작할 코드 (필요한 경우 추가)
                      },
                    );
                  },
                ),
              ),
              // 오른쪽 모든 상위 + 하위 카테고리 목록을 나열
              Expanded(
                child: ListView(
                  children: categories.map((category) {
                    final subCategories = category.subList ?? [];
                    print("test11 ===> ${subCategories.length}");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상위 카테고리 제목과 이미지
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              SvgPicture.network(
                                category.img ?? "",
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                category.ctName ?? "",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 하위 카테고리 목록
                        ...subCategories
                            .map((subCategory) => ListTile(
                            title: Text(subCategory.ctName ?? ""),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                            // 하위 카테고리 선택 시 처리
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductListScreen(selectedCategory: subCategory,),
                              ),
                            );
                            },
                          )
                        ),
                        const Divider(), // 상위 카테고리 구분을 위한 구분선
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
