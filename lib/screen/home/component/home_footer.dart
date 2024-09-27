import 'package:BliU/screen/home/viewmodel/home_footer_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeFooter extends ConsumerWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String footInfo = '회사명 : #####  |  대표 : ###\n'
        '사업자등록번호 ############\n'
        '제 통신판매업신고번호 : ###############\n'
        '주소 : ####################';

    final model = ref.watch(footerViewModelProvider);

    if (model?.footResponseDTO != null) {
      if (model?.footResponseDTO?.result == true) {
        var data = model?.footResponseDTO?.data;
        if (data != null) {
          footInfo =
              '회사명 : ${data.stCompanyName}  |  대표 : ${data.stCompanyBoss}\n'
              '사업자등록번호 ${data.stCompanyNum1}\n'
              '제 통신판매업신고번호 : ${data.stCompanyNum2}\n'
              '주소 : ${data.stCompanyAdd}';
        }
      } else {
        Future.delayed(Duration.zero, () {
          Utils.getInstance()
              .showSnackBar(context, model?.footResponseDTO?.message ?? "");
        });
      }
    }

    return Container(
      color: const Color(0xFFF5F9F9), // 배경 색상
      padding: const EdgeInsets.only(top: 40, bottom: 102.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  '공지사항',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: const Color(0xFF7B7B7B),
                    fontSize: Responsive.getFont(context, 13),
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    border: Border.symmetric(
                        vertical: BorderSide(color: Color(0xFFDDDDDD)))),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    '이용약관',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: const Color(0xFF7B7B7B),
                      fontSize: Responsive.getFont(context, 13),
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  '개인정보처리방침',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: const Color(0xFF7B7B7B),
                    fontSize: Responsive.getFont(context, 13),
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              //  TODO 사업자 정보
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '사업자 정보',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: const Color(0xFF7B7B7B),
                      fontSize: Responsive.getFont(context, 13),
                      height: 1.2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: SvgPicture.asset(
                        'assets/images/home/ft_collapse.svg',
                        color: const Color(0xFF7B7B7B)),
                  ),
                ],
              ),
            ),
          ),
          Text(
            footInfo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              color: const Color(0xFF7B7B7B),
              fontSize: Responsive.getFont(context, 12),
              height: 1.2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              'Copyright © 2024 블리유. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: const Color(0xFF7B7B7B),
                fontSize: Responsive.getFont(context, 12),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Widget _buildCountDown(BuildContext context, WidgetRef ref) {
//   var test = ref.watch(footerViewModelProvider.)
//
//   return Text(
//     remaining.toString(),
//   );
// }
}
