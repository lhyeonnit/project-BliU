//검색
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> _searchHistory = [];
  final ScrollController _scrollController = ScrollController();

  final List<String> _popularSearches = [
    '레인부츠',
    '새학기 등록',
    '여름옷',
    '썸머룩',
    '레인코트',
    '동원록',
    '수영복',
    '원피스',
    '가디건',
    '래시가드'
  ];
  final List<String> _suggestedItems = [
    '우이동금순 안나 도션 레이스 베스트',
    '우이동금순 바디수트',
    '미니초원 후드티',
  ];
  final TextEditingController _searchController = TextEditingController();

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

  _clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.clear();
      prefs.remove('searchHistory');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
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
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        title: SizedBox(
          width: double.infinity,
          height: 56,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(decorationThickness: 0),
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 16, bottom: 8),
                            labelStyle: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                            ),
                            hintText: '검색어를 입력해 주세요',
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
                            suffixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
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
                        padding: const EdgeInsets.only(top: 8,left: 10, bottom: 8, right: 15),
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
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/product/ic_smart.svg"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_searchHistory.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Text('검색기록이 없습니다.',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                if (_searchHistory.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '최근 검색어',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: _clearSearchHistory,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset('assets/images/ic_delet.svg'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '전체삭제',
                                  style: TextStyle(
                                      fontSize:
                                          Responsive.getFont(context, 14)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Wrap(
                    spacing: Responsive.getWidth(context, 4),
                    // 검색어들 간의 가로 간격
                    runSpacing: Responsive.getHeight(context, 8),
                    // 검색어들 간의 세로 간격
                    children: _searchHistory.map((search) {
                      return Chip(
                        padding: EdgeInsets.symmetric(
                          vertical: 11,
                          horizontal: Responsive.getWidth(context, 20),
                        ),
                        labelPadding: const EdgeInsets.only(right: 5),
                        // 텍스트와 아이콘 사이 간격
                        label: Text(
                          search,
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.black,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19), // 둥근 모서리 설정
                          side: const BorderSide(
                            color: Color(0xFFDDDDDD), // 테두리 색상 설정
                          ),
                        ),
                        backgroundColor: Colors.white,
                        // 배경 색상
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Color(0xFFACACAC), // 닫기 아이콘 색상
                        ),
                        onDeleted: () {
                          setState(() {
                            _searchHistory.remove(search); // 삭제 기능
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 40.0),
                SizedBox(
                  width: Responsive.getWidth(context, 380),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인기 검색어',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 18),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _popularSearches.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 9,
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: Responsive.getWidth(context, 185),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 15),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: Responsive.getWidth(context, 10),
                                ),
                                Text(
                                  _popularSearches[index],
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                Text(
                  '이런 아이템은 어떠세요?',
                  style: TextStyle(
                      fontSize: Responsive.getFont(context, 18),
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: SizedBox(
                    height: Responsive.getHeight(context, 253),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10, // 리스트의 길이를 사용
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductDetailScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.only(right: 12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5)),
                                  child: Image.asset(
                                    'assets/images/home/exhi.png',
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: Responsive.getHeight(context, 12),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '꿈꾸는데이지',
                                      style: TextStyle(
                                          fontSize:
                                              Responsive.getFont(context, 12),
                                          color: Colors.grey),
                                    ),
                                    SizedBox(
                                        height:
                                            Responsive.getHeight(context, 4)),
                                    const Text(
                                      '꿈꾸는 데이지 안나 토션 레이스 베스트',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: Responsive.getHeight(context, 12),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '15%',
                                          style: TextStyle(
                                            fontSize:
                                                Responsive.getFont(context, 14),
                                            color: const Color(0xFFFF6192),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '32,800원',
                                          style: TextStyle(
                                            fontSize:
                                                Responsive.getFont(context, 14),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
