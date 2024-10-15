import 'package:BliU/data/point_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/viewmodel/point_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PointScreen extends ConsumerStatefulWidget {
  const PointScreen({super.key});

  @override
  ConsumerState<PointScreen> createState() => _PointScreenState();
}

class _PointScreenState extends ConsumerState<PointScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _categories = ['전체', '적립', '사용'];
  int _selectedCategoryIndex = 0;

  int _mtPoint = 0;
  List<PointData> _pointList = [];

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

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
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String pointStatus = "all";
    if (_selectedCategoryIndex == 1) {
      pointStatus = "P";
    } else if (_selectedCategoryIndex == 2) {
      pointStatus = "M";
    }

    final Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'point_status': pointStatus,
      'pg': _page
    };

    final pointListResponseDTO = await ref.read(pointViewModelProvider.notifier).getList(requestData);
    _mtPoint = pointListResponseDTO?.mtPoint ?? 0;
    _pointList = pointListResponseDTO?.list ?? [];

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {
    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 200){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();

      String pointStatus = "all";
      if (_selectedCategoryIndex == 1) {
        pointStatus = "P";
      } else if (_selectedCategoryIndex == 2) {
        pointStatus = "M";
      }

      final Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'point_status': pointStatus,
        'pg': _page
      };

      final pointListResponseDTO = await ref.read(pointViewModelProvider.notifier).getList(requestData);
      if (pointListResponseDTO != null) {
        if ((pointListResponseDTO.list ?? []).isNotEmpty) {
          setState(() {
            _pointList.addAll(pointListResponseDTO.list ?? []);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
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
                        '${Utils.getInstance().priceString(_mtPoint)}P',
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
                      final bool isSelected = _selectedCategoryIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: FilterChip(
                          label: Text(
                            _categories[index],
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: isSelected ? const Color(0xFFFF6192) : Colors.black, // 텍스트 색상
                              height: 1.2,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategoryIndex = index;
                              _getList();
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
                              // 테두리 색상
                              width: 1.0,
                            ),
                          ),
                          showCheckmark: false, // 체크 표시 없애기
                        ),
                      );
                    },
                  ),
                ),
                const Divider(thickness: 10, color: Color(0xFFF5F9F9)),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: _pointList.length,
                    itemBuilder: (context, index) {
                      // 데이터를 사용하여 아이템 생성
                      final pointData = _pointList[index];

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
                          if (index != _pointList.length - 1)
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
                )
              ],
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
