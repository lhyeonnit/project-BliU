import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/my_point/view_model/my_point_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPointScreen extends ConsumerStatefulWidget {
  const MyPointScreen({super.key});

  @override
  ConsumerState<MyPointScreen> createState() => MyPointScreenState();
}

class MyPointScreenState extends ConsumerState<MyPointScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _categories = ['전체', '적립', '사용'];

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
    final requestData = await _makeRequestData();
    ref.read(myPointViewModelProvider.notifier).listLoad(requestData);
  }

  void _nextLoad() async {
    if (_scrollController.position.extentAfter < 200) {
      final requestData = await _makeRequestData();
      ref.read(myPointViewModelProvider.notifier).listNextLoad(requestData);
    }
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final model = ref.read(myPointViewModelProvider);

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String pointStatus = "all";
    if (model.selectedCategoryIndex == 1) {
      pointStatus = "P";
    } else if (model.selectedCategoryIndex == 2) {
      pointStatus = "M";
    }

    final Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'point_status': pointStatus,
    };

    return requestData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('포인트'),
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
        child: Consumer(
          builder: (context, ref, widget) {
            final model = ref.watch(myPointViewModelProvider);
            final mtPoint = model.mtPoint;
            final selectedCategoryIndex = model.selectedCategoryIndex;
            final pointList = model.pointList;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '나의 포인트',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              '${Utils.getInstance().priceString(mtPoint)}P',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 18),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 38,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final bool isSelected = selectedCategoryIndex == index;

                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(myPointViewModelProvider.notifier).setSelectedCategoryIndex(index);
                                  _getList();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
                                      width: 1.0,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _categories[index],
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 14),
                                        color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(thickness: 10, color: Color(0xFFF5F9F9)),
                      Visibility(
                        visible: pointList.isNotEmpty,
                        child: Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: pointList.length,
                            itemBuilder: (context, index) {
                              // 데이터를 사용하여 아이템 생성
                              final pointData = pointList[index];

                              String type = pointData.pltTypeTxt ?? "";
                              String pirce = pointData.pltPrice ?? "";
                              String memo = pointData.pltMemo ?? "";
                              String wdate = pointData.pltWdate ?? "";

                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          type,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            color: type == '적립' ? const Color(0xFFFF6192) : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pirce,
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: Responsive.getFont(context, 15),
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.2,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.symmetric(vertical: 8),
                                                child: Text(
                                                  memo,
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    color: const Color(0xFF7B7B7B),
                                                    fontSize: Responsive.getFont(context, 14),
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                wdate,
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  color: const Color(0xFF7B7B7B),
                                                  fontSize: Responsive.getFont(context, 14),
                                                  height: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index != pointList.length - 1)
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 16),
                                      child: const Divider(
                                        thickness: 1, // 구분선 두께
                                        color: Color(0xFFEEEEEE), // 구분선 색상
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: pointList.isNotEmpty,
                  child: MoveTopButton(scrollController: _scrollController),
                ),
                Visibility(
                  visible: pointList.isEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(top: 80),
                    child: const NonDataScreen(text: '포인트 내역이 없습니다.'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
