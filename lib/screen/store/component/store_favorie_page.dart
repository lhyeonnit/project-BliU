import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final int totalPages = (favoriteStores.length / itemsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '즐겨찾기 ${favoriteStores.length}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 360, // 즐겨찾기 항목의 고정된 높이
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
                              child: Row(
                                children: [
                                  // 로고 이미지
                                  Image.asset(
                                    'assets/images/store/brand_logo.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.contain,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          displayedStores[index]
                                              ['description']!,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 즐겨찾기 아이콘과 스크랩 수
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Column(
                                      children: [
                                        Icon(Icons.bookmark,
                                            color: Colors.pink),
                                        Text(
                                          displayedStores[index]['scrapCount']!,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: currentPage == index ? 8.0 : 5.0,
                        height: currentPage == index ? 8.0 : 5.0,
                        decoration: BoxDecoration(
                          color:
                              currentPage == index ? Colors.black : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '즐겨찾기한 스토어 상품 검색',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: StoreCategory(), // 내부 스크롤 가능한 카테고리 및 그리드뷰
      ),
    );
  }
}
