


import 'package:BliU/screen/mypage/viewmodel/service_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'component/non_inquiry_service.dart';
import 'component/non_inquiry_store.dart';
import 'component/non_service_my_inquiry.dart';

class NonServicePage extends ConsumerStatefulWidget {
  const NonServicePage({super.key});
  @override
  _NonServicePageState createState() => _NonServicePageState();
}

class _NonServicePageState extends ConsumerState<NonServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('고객센터'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(
                builder: (context, ref, widget) {
                  final model = ref.watch(serviceModelProvider);

                  return Column(
                    children: [
                      _buildInfoRow(context, '메일문의',
                          model?.stCustomerEmail ?? 'email@email.com',
                          Colors.black, false),
                      Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          child: _buildInfoRow(context, '전화문의',
                              model?.stCustomerTel ?? '02-000-000',
                              Color(0xFFFF6192), true)),
                    ],
                  );
                }
            ),
            _buildCustomTile(
              context,
              '판매자 입점 문의',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NonInquiryStore()),
                );
              },
            ),
            _buildCustomTile(
              context,
              '고객센터 문의하기',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NonInquiryService(
                    qnaType: '1',)),
                );
              },
            ),
            _buildCustomTile(
              context,
              '문의내역',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NonServiceMyInquiry()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String content,
      Color contentColor, bool underline) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Responsive.getFont(context, 15),
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: Responsive.getFont(context, 14),
            fontWeight: FontWeight.w400,
            color: contentColor,
            decoration: underline ? TextDecoration.underline : TextDecoration.none,
              decorationColor: underline ? Color(0xFFFF6192) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTile(BuildContext context, String title,
      VoidCallback onTap) {
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
                fontWeight: FontWeight.w500,
              ),
            ),
            SvgPicture.asset('assets/images/ic_link.svg', color: Colors.black,),
          ],
        ),
      ),
    );
  }
}
