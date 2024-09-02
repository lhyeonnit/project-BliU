import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InquiryProductDetail extends StatelessWidget {
  const InquiryProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '문의내역',
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
        child: ListView(
          children: [
            // 상품 정보
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '[꼬마별빛] [꼬잉특가+무배] 꼬마별빛 에스더니니 12종 10,900원 균일가 상하...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '32,800원',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 문의 상태와 내용
            Row(
              children: [
                const Text(
                  '답변완료',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  child: const Text(
                    '2024.04.14',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '안녕하세요 배송언제되나요?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '안녕하세요 배송언제되나요? 너무 오래걸리는거 같아요 빨리 배송 부탁드립니다~',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 16),

            // 첨부 이미지들
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Image.asset(
                    'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/home/exhi.png', // 실제 이미지 경로로 변경
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 삭제 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 삭제 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '삭제',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 답변 내용
            Row(
              children: [
                Image.asset(
                  'assets/images/store/brand_logo.png', // 실제 브랜드 로고 경로로 변경
                  width: 70,
                  height: 70,
                  fit: BoxFit.fitHeight,
                ),
                Container(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '밀크마일',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '2024.04.15',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '귀하의 주문 건에 대해 배송 일정을 안내드립니다. 현재 주문하신 상품은 발송 준비 중이며, 예상 배송일은 2024.04.18입니다. 주문 상황에 따라 다소 지연될 수 있는 점 양해 부탁드립니다.',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text(
              '추가 문의 사항이나 도움이 필요하신 경우, 언제든지 고객센터로 연락 주시기 바랍니다. 신속하고 정확한 답변을 드릴 수 있도록 최선을 다하겠습니다.\n\n감사합니다.\n[밀크마일] 드림',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
