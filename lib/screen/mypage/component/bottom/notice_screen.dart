import 'package:BliU/screen/mypage/component/bottom/component/event_list.dart';
import 'package:BliU/screen/mypage/component/bottom/component/notice_list.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          preferredSize: const Size.fromHeight(60 + 1.0), // TabBar 높이 + 구분선 두께
          child: Column(
            children: [
              // 구분선
              Container(
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
              // TabBar
              SizedBox(
                height: 60,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: '일반'),
                    Tab(text: '이벤트'),
                  ],
                  overlayColor: WidgetStateColor.transparent,
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // 인디케이터가 각 탭의 길이에 맞게 조정됨
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFF7B7B7B),
                  dividerColor: const Color(0xFFDDDDDD),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NoticeList(),
          EventList(), // 이벤트 탭 내용은 필요에 따라 채워 넣으세요.
        ],
      ),
    );
  }
}
