import 'package:flutter/material.dart';

import 'notice_detail.dart';

class NoticeList extends StatelessWidget {
  NoticeList({super.key});
  final List<Map<String, String>> notices = [
    {'title': '적립금사용 정책 변경안내', 'date': '2023-01-01'},
    {'title': '서비스 정기 점검 안내', 'date': '2023-01-01'},
    {'title': '네이버페이 서비스 일시 중지 안내 (7/8 2시~7시)', 'date': '2023-01-01'},
    {'title': '2023년 1월 설연휴 기간 운영 안내 (고객센터, 자체배송, 교환/반품 접수)', 'date': '2023-01-01'},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: notices.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            title: Text(
              notices[index]['title']!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(notices[index]['date']!, style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 공지사항 상세 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeDetail(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
