import 'package:BliU/screen/store/store_detail_screen.dart';
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

  String getSelectedAgeGroupsText() {
    if (selectedAgeGroups.isEmpty) {
      return '연령';
    } else {
      return selectedAgeGroups.join(', ');
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16),
            child: Row(
              children: [
                // 연령 버튼
                Flexible(
                  child: OutlinedButton(
                    onPressed: _showAgeGroupSelection,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white, // 배경 흰색
                      side: BorderSide(color: Colors.grey), // 테두리 회색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 텍스트에 맞게 크기 조정
                      children: [
                        Flexible(
                          child: Text(
                            getSelectedAgeGroupsText(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.black), // 글자색 검은색
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                        // 아이콘도 검은색
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // 스타일 버튼
                Flexible(
                  child: OutlinedButton(
                    onPressed: _showStyleSelection,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white, // 배경 흰색
                      side: BorderSide(color: Colors.grey), // 테두리 회색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 텍스트에 맞게 크기 조정
                      children: [
                        Flexible(
                          child: Text(
                            getSelectedStylesText(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.black), // 글자색 검은색
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                        // 아이콘도 검은색
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to store_detail page when item is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreDetailScreen(
                            // Pass the store data to the detail screen
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${stores[index]['rank']}',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Image.asset(
                              'assets/images/store/brand_logo.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stores[index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    stores[index]['description'],
                                    style: TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // 여기에 onTap 동작을 추가하세요.
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 17,
                                      height: 17,
                                      child: SvgPicture.asset(
                                        'assets/images/store/book_mark.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  stores[index]['scrapCount']!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Add space between rows and image carousel
                        Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: stores[index]['images'].length,
                            itemBuilder: (context, imageIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Image.asset(
                                    stores[index]['images'][imageIndex],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
