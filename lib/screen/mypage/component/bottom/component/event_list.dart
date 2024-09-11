import 'package:BliU/data/event_data.dart';
import 'package:BliU/screen/mypage/viewmodel/event_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'event_detail.dart';

class EventList extends ConsumerWidget {
  // TODO 페이징
  var pg = 0;
  EventList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    _getList(ref, true);

    return Container(
      color: Colors.white,
      child: Consumer(
        builder: (context, ref, widget) {

          final model = ref.watch(eventListModelProvider);

          final List<EventData> eventList = model?.eventListResponseDTO?.list ?? [];

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: eventList.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {

              final eventData = eventList[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                title: Text(
                  eventData.btTitle ?? "",
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.w600
                  ),
                ),
                subtitle: Text(eventData.btWdate ?? "", style: const TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // 상세 페이지로 이동
                  final btIdx = eventData.btIdx;
                  if (btIdx != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetail(btIdx: btIdx,),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
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
