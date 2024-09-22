import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/screen/store/component/store_style_group_selection.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreRakingPage extends StatefulWidget {
  const StoreRakingPage({super.key});

  @override
  _StoreRakingPageState createState() => _StoreRakingPageState();
}

final List<Map<String, dynamic>> stores = List.generate(10, (index) {
  return {
    'rank': index + 1,
    'logo': 'assets/images/store/brand_logo@2x.png', // 임시 로고 이미지 URL
    'name': '가게 이름 $index',
    'description': '스포티 (Sporty),',
    'scrapCount': '175만',
    'images': [
      'assets/images/store/store_detail.png',
      'assets/images/store/store_detail.png',
      'assets/images/store/store_detail.png',
      'assets/images/store/store_detail.png',
    ]
  };
});

class _StoreRakingPageState extends State<StoreRakingPage> {
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

  String getSelectedAgeGroupsText() {
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

  String getSelectedStylesText() {
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
          ListView.builder(
            controller: _scrollController,
            itemCount: stores.length + 1, // 버튼들을 포함해서 하나 더 추가
            itemBuilder: (context, index) {
              if (index == 0) {
                // 첫 번째 항목은 버튼들로 사용
                return Container(
                  margin: const EdgeInsets.only(left: 16.0, top: 20),
                  child: Row(
                    children: [
                      // 연령 버튼
                      Flexible(
                        child: GestureDetector(
                          onTap: _showAgeGroupSelection,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 17, top: 11, bottom: 11),
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
                                    '연령', // 선택된 연령대 표시
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
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
                      ),
                      const SizedBox(width: 4.0),
                      // 스타일 버튼
                      Flexible(
                        child: GestureDetector(
                          onTap: _showStyleSelection,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 17, top: 11, bottom: 11),
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
                                    '스타일', // 선택된 연령대 표시
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
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
                      ),
                    ],
                  ),
                );
              } else {
                // 나머지 항목들은 상점 랭킹
                final storeIndex = index - 1; // store 리스트의 인덱스는 0부터 시작해야 함
                return Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Responsive.getHeight(context, 40),
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
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: Responsive.getWidth(context, 30),
                                child: Center(
                                  child: Text(
                                    '${stores[storeIndex]['rank']}',
                                    style: TextStyle(
                                        fontSize:
                                            Responsive.getFont(context, 24),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          // 사진의 모서리 둥글게 설정
                                          border: Border.all(
                                            color: const Color(0xFFDDDDDD),
                                            // 테두리 색상 설정
                                            width: 1.0, // 테두리 두께 설정
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          // 사진의 모서리만 둥글게 설정
                                          child: Image.asset(
                                            'assets/images/home/exhi.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              stores[storeIndex]['name'],
                                              style: TextStyle(
                                                fontSize: Responsive.getFont(
                                                    context, 14),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              stores[storeIndex]['description'],
                                              style: TextStyle(
                                                  fontSize: Responsive.getFont(
                                                      context, 13),
                                                  color:
                                                      const Color(0xFF7B7B7B)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 30,
                                margin: const EdgeInsets.only(top: 3, right: 16),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isBookmarked[storeIndex] =
                                              !isBookmarked[storeIndex];
                                        });
                                      },
                                      child: Container(
                                        width: Responsive.getWidth(context, 14),
                                        height:
                                            Responsive.getHeight(context, 17),
                                        child: SvgPicture.asset(
                                          'assets/images/store/book_mark.svg',
                                          color: isBookmarked[storeIndex]
                                              ? const Color(0xFFFF6192)
                                              : null, // 아이콘 색상 변경
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      stores[storeIndex]['scrapCount']!,
                                      style: TextStyle(
                                        color: const Color(0xFFA4A4A4),
                                        fontSize:
                                            Responsive.getFont(context, 12),
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
                            itemCount: stores[storeIndex]['images'].length,
                            itemBuilder: (context, imageIndex) {
                              return Container(
                                width: 120,
                                height: 120,
                                margin: const EdgeInsets.only(right: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  // 모서리 둥글게 설정
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
