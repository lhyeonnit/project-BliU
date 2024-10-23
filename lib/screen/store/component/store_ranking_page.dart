import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/store_rank_data.dart';
import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/screen/_component/message_dialog.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/screen/store/component/store_style_group_selection.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/screen/store/viewmodel/ranking_view_model.dart';
import 'package:BliU/screen/store/viewmodel/store_favorite_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreRakingPage extends ConsumerStatefulWidget {
  const StoreRakingPage({super.key});

  @override
  ConsumerState<StoreRakingPage> createState() => StoreRakingPageState();
}

class StoreRakingPageState extends ConsumerState<StoreRakingPage> {
  final ScrollController _scrollController = ScrollController();

  late List<CategoryData> _ageCategories;
  late List<StyleCategoryData> _styleCategories;

  List<StoreRankData> storeRankList = [];

  CategoryData? _selectedAgeGroup;
  StyleCategoryData? _selectedStyle;

  double _maxScrollHeight = 0;// NestedScrollView 사용시 최대 높이를 저장하기 위한 변수

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          ageCategories: _ageCategories,
          selectedAgeGroup: _selectedAgeGroup,
          onSelectionChanged: (CategoryData? newSelection) {
            setState(() {
              _selectedAgeGroup = newSelection;
              _getList();
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (_selectedAgeGroup == null) {
      return '연령';
    } else {
      return _selectedAgeGroup?.catName ?? "";
    }
  }

  void _showStyleSelection() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxHeight: 400, minHeight: 400),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StyleSelectionSheet(
          styleCategories: _styleCategories,
          selectedStyle: _selectedStyle,
          onSelectionChanged: (StyleCategoryData? newSelection) {
            setState(() {
              _selectedStyle = newSelection;
              _getList(); // 스타일 선택 후 동작
            });
          },
          scrollController: _scrollController, // 스크롤 컨트롤러 전달
        );
      },
    );
  }

  String getSelectedStyleText() {
    if (_selectedStyle == null) {
      return '스타일';
    } else {
      return _selectedStyle?.cstName ?? "";
    }
  }

  void _afterBuild(BuildContext context) {
    _getFilterCategory();
    _getList();
  }

  void _getFilterCategory() async {
    final ageCategoryResponseDTO = await ref.read(storeLankListViewModelProvider.notifier).getAgeCategory();
    _ageCategories = ageCategoryResponseDTO?.list ?? [];

    final styleCategoryResponseDTO = await ref.read(storeLankListViewModelProvider.notifier).getStyleCategory();
    _styleCategories = styleCategoryResponseDTO?.list ?? [];
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;
    _maxScrollHeight = 0;
    _hasNextPage = true;

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String age = "all";
    if (_selectedAgeGroup != null) {
      age = '${_selectedAgeGroup?.catIdx ?? ""}';
    }

    String style = "all";
    if (_selectedStyle != null) {
      style = "${_selectedStyle?.fsIdx ?? ""}";
    }

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx ?? "",
      'style': style,
      'age': age,
      'pg': _page,
    };

    setState(() {
      storeRankList = [];
    });

    final storeRankResponseDTO = await ref.read(storeLankListViewModelProvider.notifier).getRank(requestData); // 서버에서 데이터 가져오기
    storeRankList = storeRankResponseDTO?.list ?? [];

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {
    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();

      String age = "all";
      if (_selectedAgeGroup != null) {
        age = '${_selectedAgeGroup?.catIdx ?? ""}';
      }

      String style = "all";
      if (_selectedStyle != null) {
        style = "${_selectedStyle?.fsIdx ?? ""}";
      }

      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx ?? "",
        'style': style,
        'age': age,
        'pg': _page,
      };
      final storeRankResponseDTO = await ref.read(storeLankListViewModelProvider.notifier).getRank(requestData); // 서버에서 데이터 가져오기
      if (storeRankResponseDTO != null) {
        if ((storeRankResponseDTO.list ?? []).isNotEmpty) {
          setState(() {
            storeRankList.addAll(storeRankResponseDTO.list ?? []);
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
      body: SafeArea(
        child: Stack(
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
                  Column(
                    children: [
                      ...List.generate(storeRankList.length, (index) {
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoreDetailScreen(stIdx: rankData.stIdx ?? 0,),
                                      ),
                                    );
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
                                          child: Image.network(
                                              rankData.stProfile ?? "",
                                              fit: BoxFit.cover,
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return const SizedBox();
                                              }
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
                                                }
                                            );
                                            return;
                                          }

                                          Map<String, dynamic> requestData = {
                                            'mt_idx': mtIdx,
                                            'st_idx': rankData.stIdx, // 상점 인덱스 사용
                                          };

                                          // 북마크 토글 함수 호출
                                          await ref.read(storeFavoriteViewModelProvider.notifier).toggleLike(requestData);
                                          // 북마크 상태 반전 (check_mark 값 반전)
                                          setState(() {
                                            if (rankData.checkMark == "Y") {
                                              rankData.checkMark = "N";
                                              rankData.stMark = (rankData.stMark ?? 0) - 1;
                                            } else {
                                              rankData.checkMark = "Y";
                                              rankData.stMark = (rankData.stMark ?? 0) + 1;
                                            }
                                          });
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProductDetailScreen(ptIdx: productData?.ptIdx),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 120,
                                              height: 120,
                                              margin: const EdgeInsets.only(right: 5),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                // 모서리 둥글게 설정
                                                child: Image.network(
                                                  productData?.ptImg ?? '',
                                                  // null인 경우 빈 문자열을 처리
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Icon(Icons.error); // 이미지 로딩에 실패한 경우 표시할 위젯
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
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            MoveTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }
}
