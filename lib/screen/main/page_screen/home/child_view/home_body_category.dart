import 'package:BliU/data/category_data.dart';
import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/product/product_list_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBodyCategory extends ConsumerWidget {
  final List<CategoryData> categories;
  const HomeBodyCategory({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CategoryData> list = [
      CategoryData(ctIdx: 0, cstIdx: 0, img: null, ctName: "스토어", catIdx: 0, catName: '', subList: null)
    ];
    for (var category in categories) {
      list.add(category);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 25),
      child: Container(
        height: 110,
        padding: const EdgeInsets.only(left: 16),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            final category = list[index];

            return InkWell(
              overlayColor: WidgetStateColor.transparent,
              onTap: () {
                if (index == 0) {
                  ref.read(mainScreenProvider.notifier).selectNavigation(0);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListScreen(selectedCategory: category)),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  children: [
                    index == 0
                        ? Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black, // 테두리 색상
                          width: 1.0, // 테두리 두께
                        ),
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          'assets/images/home/cate_ic_store.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEFEFEF), // 테두리 색상
                          width: 1.0,
                        ),
                      ),
                      child: SvgPicture.network(
                        category.img ?? "",
                        width: Responsive.getWidth(context, 70.0),
                        height: Responsive.getHeight(context, 70.0),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        category.ctName ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Colors.black,
                          fontSize: Responsive.getFont(context, 14),
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
