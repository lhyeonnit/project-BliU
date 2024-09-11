import 'package:BliU/screen/home/viewmodel/home_body_category_view_model.dart';
import 'package:BliU/screen/product/product_list_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBodyCategory extends ConsumerWidget {
  const HomeBodyCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Map<String, dynamic> requestData
    // ref.read(homeBodyCategoryModelProvider.notifier).getCategory(requestData)

    return Padding(
      padding: EdgeInsets.only(top: Responsive.getHeight(context, 30.0)),
      child: Container(
        height: Responsive.getHeight(context, 115.0),
        padding: const EdgeInsets.only(left: 16),
        child: Consumer(
          builder: (context, ref, widget){
            return Scaffold();
            // return ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   itemCount: categories.length,
            //   itemBuilder: (context, index) {
            //     final category = categories[index];
            //     final isSpecialCategory = category['icon'] == 'assets/images/home/cate_ic_store.svg';
            //     return InkWell(
            //       onTap: () {
            //         // 모든 카테고리 아이콘을 눌렀을 때 같은 페이지로 이동
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => const ProductListScreen()),
            //         );
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 12.0),
            //         child: Column(
            //           children: [
            //             isSpecialCategory
            //                 ? Container(
            //               width: 70.0,
            //               height: 70.0,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 border: Border.all(
            //                   color: Colors.black, // 테두리 색상
            //                   width: 1.0, // 테두리 두께
            //                 ),
            //               ),
            //               child: ClipOval(
            //                 child: SvgPicture.asset(
            //                   category['icon']!,
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             )
            //                 : Container(
            //               width: 70.0,
            //               height: 70.0,
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 shape: BoxShape.circle,
            //                 border: Border.all(
            //                   color: const Color(0xFFEFEFEF), // 테두리 색상
            //                   width: 1.0,
            //                 ),
            //               ),
            //               child: SvgPicture.asset(
            //                 category['icon']!,
            //                 width: Responsive.getWidth(context, 70.0),
            //                 height: Responsive.getHeight(context, 70.0),
            //                 fit: BoxFit.contain,
            //               ),
            //             ),
            //             const SizedBox(height: 10),
            //             Container(
            //               alignment: Alignment.topCenter,
            //               width: Responsive.getWidth(context, 70.0),
            //               height: Responsive.getHeight(context, 35.0),
            //               child: Text(
            //                 category['name']!,
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                     color: Colors.black,
            //                     fontSize: Responsive.getFont(context, 14)),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // );
          }
        ),
      ),
    );
  }
}
