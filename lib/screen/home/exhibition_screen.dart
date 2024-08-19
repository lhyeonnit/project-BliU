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

class ExhibitionScreenState extends State<ExhibitionScreen> with TopWidgetDelegate {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);  // 뒤로가기 동작
          },
        ),
        title: Text("우리 아이를 위한 포근한 선택"),
        backgroundColor: Colors.white,
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
                },
              ),
              Positioned(
                right: 8,
                top: 28,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 620,
                      child: Image.asset("assets/images/exhibition/exhibition_img.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: const Text(
                        '우리 아이를 위한 포근한 선택',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: const Text(
                        '집에서도 스타일리시하게!\n우리 아이를 위한 홈웨어 컬렉션.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7B7B7B)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                      child: GridView.builder(
                        shrinkWrap: true, // 리스트 자식 높이 크기의 합 만큼으로 영역 고정
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //1 개의 한 행에 보여줄 개수
                          childAspectRatio: 1 / 2, //item 의 가로, 세로 비율
                          mainAxisSpacing: 30, //수평 Padding
                          crossAxisSpacing: 12, //수직 Padding
                        ),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductItemWidget();
                        },
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}