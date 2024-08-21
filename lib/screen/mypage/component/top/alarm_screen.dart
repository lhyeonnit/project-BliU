import 'package:BliU/utils/responsive.dart';
import 'package:BliU/widget/alarm_item_widget.dart';
import 'package:BliU/widget/top_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//알림
class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<StatefulWidget> createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen> with TopWidgetDelegate {
  List<Widget> _viewArr = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; i++) {
      _viewArr.add(AlarmItemWidget());
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
            scrollDirection: Axis.vertical,
            children: _viewArr,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
            alignment: Alignment.bottomRight,
            child: Container(
              // TODO 탑 버튼
              width: 40,
              height: 40,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
