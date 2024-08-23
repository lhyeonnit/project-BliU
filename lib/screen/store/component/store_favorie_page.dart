import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dummy/store_favorie.dart';
import 'detail/store_category.dart';

class StoreFavoriePage extends StatefulWidget {
  const StoreFavoriePage({super.key});

  @override
  _StoreFavoritePageState createState() => _StoreFavoritePageState();
}

class _StoreFavoritePageState extends State<StoreFavoriePage> {
  final int itemsPerPage = 5;
  int currentPage = 0;
  final PageController _pageController = PageController();
  List<bool> isBookmarked = List<bool>.generate(70, (index) => false);
  ScrollController _scrollController = ScrollController();

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  _saveSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.add(search);
      prefs.setStringList('searchHistory', _searchHistory);
    });
  }

  List<String> _searchHistory = [];

  @override
  Widget build(BuildContext context) {
    final int totalPages = (favoriteStores.length / itemsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, top: 20),
                child: Text(
                  '즐겨찾기 ${favoriteStores.length}',
                  style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 305, // 즐겨찾기 항목의 고정된 높이
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * itemsPerPage;
                    final endIndex = startIndex + itemsPerPage;
                    final displayedStores = favoriteStores.sublist(
                      startIndex,
                      endIndex > favoriteStores.length
                          ? favoriteStores.length
                          : endIndex,
                    );
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: displayedStores.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // 상점 상세 화면으로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoreDetailScreen(),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15, left: 16),
                            child: Row(
                              children: [
                                // 로고 이미지
                                Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    // 사진의 모서리 둥글게 설정
                                    border: Border.all(
                                      color: Color(0xFFDDDDDD),
                                      // 테두리 색상 설정
                                      width: 1.0, // 테두리 두께 설정
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    // 사진의 모서리만 둥글게 설정
                                    child: Image.asset(
                                      'assets/images/home/exhi.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                // 상점 이름과 설명
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayedStores[index]['name']!,
                                        style: TextStyle(
                                          fontSize:
                                              Responsive.getFont(context, 14),
                                        ),
                                      ),
                                      Text(
                                        displayedStores[index]['description']!,
                                        style: TextStyle(
                                            fontSize:
                                                Responsive.getFont(context, 13),
                                            color: Color(0xFF7B7B7B)),
                                      ),
                                    ],
                                  ),
                                ),
                                // 즐겨찾기 아이콘과 스크랩 수
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isBookmarked[index] =
                                                !isBookmarked[index];
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                            'assets/images/store/book_mark.svg',
                                            color: isBookmarked[index]
                                                ? null
                                                : Color(0xFFFF6192),
                                            // 아이콘 색상 변경
                                            height: Responsive.getHeight(
                                                context, 30),
                                            width: Responsive.getWidth(
                                                context, 30),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 14,
                                        child: Text(
                                          displayedStores[index]['scrapCount']!,
                                          style: TextStyle(
                                            color: Color(0xFFA4A4A4),
                                            fontSize:
                                                Responsive.getFont(context, 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPages, (index) {
                  return Container(
                    margin: EdgeInsets.only(right: 6),
                    width: currentPage == index ? 6.0 : 4.0,
                    height: currentPage == index ? 6.0 : 4.0,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? Colors.black
                          : Color(0xFFDDDDDD),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 44,
                width: Responsive.getWidth(context, 380),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xFFE1E1E1))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(decorationThickness: 0),
                        controller: _searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 16, bottom: 8),
                          hintText: '즐겨찾기한 스토어 상품 검색',
                          hintStyle: TextStyle(
                            color: Color(0xFF595959),
                            fontSize: Responsive.getFont(context, 14),
                          ),
                          border: InputBorder.none,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/ic_word_del.svg',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : null,
                          suffixIconConstraints:
                              BoxConstraints.tight(Size(24, 24)),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _saveSearch(value);
                            _searchController.clear();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          String search = _searchController.text;
                          if (search.isNotEmpty) {
                            _saveSearch(search);
                            _searchController.clear();
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/images/home/ic_top_sch_w.svg',
                          color: Colors.black,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StoreCategory(),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
