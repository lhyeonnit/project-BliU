import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoticeDetail extends StatelessWidget {
  const NoticeDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '공지사항',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    '적립금사용 정책 변경안내',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '2023-01-01',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              '안녕하세요?\n주문 시 사용하시는 적립금 사용 정책이 아래와 같이 변경되었으니 이 점 참고 바랍니다.\n\n'
                  '변경 전 : 무제한\n변경 후 : 상품금액의 최대 10%까지 사용(배송비 제외)\n시행일자 : 2023.09.11 오후 2시\n\n'
                  '추후 다양한 이벤트 및 보다 많은 쇼핑 혜택을 드리기 위해 더욱 노력하겠습니다.\n'
                  '언제나 안전하고 행복한 날 되시기 바랍니다.\n감사합니다.\n\n'
                  '고객센터 운영시간\n'
                  'tel. 1600-7346\n'
                  '평일 10:00~17:00 / 점심시간 12:30~13:30',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
