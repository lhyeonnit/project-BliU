import 'package:BliU/data/notice_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/bottom/component/notice_detail.dart';
import 'package:BliU/screen/mypage/viewmodel/notice_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class NoticeList extends ConsumerWidget {
  // TODO 페이징
  var pg = 0;

  NoticeList({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _getList(ref, true);

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          color: Colors.white,
          child: Consumer(builder: (context, ref, widget) {
            final model = ref.watch(noticeListModelProvider);

            final List<NoticeData> noticeList =
                model?.noticeListResponseDTO?.list ?? [];

            return ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: noticeList.length,
              itemBuilder: (context, index) {
                final noticeData = noticeList[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        noticeData.ntTitle ?? "",
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 15),
                            fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(noticeData.ntWdate ?? "",
                          style: TextStyle(
                              color: Color(0xFF7B7B7B),
                              fontSize: Responsive.getFont(context, 14))),
                      trailing: SvgPicture.asset('assets/images/ic_link.svg'),
                      onTap: () {
                        // 공지사항 상세 페이지로 이동
                        final ntIdx = noticeData.ntIdx;
                        if (ntIdx != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoticeDetail(
                                ntIdx: ntIdx,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        thickness: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                    )
                  ],
                );
              },
            );
          }),
        ),
        MoveTopButton(scrollController: _scrollController),
      ],
    );
  }

  void _getList(WidgetRef ref, bool isNew) {
    if (isNew) {
      final model = ref.read(noticeListModelProvider);
      model?.noticeListResponseDTO?.list?.clear();
    }

    final Map<String, dynamic> requestData = {'pg': pg};

    ref.read(noticeListModelProvider.notifier).getList(requestData);
  }
}
