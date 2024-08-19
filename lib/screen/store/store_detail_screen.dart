import 'package:BliU/screen/store/component/detail/store_category.dart';
import 'package:BliU/screen/store/component/detail/store_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: StoreInfoPage(), // 상단 고정된 컨텐츠
            ),
          ];
        },
        body: StoreCategory(), // 내부 스크롤 가능한 카테고리 및 그리드뷰
      ),
    );
  }
}
