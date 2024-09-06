import 'package:BliU/screen/mypage/component/bottom/component/terms_detail.dart';
import 'package:BliU/screen/mypage/viewmodel/setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();

    ref.read(settingModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '알림',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      FlutterSwitch(
                        width: 55.0,
                        height: 25.0,
                        valueFontSize: 12.0,
                        toggleSize: 18.0,
                        value: _isSwitched,
                        borderRadius: 30.0,
                        padding: 4.0,
                        showOnOff: false,
                        activeColor: Colors.grey,
                        inactiveColor: Colors.grey.shade300,
                        toggleColor: Colors.white,
                        onToggle: (val) {
                          //print("val -- $val}");
                          setState(() {
                            _isSwitched = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildCustomTile(
                    '이용약관',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TermsDetail(type: 0)),
                      );
                    },
                  ),
                  _buildCustomTile(
                    '개인정보처리방침',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TermsDetail(type: 1)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTile(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
