
import 'package:flutter/material.dart';

import 'event_detail.dart';

class EventList extends StatelessWidget {
  EventList({super.key});
  final List<Map<String, String>> notices = [
    {'title': 'SUMMER SEASON OFF!', 'date': '2023-01-01'},
    {'title': 'SUMMER SEASON OFF!', 'date': '2023-01-01'},
    {'title': 'SUMMER SEASON OFF!', 'date': '2023-01-01'},
    {'title': 'SUMMER SEASON OFF!', 'date': '2023-01-01'},
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
                  builder: (context) => const EventDetail(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
