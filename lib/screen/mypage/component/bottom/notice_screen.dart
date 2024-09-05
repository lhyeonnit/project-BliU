import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'component/event_list.dart';
import 'component/notice_list.dart';


class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '공지사항',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: '일반'),
            Tab(text: '이벤트'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NoticeList(),
          EventList(), // 이벤트 탭 내용은 필요에 따라 채워 넣으세요.
        ],
      ),
    );
  }
}
