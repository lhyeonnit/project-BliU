import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductInfoContent extends StatefulWidget {
  final String content;
  const ProductInfoContent({super.key, required this.content});

  @override
  _ProductInfoContentState createState() => _ProductInfoContentState();
}

class _ProductInfoContentState extends State<ProductInfoContent> with TickerProviderStateMixin {
  bool isExpanded = false;
  late String content;

  @override
  Widget build(BuildContext context) {
    content = widget.content;

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
              child:
              !isExpanded ?
              SizedBox(
                height: 750,
                child: Text(content),
              ) : Text(content),
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
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  isExpanded ? "상품 정보 접기" : "상품 정보 펼쳐보기",
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
