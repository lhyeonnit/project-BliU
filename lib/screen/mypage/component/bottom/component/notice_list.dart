import 'package:BliU/data/notice_data.dart';
import 'package:BliU/screen/mypage/component/bottom/component/notice_detail.dart';
import 'package:BliU/screen/mypage/viewmodel/notice_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeList extends ConsumerWidget {
  // TODO 페이징
  var pg = 0;
  NoticeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _getList(ref, true);

    return Container(
      color: Colors.white,
      child: Consumer(
        builder: (context, ref, widget) {
          final model = ref.watch(noticeListModelProvider);

          final List<NoticeData> noticeList = model?.noticeListResponseDTO?.list ?? [];

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: noticeList.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {

              final noticeData = noticeList[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                title: Text(
                  noticeData.ntTitle ?? "",
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.w600
                  ),
                ),
                subtitle: Text(noticeData.ntWdate ?? "", style: const TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // 공지사항 상세 페이지로 이동
                  final ntIdx = noticeData.ntIdx;
                  if (ntIdx != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoticeDetail(ntIdx: ntIdx,),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      ),
    );
  }

  void _getList(WidgetRef ref, bool isNew) {
    if (isNew) {
      final model = ref.read(noticeListModelProvider);
      model?.noticeListResponseDTO?.list?.clear();
    }

    final Map<String, dynamic> requestData = {
      'pg' : pg
    };

    ref.read(noticeListModelProvider.notifier).getList(requestData);
  }
}
