

//약관 or 개인정보 처리방치등
import 'package:BliU/screen/mypage/viewmodel/terms_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class NonTermsDetail extends ConsumerWidget {
  final int type;//0 - 이용약관 1 - 개인정보 처리 방침

  const NonTermsDetail({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String title = "이용약관";
    if (type == 1) {
      title = "개인정보처리방침";
    }
    ref.read(termsDetailModelProvider.notifier).getTermsAndPrivacy(type);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(title),
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
      body: Container (
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Consumer(
            builder: (context, ref, widget) {
              String content = "";

              final model = ref.watch(termsDetailModelProvider);

              if (model?.defaultResponseDTO != null) {
                if (model?.defaultResponseDTO?.result == true) {
                  content = model?.defaultResponseDTO?.message ?? "";
                } else {
                  Future.delayed(Duration.zero, () {
                    Utils.getInstance().showSnackBar(context, model?.defaultResponseDTO?.message ?? "");
                  });
                }
              }

              return Text(
                content,
                style: TextStyle(
                  color: Colors.black,
                    fontWeight: FontWeight.w400,
                  fontSize: Responsive.getFont(context, 14),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
