import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/top/alarm_event.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/screen/mypage/component/top/alarm_notice.dart';
import 'package:BliU/widget/top_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// 알림 화면
class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<StatefulWidget> createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen> with TopWidgetDelegate {
  List<Widget> _viewArr = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 리스트 항목 추가
    for (int i = 0; i < 10; i++) {
      _viewArr.add(AlarmNotice());
      _viewArr.add(AlarmEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('알림'),
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
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,  // ScrollController 설정
            children: _viewArr,
          ),
          MoveTopButton(scrollController: _scrollController), // 같은 ScrollController를 전달
        ],
      ),
    );
  }
}
