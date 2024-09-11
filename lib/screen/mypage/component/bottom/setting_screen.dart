import 'package:BliU/screen/mypage/component/bottom/component/terms_detail.dart';
import 'package:BliU/screen/mypage/viewmodel/setting_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var data = {
      'mt_idx': '2'
    };
    ref.read(settingModelProvider.notifier).getPushInfo(data);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '설정',
          style: TextStyle(
              color: Colors.black,
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold
          ),
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
                  Consumer(
                    builder: (context, ref, widget) {
                      final resultModel = ref.watch(settingModelProvider);

                      var isSwitched = false;
                      if (resultModel?.mtPushing != null) {
                        String mtPushing = resultModel?.mtPushing ?? "";
                        if (mtPushing == "Y") {
                          isSwitched = true;
                        } else if (mtPushing == "N") {
                          isSwitched = false;
                        }
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '알림',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 16),
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          FlutterSwitch(
                            width: 55.0,
                            height: 25.0,
                            valueFontSize: Responsive.getFont(context, 12),
                            toggleSize: 18.0,
                            value: isSwitched,
                            borderRadius: 30.0,
                            padding: 4.0,
                            showOnOff: false,
                            activeColor: Colors.grey,
                            inactiveColor: Colors.grey.shade300,
                            toggleColor: Colors.white,
                            onToggle: (val) {
                              String mtPushing = "";
                              if (val) {
                                mtPushing = "Y";
                              } else {
                                mtPushing = "N";
                              }

                              var data = {
                                'mt_idx': '2',
                                'mt_pushing': mtPushing
                              };
                              var model = ref.read(settingModelProvider);
                              model?.mtPushing = mtPushing;
                              ref.read(settingModelProvider.notifier).setPush(data);
                            },
                          ),
                        ],
                      );
                    }
                  ),
                  const SizedBox(height: 10),
                  _buildCustomTile(
                    context, '이용약관',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TermsDetail(type: 0)),
                      );
                    },
                  ),
                  _buildCustomTile(
                    context, '개인정보처리방침',
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

  Widget _buildCustomTile(BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.getFont(context, 16),
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
