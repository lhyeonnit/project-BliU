import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/screen/store/viewmodel/ranking_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/screen/store/component/store_style_group_selection.dart';
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

  String selectedAgeGroup = '';
  String selectedStyle = '';
  final ScrollController _scrollController = ScrollController();
  List<bool> isBookmarked = List<bool>.generate(10, (index) => false);

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          selectedAgeGroup: selectedAgeGroup,
          onSelectionChanged: (String newSelection) {
            setState(() {
              selectedAgeGroup = newSelection;
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (selectedAgeGroup.isEmpty) {
      return '연령';
    } else {
      return selectedAgeGroup;
    }
  }

  void _showStyleSelection() {
    showModalBottomSheet(
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
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 16.0, top: 20, right: 16, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 연령 버튼
                    GestureDetector(
                      onTap: _showAgeGroupSelection,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 17, top: 11, bottom: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Color(0xFFDDDDDD)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Text(
                                getSelectedAgeGroupText(), // 선택된 연령대 표시
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle( fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black),
                              ),
                            ),
                            SvgPicture.asset(
                                'assets/images/product/filter_select.svg'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    // 스타일 버튼
                    GestureDetector(
                      onTap: _showStyleSelection,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 17, top: 11, bottom: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Color(0xFFDDDDDD)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                minWidth: 0, // 최소 너비를 0으로 설정 (자유롭게 확장)
                                maxWidth: 93, // 최대 너비를 93으로 설정
                              ),
                              margin: EdgeInsets.only(right: 5),
                              child: Text(
                                getSelectedStyleText(), // 선택된 연령대 표시
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle( fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black),
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

                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: list.length, // 버튼들을 포함해서 하나 더 추가
                  itemBuilder: (context, index) {
                    final rankList = list[index];
                    final rankData = rankList.list?[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   height: Responsive.getHeight(context, 40),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // Navigate to store_detail page when item is tapped
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => const StoreDetailScreen(
                          //               // Pass the store data to the detail screen
                          //               ),
                          //         ),
                          //       );
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Container(
                          //           margin: EdgeInsets.only(right: 10),
                          //           width: Responsive.getWidth(context, 30),
                          //           child: Center(
                          //             child: Text(
                          //               rankData,
                          //               style: TextStyle( fontFamily: 'Pretendard',
                          //                   fontSize:
                          //                       Responsive.getFont(context, 24),
                          //                   fontWeight: FontWeight.w600),
                          //             ),
                          //           ),
                          //         ),
                          //         Flexible(
                          //           flex: 1,
                          //           child: Container(
                          //             child: Row(
                          //               children: [
                          //                 Container(
                          //                   height: 40,
                          //                   width: 40,
                          //                   margin: const EdgeInsets.only(
                          //                       right: 10),
                          //                   decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         const BorderRadius.all(
                          //                             Radius.circular(20)),
                          //                     // 사진의 모서리 둥글게 설정
                          //                     border: Border.all(
                          //                       color: const Color(0xFFDDDDDD),
                          //                       // 테두리 색상 설정
                          //                       width: 1.0, // 테두리 두께 설정
                          //                     ),
                          //                   ),
                          //                   child: ClipRRect(
                          //                     borderRadius:
                          //                         const BorderRadius.all(
                          //                             Radius.circular(20)),
                          //                     // 사진의 모서리만 둥글게 설정
                          //                     child: Image.network(
                          //                       '${rankData.stProfile}',
                          //                       fit: BoxFit.contain,
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Container(
                          //                   child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Text(
                          //                         '${rankData.stName}',
                          //                         style: TextStyle( fontFamily: 'Pretendard',
                          //                           fontSize:
                          //                               Responsive.getFont(
                          //                                   context, 14),
                          //                         ),
                          //                         overflow:
                          //                             TextOverflow.ellipsis,
                          //                       ),
                          //                       Row(
                          //                         children: [
                          //                           Text(
                          //                             '${rankData.stStyleTxt}',
                          //                             style: TextStyle( fontFamily: 'Pretendard',
                          //                                 fontSize: Responsive
                          //                                     .getFont(
                          //                                         context, 13),
                          //                                 color: const Color(
                          //                                     0xFF7B7B7B)),
                          //                             overflow:
                          //                                 TextOverflow.ellipsis,
                          //                           ),
                          //                           Text(
                          //                             '${rankData.stAgeTxt}',
                          //                             style: TextStyle( fontFamily: 'Pretendard',
                          //                                 fontSize: Responsive
                          //                                     .getFont(
                          //                                         context, 13),
                          //                                 color: const Color(
                          //                                     0xFF7B7B7B)),
                          //                             overflow:
                          //                                 TextOverflow.ellipsis,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //         Container(
                          //           width: 50,
                          //           margin: const EdgeInsets.only(
                          //               top: 3, right: 16),
                          //           child: Column(
                          //             children: [
                          //               GestureDetector(
                          //                 onTap: () {
                          //                   setState(() {
                          //                     isBookmarked[index] =
                          //                         !isBookmarked[index];
                          //                   });
                          //                 },
                          //                 child: Container(
                          //                   width: Responsive.getWidth(
                          //                       context, 14),
                          //                   height: Responsive.getHeight(
                          //                       context, 17),
                          //                   margin: EdgeInsets.only(bottom: 3),
                          //                   child: SvgPicture.asset(
                          //                     'assets/images/store/book_mark.svg',
                          //                     color: isBookmarked[index]
                          //                         ? const Color(0xFFFF6192)
                          //                         : null, // 아이콘 색상 변경
                          //                     fit: BoxFit.contain,
                          //                   ),
                          //                 ),
                          //               ),
                          //               // TODO bookmark count check
                          //               Text(
                          //                 '${rankData.stAge}',
                          //                 style: TextStyle( fontFamily: 'Pretendard',
                          //                   color: const Color(0xFFA4A4A4),
                          //                   fontSize:
                          //                       Responsive.getFont(context, 12),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
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
                            // child: SizedBox(
                            //   height: 120,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: rankData.productList?.length,
                            //     itemBuilder: (context, imageIndex) {
                            //       final productImg = rankData.productList?[imageIndex] ?? '';
                            //       return Container(
                            //         width: 120,
                            //         height: 120,
                            //         margin: const EdgeInsets.only(right: 5),
                            //         child: ClipRRect(
                            //           borderRadius: BorderRadius.circular(6),
                            //           // 모서리 둥글게 설정
                            //           child: Image.network(
                            //             '${productImg}',
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    );
                  },
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

    if (isNew) {
      final model = ref.read(storeLankListViewModelProvider);
      model?.storeRankResponseDTO?.list?.clear();
    }

    // TODO 회원 비회원
    // TODO 페이징 처리
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'style': 1,
      'age': 1,
      'pg': 1,
    };

    await ref
        .read(storeLankListViewModelProvider.notifier)
        .getRank(requestData);
  }
}
