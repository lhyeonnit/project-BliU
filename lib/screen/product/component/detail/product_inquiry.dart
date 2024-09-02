import 'package:flutter/material.dart';

class ProductInquiry extends StatefulWidget {
  const ProductInquiry({super.key});

  @override
  _ProductInquiryState createState() => _ProductInquiryState();
}

class _ProductInquiryState extends State<ProductInquiry> {
  int currentPage = 1;
  int totalPages = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text(
            '상품문의',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true, // 리스트가 다른 스크롤뷰 내에 있으므로 높이 제한
          physics: const NeverScrollableScrollPhysics(), // 부모 스크롤에 따라 스크롤
          itemCount: 4, // 페이지당 문의 개수
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        index % 2 == 0 ? '답변완료' : '미답변',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const Text('jw**********   2024.04.14', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.lock, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          index % 2 == 0 ? '비밀글입니다.' : '안녕하세요 배송언제되나요?',
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: currentPage > 1
                    ? () {
                  setState(() {
                    currentPage--;
                  });
                }
                    : null,
              ),
              Text(
                '${currentPage.toString().padLeft(2, '0')} / $totalPages',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: currentPage < totalPages
                    ? () {
                  setState(() {
                    currentPage++;
                  });
                }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
