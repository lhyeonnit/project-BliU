import 'package:BliU/data/qna_data.dart';
import 'package:BliU/screen/mypage/viewmodel/inquiry_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class InquiryOneDetail extends ConsumerWidget {
  final int qtIdx;

  const InquiryOneDetail({super.key, required this.qtIdx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SharedPreferencesManager.getInstance().then((pref) {
      Map<String, dynamic> requestData = {
        'mt_idx' : pref.getMtIdx(),
        'qt_idx' : qtIdx,
        'qnt_type' : 1,
      };
      ref.read(inquiryDetailModelProvider.notifier).getDetail(requestData);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '문의내역',
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
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, widget) {

            final model = ref.watch(inquiryDetailModelProvider);

            if (model?.qnaDetailResponseDTO?.result == false) {
              Future.delayed(Duration.zero, () {
                Utils.getInstance().showSnackBar(context, model?.qnaDetailResponseDTO?.message ?? "");
                model?.qnaDetailResponseDTO = null;
              });
              return Container();
            }

            final detailData = model?.qnaDetailResponseDTO?.data;
            final contentImgList = detailData?.qtContentImg ?? [];

            List<Widget> contentImgWidgetList = [];
            for (var contentImg in contentImgList) {
              final tmpWidget = _contentImgList(contentImg);
              contentImgWidgetList.add(tmpWidget);
            }

            Widget answerWidget = Container();
            if (detailData?.qtStatus == "Y") {
              answerWidget = _answerWidget(context, detailData);
            }

            return ListView(
              children: [
                // 문의 상태와 내용
                Row(
                  children: [
                    Text(
                      detailData?.qtStatusTxt ?? "",
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 16),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      child: Text(
                        detailData?.qtWdate ?? "",
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  detailData?.qtTitle ?? "",
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detailData?.qtContent ?? "",
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 16),

                // 첨부 이미지들
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: contentImgWidgetList,
                  ),
                ),
                const SizedBox(height: 16),

                // 삭제 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO 삭제 동작 추가
                      _delete();
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
                answerWidget,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _contentImgList(String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Image.network(
        imgUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return _errorImg(80, 80);
        },
      ),
    );
  }

  Widget _errorImg(double width, double height) {
    return Image.asset(
      'assets/images/start_logo.png',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Widget _answerWidget(BuildContext context, QnaData? detailData) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '고객센터',
              style: TextStyle(
                fontSize: Responsive.getFont(context, 16),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              detailData?.qtUdate ?? "",
              style: TextStyle(
                fontSize: Responsive.getFont(context, 15),
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Text(
          detailData?.qtAnswer ?? "",
          style: TextStyle(
            fontSize: Responsive.getFont(context, 14),
            color: Colors.black
          ),
        ),
      ],
    );
  }

  void _delete() {

  }
}