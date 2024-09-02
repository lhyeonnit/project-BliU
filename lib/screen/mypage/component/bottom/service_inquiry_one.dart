import 'package:flutter/material.dart';

import 'inquiry_one_detail.dart';

class ServiceInquiryOne extends StatefulWidget {
  const ServiceInquiryOne({super.key});

  @override
  _ServiceInquiryOneState createState() => _ServiceInquiryOneState();
}

class _ServiceInquiryOneState extends State<ServiceInquiryOne> {
  int currentPage = 1;
  final int itemsPerPage = 5; // 한 페이지에 보여줄 항목 수

  final List<Map<String, String>> inquiry = [
    {'title': '비밀글입니다.', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '비밀글입니다', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '안녕하세요 배송언제되나요?', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '비밀글입니다', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '추가 항목1', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '추가 항목2', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '추가 항목2', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '추가 항목2', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '추가 항목2', 'date': '2023-01-01', 'state': '답변완료'},
    {'title': '추가 항목2', 'date': '2023-01-01', 'state': '답변완료'},
  ];

  @override
  Widget build(BuildContext context) {
    // 페이지 수 계산
    int totalPages = (inquiry.length / itemsPerPage).ceil();

    // 현재 페이지에 표시할 항목들 계산
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage > inquiry.length)
        ? inquiry.length
        : startIndex + itemsPerPage;
    final currentItems = inquiry.sublist(startIndex, endIndex);

    return Column(
      children: [
        // 문의 리스트
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: currentItems.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  title: Row(
                    children: [
                      Text(
                        currentItems[index]['state']!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(currentItems[index]['date']!,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  subtitle: Text(currentItems[index]['title']!,
                      style: const TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InquiryOneDetail(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        // 페이지 네비게이션
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  onPressed: currentPage > 1
                      ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                      : null, // 첫 페이지일 때 비활성화
                ),
                Text(
                  '$currentPage / $totalPages',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: currentPage < totalPages
                      ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                      : null, // 마지막 페이지일 때 비활성화
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
