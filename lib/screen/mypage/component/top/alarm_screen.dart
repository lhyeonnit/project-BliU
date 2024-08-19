import 'package:BliU/widget/alarm_item_widget.dart';
import 'package:BliU/widget/top_widget.dart';
import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            TopWidget(
              title: "알림",
              delegate: this,
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  ListView(
                    scrollDirection: Axis.vertical,
                    children: _viewArr,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    alignment: Alignment.bottomRight,
                    child: Container( // TODO 탑 버튼
                      width: 40,
                      height: 40,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}