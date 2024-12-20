import 'package:BliU/screen/event_detail/view_model/event_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class EventDetailScreen extends ConsumerWidget {
  final int btIdx;

  const EventDetailScreen({super.key, required this.btIdx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> requestData = {
      'bt_idx': btIdx,
    };

    ref.read(eventDetailViewModelProvider.notifier).getDetail(requestData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('이벤트 상세'),
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
          margin: const EdgeInsets.only(top: 40.0),
          child: Consumer(builder: (context, ref, widget) {
            final model = ref.watch(eventDetailViewModelProvider);
            if (model.eventDetailResponseDTO?.result == false) {
              Future.delayed(Duration.zero, () {
                if (!context.mounted) return;
                Utils.getInstance().showSnackBar(context, model.eventDetailResponseDTO?.message ?? "");
              });
            }

            final eventData = model.eventDetailResponseDTO?.data;
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
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 20),
                        child: Text(
                          btWdate,
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
                Expanded(
                  flex: 1,
                  child: CachedNetworkImage(
                    imageUrl: btImage,
                    width: double.infinity,
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return SvgPicture.asset(
                        'assets/images/no_imge.svg',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
