import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/notice_detail/view_model/notice_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class NoticeDetailScreen extends ConsumerWidget {
  final int ntIdx;

  const NoticeDetailScreen({super.key, required this.ntIdx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController = ScrollController();

    final Map<String, dynamic> requestData = {
      'nt_idx': ntIdx,
    };

    ref.read(noticeDetailViewModelProvider.notifier).getDetail(requestData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('공지사항'),
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
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Consumer(builder: (context, ref, widget) {
              final model = ref.watch(noticeDetailViewModelProvider);
              if (model?.noticeDetailResponseDTO?.result == false) {
                Future.delayed(Duration.zero, () {
                  if (!context.mounted) return;
                  Utils.getInstance().showSnackBar(context, model?.noticeDetailResponseDTO?.message ?? "");
                });
              }

              final noticeData = model?.noticeDetailResponseDTO?.data;
              final ntTitle = noticeData?.ntTitle ?? "";
              final ntWdate = noticeData?.ntWdate ?? "";
              final ntContent = noticeData?.ntContent ?? "";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          ntTitle,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 17),
                          child: Text(
                            ntWdate,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: const Color(0xFF7B7B7B),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ntContent,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          MoveTopButton(scrollController: scrollController),
        ],
      ),
    );
  }
}
