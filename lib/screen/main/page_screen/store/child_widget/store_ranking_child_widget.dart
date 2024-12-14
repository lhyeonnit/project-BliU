import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/main/page_screen/store/view_model/store_ranking_view_model.dart';
import 'package:BliU/screen/main/view_model/main_view_model.dart';
import 'package:BliU/screen/modal_dialog/message_dialog.dart';
import 'package:BliU/screen/modal_dialog/store_age_group_selection.dart';
import 'package:BliU/screen/modal_dialog/store_style_group_selection.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class StoreRankingChildWidget extends ConsumerStatefulWidget {
  const StoreRankingChildWidget({super.key});

  @override
  ConsumerState<StoreRankingChildWidget> createState() => StoreRankingChildWidgetState();
}

class StoreRankingChildWidgetState extends ConsumerState<StoreRankingChildWidget> {
  final ScrollController _scrollController = ScrollController();

  double _maxScrollHeight = 0;// NestedScrollView 사용시 최대 높이를 저장하기 위한 변수

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _showAgeGroupSelection() {
    final mainModel = ref.read(mainViewModelProvider);
    final ageCategories = mainModel.ageCategories;

    final viewModel = ref.read(storeRankingViewModelProvider.notifier);
    final model = ref.read(storeRankingViewModelProvider);

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: StoreAgeGroupSelection(
            ageCategories: ageCategories,
            selectedAgeGroup: model.selectedAgeGroup,
            onSelectionChanged: (CategoryData? newSelection) {
              viewModel.setSelectedAgeGroup(newSelection);
              _getList();
            },
          ),
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    final model = ref.read(storeRankingViewModelProvider);
    if (model.selectedAgeGroup == null) {
      return '연령';
    } else {
      return model.selectedAgeGroup?.catName ?? "";
    }
  }

