import 'package:BliU/screen/mypage/component/bottom/component/inquiry_service.dart';
import 'package:BliU/screen/mypage/viewmodel/service_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'component/inquiry_store.dart';
import 'component/service_my_inquiry.dart';

class ServiceScreen extends ConsumerWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(serviceModelProvider.notifier).getService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '고객센터',
          style: TextStyle(
              color: Colors.black,
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold
          ),
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
            Consumer(
              builder: (context, ref, widget) {
                final model = ref.watch(serviceModelProvider);

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildInfoRow(context, '메일문의', model?.stCustomerEmail ?? 'email@email.com', Colors.black),
                    const SizedBox(height: 16),
                    _buildInfoRow(context,'전화문의', model?.stCustomerTel ?? '02-000-000', Colors.pink),
                  ],
                );
              }
            ),
            const SizedBox(height: 10),
            _buildCustomTile(
              context,
              '판매자 입점 문의',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InquiryStore()),
                );
              },
            ),
            _buildCustomTile(
              context,
              '고객센터 문의하기',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InquiryService(qnaType: '1',)),
                );
              },
            ),
            _buildCustomTile(
              context,
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

  Widget _buildInfoRow(BuildContext context, String title, String content, Color contentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Responsive.getFont(context, 16),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: Responsive.getFont(context, 16),
            color: contentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTile(BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.getFont(context, 16),
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
