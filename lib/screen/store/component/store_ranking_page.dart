import 'package:BliU/data/category_data.dart';
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
  _StoreRakingPageState createState() => _StoreRakingPageState();
}

class _StoreRakingPageState extends ConsumerState<StoreRakingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  late List<CategoryData> ageCategories;
  CategoryData? selectedAgeGroup;
  String selectedStyle = '';
  final ScrollController _scrollController = ScrollController();

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          ageCategories: ageCategories,
          selectedAgeGroup: selectedAgeGroup,
          onSelectionChanged: (CategoryData? newSelection) {
            setState(() {
              selectedAgeGroup = newSelection;
              _getList(true);
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (selectedAgeGroup == null) {
      return '연령';
    } else {
      return selectedAgeGroup?.catName ?? "";
    }
  }

  void _showStyleSelection() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StyleSelectionSheet(
          selectedStyle: selectedStyle,
          onSelectionChanged: (String newSelection) {
            setState(() {
              selectedStyle = newSelection;
            });
          },
        );
      },
    );
  }

  String getSelectedStyleText() {
    if (selectedStyle.isEmpty) {
      return '스타일';
    } else {
      return selectedStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              Container(
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
                          borderRadius: BorderRadius.circular(22),
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
                    const SizedBox(width: 4.0),
                    // 스타일 버튼
                    GestureDetector(
                      onTap: _showStyleSelection,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, right: 17, top: 11, bottom: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                minWidth: 0, // 최소 너비를 0으로 설정 (자유롭게 확장)
                                maxWidth: 93, // 최대 너비를 93으로 설정
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
                            SvgPicture.asset(
                                'assets/images/product/filter_select.svg'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(builder: (context, ref, widget) {
                final model = ref.watch(storeLankListViewModelProvider);
                final list = model?.storeRankResponseDTO?.list ?? [];

                return Column(
                  children: [
                    ...List.generate(list.length, (index) {
                      final rankData = list[index];

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
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: Responsive.getWidth(context, 30),
                                      child: Center(
                                        child: Text(
                                          '${rankData.stIdx}',
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
                                            fit: BoxFit.contain,
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
                                    Container(
                                      width: 50,
                                      margin: const EdgeInsets.only(top: 3, right: 5),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              // 북마크 토글을 위한 데이터 요청
                                              final pref = await SharedPreferencesManager.getInstance();
                                              final mtIdx = pref
                                                  .getMtIdx(); // 사용자 mtIdx 가져오기
                                              Map<String, dynamic> requestData = {
                                                'mt_idx': mtIdx,
                                                'st_idx': rankData.stIdx, // 상점 인덱스 사용
                                              };

                                              // 북마크 토글 함수 호출
                                              await ref.read(storeFavoriteViewModelProvider.notifier).toggleLike(requestData);
                                              // 북마크 상태 반전 (check_mark 값 반전)
                                              setState(() {
                                                rankData.checkMark = rankData.checkMark == "Y" ? "N" : "Y";
                                              });
                                            },
                                            child: Container(
                                              width: Responsive.getWidth(context, 14),
                                              height: Responsive.getHeight(context, 17),
                                              margin: const EdgeInsets.only(bottom: 3),
                                              child: SvgPicture.asset(
                                                'assets/images/store/book_mark.svg',
                                                color: rankData.checkMark == "Y" // 북마크가 활성화된 경우 색상 설정
                                                    ? const Color(0xFFFF6192)
                                                    : null, // 비활성화된 경우 기본 색상
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${rankData.stAge}',
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
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to store_detail page when item is tapped
                                // TODO 이동 수정
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductDetailScreen(ptIdx: 3),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: rankData.productList?.length ?? 0,
                                  // 리스트가 null인 경우 안전하게 처리
                                  itemBuilder: (context, imageIndex) {
                                    final productImg = rankData.productList?[
                                        imageIndex]; // 각 이미지 URL을 가져옴
                                    return Container(
                                      width: 120,
                                      height: 120,
                                      margin: const EdgeInsets.only(right: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        // 모서리 둥글게 설정
                                        child: Image.network(
                                          productImg ?? '',
                                          // null인 경우 빈 문자열을 처리
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons
                                                .error); // 이미지 로딩에 실패한 경우 표시할 위젯
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getList(true);
  }

  void _getList(bool isNew) async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    // 회원 여부에 따라 처리 (비회원도 처리 가능)
    if (mtIdx == null || mtIdx.isEmpty) {
      // 비회원 처리 (예: 비회원용 메시지나 기본값 설정)
      print('비회원');
    } else {
      print('회원 mtIdx: $mtIdx');
    }

    // TODO 페이징 처리도 추가
    // TODO 검색 파라미터 추가
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'style': "all", // 예시로 스타일을 1로 설정
      'age': "all", // 예시로 연령대를 1로 설정
      'pg': 1, // 첫 페이지
    };
    final ageCategoryResponseDTO = await ref.read(storeLankListViewModelProvider.notifier).getAgeCategory();
    if (ageCategoryResponseDTO != null) {
      if (ageCategoryResponseDTO.result == true) {
        ageCategories = ageCategoryResponseDTO.list ?? [];
      }
    }
    await ref
        .read(storeLankListViewModelProvider.notifier)
        .getRank(requestData); // 서버에서 데이터 가져오기
  }
}
