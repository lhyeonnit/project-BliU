import 'package:BliU/data/event_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/event_detail/event_detail_screen.dart';
import 'package:BliU/screen/notice/view_model/event_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class EventList extends ConsumerStatefulWidget {
  const EventList({super.key});

  @override
  ConsumerState<EventList> createState() => EventListState();
}

class EventListState extends ConsumerState<EventList> {
  final ScrollController _scrollController = ScrollController();
  List<EventData> eventList = [];

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    _hasNextPage = true;

    final Map<String, dynamic> requestData = {
      'pg': _page
    };

    setState(() {
      eventList = [];
    });

    final eventListResponseDTO = await ref.read(eventListViewModelProvider.notifier).getList(requestData);
    eventList = eventListResponseDTO?.list ?? [];

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {
    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 200){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final Map<String, dynamic> requestData = {
        'pg': _page
      };

      final eventListResponseDTO = await ref.read(eventListViewModelProvider.notifier).getList(requestData);
      if (eventListResponseDTO != null) {
        if ((eventListResponseDTO.list ?? []).isNotEmpty) {
          setState(() {
            eventList.addAll(eventListResponseDTO.list ?? []);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.white,
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: eventList.length,
            itemBuilder: (context, index) {
              final eventData = eventList[index];
              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      eventData.btTitle ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 15),
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    subtitle: Text(eventData.btWdate ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: const Color(0xFF7B7B7B),
                          fontSize: Responsive.getFont(context, 14),
                          height: 1.2,
                        )
                    ),
                    trailing: SvgPicture.asset('assets/images/ic_link.svg'),
                    onTap: () {
                      // 공지사항 상세 페이지로 이동
                      final btIdx = eventData.btIdx;
                      if (btIdx != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(btIdx: btIdx),
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Divider(
                        thickness: 1,
                        color: Color(0xFFEEEEEE),
                      )
                  )
                ],
              );
            },
          ),
        ),
        MoveTopButton(scrollController: _scrollController),
      ],
    );
  }
}