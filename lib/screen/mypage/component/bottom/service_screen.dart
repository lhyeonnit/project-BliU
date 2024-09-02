import 'package:BliU/screen/mypage/component/bottom/inquiry_service.dart';
import 'package:BliU/screen/mypage/component/bottom/inquiry_store.dart';
import 'package:BliU/screen/mypage/component/bottom/service_my_inquiry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '고객센터',
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildInfoRow('메일문의', 'email@email.com', Colors.black),
            const SizedBox(height: 16),
            _buildInfoRow('전화문의', '02-000-000', Colors.pink),
            const SizedBox(height: 10),
            _buildCustomTile(
              '판매자 입점 문의',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InquiryStore()),
                );
              },
            ),
            _buildCustomTile(
              '고객센터 문의하기',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InquiryService()),
                );
              },
            ),
            _buildCustomTile(
              '문의내역',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServiceMyInquiryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content, Color contentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: contentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTile(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
