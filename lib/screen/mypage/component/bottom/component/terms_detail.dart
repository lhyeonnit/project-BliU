import 'package:BliU/screen/mypage/viewmodel/terms_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

//약관 or 개인정보 처리방치등
class TermsDetail extends ConsumerWidget {
  final int type;//0 - 이용약관 1 - 개인정보 처리 방침

  const TermsDetail({super.key, required this.type});

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
        title: Text(
          title,
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
      body: Container (
        margin: const EdgeInsets.only(top: 24),
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