  void _showStyleSelection() {
    final mainModel = ref.read(mainViewModelProvider);
    final styleCategories = mainModel.styleCategories;

    final viewModel = ref.read(storeRankingViewModelProvider.notifier);
    final model = ref.read(storeRankingViewModelProvider);

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxHeight: 400, minHeight: 400),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: StyleSelectionSheet(
            styleCategories: styleCategories,
            selectedStyle: model.selectedStyle,
            onSelectionChanged: (StyleCategoryData? newSelection) {
              viewModel.setSelectedStyle(newSelection);
              _getList(); // 스타일 선택 후 동작
            },
            scrollController: _scrollController, // 스크롤 컨트롤러 전달
          ),
        );
      },
    );
  }

  String getSelectedStyleText() {
    final model = ref.read(storeRankingViewModelProvider);

    if (model.selectedStyle == null) {
      return '스타일';
    } else {
      return model.selectedStyle?.cstName ?? "";
    }
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final model = ref.read(storeRankingViewModelProvider);

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String age = "all";
    if (model.selectedAgeGroup != null) {
      age = '${model.selectedAgeGroup?.catIdx ?? ""}';
    }

    String style = "all";
    if (model.selectedStyle != null) {
      style = "${model.selectedStyle?.fsIdx ?? ""}";
    }

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx ?? "",
      'style': style,
      'age': age,
    };

    return requestData;
  }

  void _getList() async {
    _maxScrollHeight = 0;
    final requestData = await _makeRequestData();
    ref.read(storeRankingViewModelProvider.notifier).listLoad(requestData);
  }

  void _nextLoad() async {
    final requestData = await _makeRequestData();
    ref.read(storeRankingViewModelProvider.notifier).listNextLoad(requestData);
  }

  void _viewWillAppear(BuildContext context) {
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, widget) {
              final model = ref.watch(storeRankingViewModelProvider);
              final listEmpty = model.listEmpty;
              final storeRankList = model.storeRankList;

              return Stack(
                children: [
                  NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        var metrics = scrollNotification.metrics;
                        if (metrics.axisDirection != AxisDirection.down) return false;
                        if (_maxScrollHeight < metrics.maxScrollExtent) {
                          _maxScrollHeight = metrics.maxScrollExtent;
                        }
                        if (_maxScrollHeight - metrics.pixels < 50) {
                          _nextLoad();
                        }
                      }
                      return false;
                    },
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            margin: const EdgeInsets.only(left: 16.0, top: 20, right: 16, bottom: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 연령 버튼
                                GestureDetector(
                                  onTap: _showAgeGroupSelection,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20, right: 17, top: 11, bottom: 11),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19),
                                      border: Border.all(color: const Color(0xFFDDDDDD)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 5),
                                          child: Text(
                                            getSelectedAgeGroupText(), // 선택된 연령대 표시
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              color: Colors.black,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                        SvgPicture.asset('assets/images/product/filter_select.svg'),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                // 스타일 버튼
                                GestureDetector(
                                  onTap: _showStyleSelection,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20, right: 17, top: 11, bottom: 11),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19),
                                      border: Border.all(color: const Color(0xFFDDDDDD)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 0, // 최소 너비를 0으로 설정 (자유롭게 확장)
                                          ),
                                          margin: const EdgeInsets.only(right: 5),
                                          child: Text(
                                            getSelectedStyleText(), // 선택된 연령대 표시
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              color: Colors.black,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                        SvgPicture.asset('assets/images/product/filter_select.svg'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: listEmpty,
                          child: const NonDataScreen(text: '등록된 스토어가 없습니다.',),
                        ),
                        Visibility(
                          visible: !listEmpty,
                          child: Column(
                            children: [
                              ...List.generate(
                                storeRankList.length,
                                    (index) {
                                  final rankData = storeRankList[index];

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: Responsive.getHeight(context, 40),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Navigate to store_detail page when item is tapped
                                              Navigator.pushNamed(context, '/store_detail/${rankData.stIdx ?? 0}');
                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(right: 10),
                                                  constraints: BoxConstraints(
                                                    minWidth: Responsive.getWidth(context, 30),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      // '${rankData.stIdx}',
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: Responsive.getFont(context, 24),
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  margin: const EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    // 사진의 모서리 둥글게 설정
                                                    border: Border.all(
                                                      color: const Color(0xFFDDDDDD),
                                                      // 테두리 색상 설정
                                                      width: 1.0, // 테두리 두께 설정
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    // 사진의 모서리만 둥글게 설정
                                                    child: CachedNetworkImage(
                                                      imageUrl: rankData.stProfile ?? "",
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.contain,
                                                      placeholder: (context, url) {
                                                        return const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      },
                                                      errorWidget: (context, url, error) {
                                                        return SvgPicture.asset(
                                                          'assets/images/no_imge_shop.svg',
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                          fit: BoxFit.fitWidth,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        rankData.stName ?? "",
                                                        style: TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: Responsive.getFont(context, 14),
                                                          height: 1.2,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        "${rankData.stStyleTxt?.split(',').first ?? ""}, ${rankData.stAgeTxt ?? ""}",
                                                        // 쉼표로 분리 후 첫 번째 값만 가져옴
                                                        style: TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: Responsive.getFont(context, 13),
                                                          color: const Color(0xFF7B7B7B),
                                                          height: 1.2,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    // 북마크 토글을 위한 데이터 요청
                                                    final pref = await SharedPreferencesManager.getInstance();
                                                    final mtIdx = pref.getMtIdx() ?? ""; // 사용자 mtIdx 가져오기

                                                    if (mtIdx.isEmpty) {
                                                      if(!context.mounted) return;
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return const MessageDialog(title: "알림", message: "로그인이 필요합니다.",);
                                                        },
                                                      );
                                                      return;
                                                    }

                                                    Map<String, dynamic> requestData = {
                                                      'mt_idx': mtIdx,
                                                      'st_idx': rankData.stIdx, // 상점 인덱스 사용
                                                    };

                                                    // 북마크 토글 함수 호출
                                                    bool result = await ref.read(storeRankingViewModelProvider.notifier).toggleLike(requestData);
                                                    // 북마크 상태 반전 (check_mark 값 반전)
                                                    if (result) {
                                                      setState(() {
                                                        if (rankData.checkMark == "Y") {
                                                          rankData.checkMark = "N";
                                                          rankData.stMark = (rankData.stMark ?? 0) - 1;
                                                        } else {
                                                          rankData.checkMark = "Y";
                                                          rankData.stMark = (rankData.stMark ?? 0) + 1;
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 50,
                                                    margin: const EdgeInsets.only(top: 3, right: 5),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: Responsive.getWidth(context, 14),
                                                          height: Responsive.getHeight(context, 17),
                                                          margin: const EdgeInsets.only(bottom: 3),
                                                          child: rankData.checkMark == "Y" ? SvgPicture.asset(
                                                            'assets/images/store/book_mark.svg',
                                                            colorFilter: const ColorFilter.mode(
                                                              Color(0xFFFF6192),
                                                              BlendMode.srcIn,
                                                            ),
                                                            fit: BoxFit.contain,
                                                          ) : SvgPicture.asset(
                                                            'assets/images/store/book_mark.svg',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${rankData.stMark ?? 0}',
                                                          style: TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            color: const Color(0xFFA4A4A4),
                                                            fontSize: Responsive.getFont(context, 12),
                                                            height: 1.2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (rankData.productList?.length ?? 0) > 0,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                height: 120,
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: rankData.productList?.length ?? 0,
                                                  itemBuilder: (context, imageIndex) {
                                                    final productData = rankData.productList?[imageIndex];

                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Navigate to store_detail page when item is tapped
                                                        Navigator.pushNamed(context, '/product_detail/${productData?.ptIdx}');
                                                      },
                                                      child: Container(
                                                        width: 120,
                                                        height: 120,
                                                        margin: const EdgeInsets.only(right: 5),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(6),
                                                          // 모서리 둥글게 설정
                                                          child: CachedNetworkImage(
                                                            imageUrl: productData?.ptImg ?? '',
                                                            width: double.infinity,
                                                            height: double.infinity,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) {
                                                              return const Center(
                                                                child: CircularProgressIndicator(),
                                                              );
                                                            },
                                                            errorWidget: (context, url, error) {
                                                              return SvgPicture.asset(
                                                                'assets/images/no_imge.svg',
                                                                width: double.infinity,
                                                                height: double.infinity,
                                                                fit: BoxFit.fitWidth,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: ((storeRankList.length - 1) == index && (rankData.productList?.length ?? 0) == 0) ? true : false,
                                          child: const SizedBox(
                                            height: 40,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  MoveTopButton(scrollController: _scrollController),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
