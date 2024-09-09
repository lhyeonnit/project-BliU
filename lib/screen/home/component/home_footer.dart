import 'package:BliU/screen/home/viewmodel/home_footer_view_model.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        print('푸터 성공 == ${model?.footResponseDTO?.data?.toJson()}');
        var data = model?.footResponseDTO?.data;
        if (data != null) {
          footInfo = '회사명 : ${data.stCompanyName}  |  대표 : ${data.stCompanyBoss}\n'
              '사업자등록번호 ${data.stCompanyNum1}\n'
              '제 통신판매업신고번호 : ${data.stCompanyNum2}\n'
              '주소 : ${data.stCompanyAdd}';
          print("footInfo == ${footInfo}");
        }
      } else {
        Future.delayed(Duration.zero, () {
          Utils.getInstance().showSnackBar(context, model?.footResponseDTO?.message ?? "");
        });

      }
    }

    return Container(
      color: const Color(0xFFF7F7F7), // 배경 색상
      padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  '공지사항',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              ),
              const Text(
                ' | ',
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '이용약관',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              ),
              const Text(
                ' | ',
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '개인정보처리방침',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          const Text(
            '사업자 정보',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(footInfo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Copyright © 2024 블리유. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
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
