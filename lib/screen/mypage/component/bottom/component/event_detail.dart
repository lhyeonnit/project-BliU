import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/viewmodel/event_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class EventDetail extends ConsumerWidget {
  final int btIdx;

  const EventDetail({super.key, required this.btIdx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController _scrollController = ScrollController();

    final Map<String, dynamic> requestData = {
      'bt_idx': btIdx,
    };

    ref.read(eventDetailModelProvider.notifier).getDetail(requestData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('이벤트 상세'),
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
            margin: const EdgeInsets.only(top: 40.0),
            child: Consumer(builder: (context, ref, widget) {
              final model = ref.watch(eventDetailModelProvider);
              if (model?.eventDetailResponseDTO?.result == false) {
                Future.delayed(Duration.zero, () {
                  Utils.getInstance().showSnackBar(
                      context, model?.eventDetailResponseDTO?.message ?? "");
                });
              }

              final eventData = model?.eventDetailResponseDTO?.data;
              final btTitle = eventData?.btTitle ?? "";
              final btWdate = eventData?.btWdate ?? "";
              final btImage = eventData?.btImg ?? "";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          btTitle,
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 20),
                          child: Text(
                            btWdate,
                            style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Color(0xFF7B7B7B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Image.asset('assets/images/my/event_dt.png'),
                  Image.network(btImage)
                ],
              );
            }),
          ),
    );
  }
}
