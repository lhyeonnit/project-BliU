import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/screen/store/component/store_style_group_selection.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../dummy/store_ranking.dart';

class StoreRakingPage extends StatefulWidget {
  const StoreRakingPage({super.key});

  @override
  _StoreRakingPageState createState() => _StoreRakingPageState();
}

class _StoreRakingPageState extends State<StoreRakingPage> {
  List<String> selectedAgeGroups = [];
  List<String> selectedStyles = [];
  final ScrollController _scrollController = ScrollController();
  List<bool> isBookmarked = List<bool>.generate(10, (index) => false);

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          selectedAgeGroups: selectedAgeGroups,
          onSelectionChanged: (List<String> newSelection) {
            setState(() {
              selectedAgeGroups = newSelection;
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupsText() {
    if (selectedAgeGroups.isEmpty) {
      return '연령';
    } else {
      return selectedAgeGroups.join(', ');
    }
  }

  void _showStyleSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StyleSelectionSheet(
          selectedStyles: selectedStyles,
          onSelectionChanged: (List<String> newSelection) {
            setState(() {
              selectedStyles = newSelection;
            });
          },
        );
      },
    );
  }

  String getSelectedStylesText() {
    if (selectedStyles.isEmpty) {
      return '스타일';
    } else {
      return selectedStyles.join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: stores.length + 1, // 버튼들을 포함해서 하나 더 추가
            itemBuilder: (context, index) {
              if (index == 0) {
                // 첫 번째 항목은 버튼들로 사용
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 20),
                  child: Row(
                    children: [
                      // 연령 버튼
                      Flexible(
                        child: OutlinedButton(
                          onPressed: _showAgeGroupSelection,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white, // 배경 흰색
                            side: const BorderSide(color: Color(0xFFDDDDDD)), // 테두리 회색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                          child: SizedBox(
                            height: Responsive.getHeight(context, 38),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    getSelectedAgeGroupsText(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: Responsive.getFont(context, 14),
                                        color: Colors.black), // 글자색 검은색
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                SvgPicture.asset(
                                    'assets/images/product/filter_select.svg'),
                                // 아이콘도 검은색
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      // 스타일 버튼
                      Flexible(
                        child: OutlinedButton(
                          onPressed: _showStyleSelection,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white, // 배경 흰색
                            side: const BorderSide(color: Color(0xFFDDDDDD)), // 테두리 회색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  getSelectedStylesText(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black), // 글자색 검은색
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              SvgPicture.asset(
                                  'assets/images/product/filter_select.svg'),
                              // 아이콘도 검은색
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // 나머지 항목들은 상점 랭킹
                final storeIndex = index - 1; // store 리스트의 인덱스는 0부터 시작해야 함
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    height: 184,
                    margin: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Responsive.getHeight(context, 40),
                          width: Responsive.getWidth(context, 378),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to store_detail page when item is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StoreDetailScreen(
                                    // Pass the store data to the detail screen
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Responsive.getWidth(context, 30),
                                  child: Center(
                                    child: Text(
                                      '${stores[storeIndex]['rank']}',
                                      style: TextStyle(
                                          fontSize: Responsive.getFont(context, 24),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)), // 사진의 모서리 둥글게 설정
                                          border: Border.all(
                                            color: const Color(0xFFDDDDDD), // 테두리 색상 설정
                                            width: 1.0, // 테두리 두께 설정
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)), // 사진의 모서리만 둥글게 설정
                                          child: Image.asset(
                                            'assets/images/home/exhi.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                stores[storeIndex]['name'],
                                                style: TextStyle(
                                                  fontSize: Responsive.getFont(context, 14),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                stores[storeIndex]['description'],
                                                style: TextStyle(
                                                    fontSize: Responsive.getFont(context, 13),
                                                    color: const Color(0xFF7B7B7B)),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Responsive.getWidth(context, 75)),
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isBookmarked[storeIndex] =
                                            !isBookmarked[storeIndex];
                                          });
                                        },
                                        child: SizedBox(
                                          width: Responsive.getWidth(context, 14),
                                          height: Responsive.getHeight(context, 17),
                                          child: SvgPicture.asset(
                                            'assets/images/store/book_mark.svg',
                                            color: isBookmarked[storeIndex]
                                                ? const Color(0xFFFF6192)
                                                : null, // 아이콘 색상 변경
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Responsive.getHeight(context, 2),),
                                      Text(
                                        stores[storeIndex]['scrapCount']!,
                                        style: TextStyle(
                                          color: const Color(0xFFA4A4A4),
                                          fontSize: Responsive.getFont(context, 12),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductDetailScreen(),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: stores[storeIndex]['images'].length,
                              itemBuilder: (context, imageIndex) {
                                return Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6), // 모서리 둥글게 설정
                                    child: Image.asset(
                                      stores[storeIndex]['images'][imageIndex],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
