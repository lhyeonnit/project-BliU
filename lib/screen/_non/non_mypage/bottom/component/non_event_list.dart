

import 'package:BliU/data/event_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/component/non_event_detail.dart';
import 'package:BliU/screen/mypage/viewmodel/event_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class NonEventList extends ConsumerWidget {
  // TODO 페이징
  var pg = 0;
  NonEventList({super.key});
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
            final model = ref.watch(eventListModelProvider);

            final List<EventData> eventList = model?.eventListResponseDTO?.list ?? [];

            return ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                final eventData = eventList[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        eventData.btTitle ?? "",
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 15),
                            fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(eventData.btWdate ?? "",
                          style: TextStyle(
                              color: Color(0xFF7B7B7B),
                              fontSize: Responsive.getFont(context, 14))),
                      trailing: SvgPicture.asset('assets/images/ic_link.svg'),
                      onTap: () {
                        // 공지사항 상세 페이지로 이동
                        final btIdx = eventData.btIdx;
                        if (btIdx != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NonEventDetail(
                                btIdx: btIdx,
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
                        ))
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
      final model = ref.read(eventListModelProvider);
      model?.eventListResponseDTO?.list?.clear();
    }

    final Map<String, dynamic> requestData = {
      'pg' : pg
    };

    ref.read(eventListModelProvider.notifier).getList(requestData);
  }
}
