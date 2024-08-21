import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/store/component/detail/store_category_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/widget/product_item_widget.dart';
import 'package:BliU/widget/top_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../_component/search_screen.dart';

//기획전
class ExhibitionScreen extends StatefulWidget {
  const ExhibitionScreen({super.key});

  @override
  State<StatefulWidget> createState() => ExhibitionScreenState();
}

class ExhibitionScreenState extends State<ExhibitionScreen>
    with TopWidgetDelegate {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: Text("우리 아이를 위한 포근한 선택"),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: BoxDecoration(
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
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/exhibition/ic_top_sch.svg"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/images/exhibition/ic_cart.svg"),
                onPressed: () {
                  // 장바구니 버튼 동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 28,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6191),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: Responsive.getWidth(context, 15),
                    minHeight: Responsive.getHeight(context, 14),
                  ),
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.getFont(context, 9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 620,
              width: Responsive.getWidth(context, 412),
              child: Image.asset(
                "assets/images/exhibition/exhibition_img.png",
                width: Responsive.getWidth(context, 412),
                height: 620,
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: Responsive.getHeight(context, 10)),
              child: Text(
                '우리 아이를 위한 포근한 선택',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.getFont(context, 20)),
              ),
            ),
            Container(
              child: Text(
                '집에서도 스타일리시하게!\n우리 아이를 위한 홈웨어 컬렉션.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF7B7B7B)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: GridView.builder(
                shrinkWrap: true,
                // 리스트 자식 높이 크기의 합 만큼으로 영역 고정
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.6),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return StoreCategoryItem();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
