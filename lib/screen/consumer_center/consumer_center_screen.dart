import 'package:BliU/screen/consumer_center/view_model/consumer_center_view_model.dart';
import 'package:BliU/screen/inquiry_service/inquiry_service_screen.dart';
import 'package:BliU/screen/inquiry_store/inquiry_store_screen.dart';
import 'package:BliU/screen/login/login_screen.dart';
import 'package:BliU/screen/modal_dialog/message_dialog.dart';
import 'package:BliU/screen/my_inquiry/my_inquiry_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsumerCenterScreen extends ConsumerWidget {
  const ConsumerCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(consumerCenterViewModelProvider.notifier).getService();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('고객센터'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(builder: (context, ref, widget) {
                final model = ref.watch(consumerCenterViewModelProvider);

                return Column(
                  children: [
                    _buildInfoRow(
                      context,
                      '메일문의',
                      model.stCustomerEmail ?? 'email@email.com',
                      Colors.black,
                      false,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '전화문의',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 15),
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              String telNumber = model.stCustomerTel ?? '02-000-000';
                              telNumber = telNumber.replaceAll("-", "");
                              final url = Uri.parse("tel:$telNumber");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            child: Text(
                              model.stCustomerTel ?? '02-000-000',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFFF6192),
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFFFF6192),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              _buildCustomTile(context, '판매자 입점 문의', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InquiryStoreScreen(),
                  ),
                );
              }),
              _buildCustomTile(context, '고객센터 문의하기', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InquiryServiceScreen(qnaType: '1',),
                  ),
                );
              },),
              _buildCustomTile(context, '문의내역', () {

                SharedPreferencesManager.getInstance().then((pref) {
                  if (!context.mounted) return;
                  final mtIdx = pref.getMtIdx();
                  if (mtIdx != null && mtIdx.isNotEmpty) {
                    // 회원인 경우
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyInquiryScreen(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return MessageDialog(
                          title: "알림", message: "로그인이 필요합니다.",
                          doConfirm: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                        );
                      },
                    );
                  }
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String content, Color contentColor, bool underline) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 15),
            color: Colors.black,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        GestureDetector(
          onTap: () {
            // 텍스트를 클릭했을 때 클립보드에 복사
            Clipboard.setData(ClipboardData(text: content));
            Utils.getInstance().showSnackBar(context, '$content 복사되었습니다.');
          },
          child: Text(
            content,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              fontWeight: FontWeight.w400,
              color: contentColor,
              decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
              decorationColor: underline ? const Color(0xFFFF6192) : null,
              height: 1.2,
            ),
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
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 16),
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            SvgPicture.asset(
              'assets/images/ic_link.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
