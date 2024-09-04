import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventDetail extends StatelessWidget {
  const EventDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '이벤트',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    'SUMMER SEASON OFF!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2023-01-01',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/my/event_dt.png'),
          ],
        ),
      ),
    );
  }
}
