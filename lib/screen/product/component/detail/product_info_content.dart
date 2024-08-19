import 'package:flutter/material.dart';

class ProductInfoContent extends StatefulWidget {
  const ProductInfoContent({super.key});

  @override
  _ProductInfoContentState createState() => _ProductInfoContentState();
}

class _ProductInfoContentState extends State<ProductInfoContent> with TickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // 페이지 전체를 스크롤 가능하게 만듦
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 내용이 들어가는 영역
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/product/item_dt.png'),
                  const SizedBox(height: 16.0),
                  const Text(
                    "밀크마일(MilkMile)은 유아와 어린이를 위한 의류 브랜드로, 높은 품질과 귀여운 디자인으로 많은 부모들의 사랑을 받고 있습니다. 밀크마일은 신생아부터 유아기까지의 아이들을 위한 다양한 의류 제품을 제공하며, 아이들의 편안함과 안전성을 최우선으로 고려한 제품을 제작합니다.",
                  ),
                  const SizedBox(height: 16.0),
                  for (int i = 0; i < 20; i++)
                    const Text("더 많은 설명 내용...", style: TextStyle(fontSize: 16)),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/product/item_dt.png'),
                  const SizedBox(height: 16.0),
                  const Text(
                    "밀크마일(MilkMile)은 유아와 어린이를 위한 의류 브랜드로, 높은 품질과 귀여운 디자인으로 많은 부모들의 사랑을 받고 있습니다.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  isExpanded ? "상품 정보 접기" : "상품 정보 펼쳐보기",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
