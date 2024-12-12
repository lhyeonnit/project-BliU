import 'package:BliU/data/qna_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/inquiry_product_detail/view_model/inquiry_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class InquiryOneDetailScreen extends ConsumerWidget {
  final int qtIdx;

  const InquiryOneDetailScreen({super.key, required this.qtIdx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController = ScrollController();
    SharedPreferencesManager.getInstance().then((pref) {
      Map<String, dynamic> requestData = {
        'mt_idx': pref.getMtIdx(),
        'qt_idx': qtIdx,
        'qnt_type': 1,
      };
      ref.read(inquiryDetailViewModelProvider.notifier).getDetail(requestData);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('문의내역'),
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
        child: Stack(
          children: [
            Consumer(
              builder: (context, ref, widget) {
                final model = ref.watch(inquiryDetailViewModelProvider);

                if (model.qnaDetailResponseDTO?.result == false) {
                  Future.delayed(Duration.zero, () {
                    if (!context.mounted) return;
                    Utils.getInstance().showSnackBar(context, model.qnaDetailResponseDTO?.message ?? "");
                    model.qnaDetailResponseDTO = null;
                  });
                  return Container();
                }

                final detailData = model.qnaDetailResponseDTO?.data;
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
                  controller: scrollController,
                  children: [
                    // 문의 상태와 내용
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                detailData?.qtStatusTxt ?? "",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 11),
                                child: Text(
                                  detailData?.qtWdate ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 12),
                                    color: const Color(0xFF7B7B7B),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 10),
                            child: Text(
                              detailData?.qtTitle ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            detailData?.qtContent ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: contentImgWidgetList,
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          _delete(context, ref);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFDDDDDD)),
                          ),
                          child: Center(
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const Divider(
                        thickness: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                    ),
                    // 답변 내용
                    answerWidget,
                  ],
                );
              },
            ),
            MoveTopButton(scrollController: scrollController),
          ],
        ),
      ),
    );
  }

  Widget _contentImgList(String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          imgUrl,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return SizedBox(
              width: 90,
              height: 90,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/no_imge.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          },
        ),
      ),
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
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: Text(
                detailData?.qtUdate ?? "",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 13),
                  color: const Color(0xFF7B7B7B),
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            detailData?.qtAnswer ?? "",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  void _delete(BuildContext context, WidgetRef ref) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'qt_idx' : qtIdx,
    };

    final defaultResponseDTO = await ref.read(inquiryDetailViewModelProvider.notifier).delete(requestData);
    if (!context.mounted) return;

    if (defaultResponseDTO.result == true) {
      Navigator.pop(context, true);
    }
    Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
  }
}
