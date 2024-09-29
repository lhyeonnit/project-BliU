import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/component/alarm_event.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'component/alarm_notice.dart';

// 알림 화면
class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<StatefulWidget> createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen> {
  final List<Widget> _viewArr = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 리스트 항목 추가
    for (int i = 0; i < 10; i++) {
      _viewArr.add(const AlarmNotice());
      _viewArr.add(const AlarmEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('알림'),
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
      body: Stack(
        children: [
          ListView(
            controller: _scrollController, // ScrollController 설정
            children: _viewArr,
          ),
          MoveTopButton(scrollController: _scrollController),
          // 같은 ScrollController를 전달
        ],
      ),
    );
  }
}
