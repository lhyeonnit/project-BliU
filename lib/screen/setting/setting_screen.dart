import 'package:BliU/screen/setting/view_model/setting_view_model.dart';
import 'package:BliU/screen/terms_detail/terms_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends ConsumerState<SettingScreen> {
  void _getList() async {
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
    };
    await ref.read(settingViewModelProvider.notifier).getPushInfo(requestData);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('설정'),
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
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 26),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Consumer(builder: (context, ref, widget) {
                      final resultModel = ref.watch(settingViewModelProvider);

                      var isSwitched = false;
                      if (resultModel?.mtPushing != null) {
                        String mtPushing = resultModel?.mtPushing ?? "";
                        if (mtPushing == "Y") {
                          isSwitched = true;
                        } else if (mtPushing == "N") {
                          isSwitched = false;
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '알림',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 15),
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
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
                              activeColor: const Color(0xFFFF6192),
                              inactiveColor: const Color(0xFFDDDDDD),
                              toggleColor: Colors.white,
                              onToggle: (val) async {
                                final pref = await SharedPreferencesManager.getInstance();

                                String mtPushing = "";
                                if (val) {
                                  mtPushing = "Y";
                                } else {
                                  mtPushing = "N";
                                }

                                var data = {
                                  'mt_idx': pref.getMtIdx(),
                                  'mt_pushing': mtPushing
                                };
                                var model = ref.read(settingViewModelProvider);
                                model?.mtPushing = mtPushing;
                                ref.read(settingViewModelProvider.notifier).setPush(data);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    _buildCustomTile(
                      context,
                      '이용약관',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TermsDetailScreen(type: 0)),
                        );
                      },
                    ),
                    _buildCustomTile(
                      context,
                      '개인정보처리방침',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TermsDetailScreen(type: 1)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTile(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // 최소한의 간격으로 조절 가능
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 15),
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            SvgPicture.asset(
              'assets/images/ic_link.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
