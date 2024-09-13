import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_has_result.dart';
import 'package:BliU/screen/_component/search_no_result.dart';
import 'package:BliU/screen/_component/search_recommend_item.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Map<String, String>> _suggestions = [];

  final List<Map<String, String>> _allSuggestions = [
    {"type": "store", "name": "밀크마일", "logo": "assets/images/home/exhi.png"},
    {
      "type": "store",
      "name": "밀크마일 베이비",
      "logo": "assets/images/home/exhi.png"
    },
    {
      "type": "search",
      "name": "후리스 자켓",
      "logo": "assets/images/home/sch_front.png"
    },
    {
      "type": "search",
      "name": "후리스 세트",
      "logo": "assets/images/home/sch_front.png"
    },
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

  _filterSuggestions(String query) {
    List<Map<String, String>> filteredSuggestions =
        _allSuggestions.where((item) {
      return item["name"]!.toLowerCase().contains(query.toLowerCase()) ||
          item["type"]!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _suggestions = filteredSuggestions;
    });
  }

  Widget _buildHighlightedText(String text, String query) {
    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    query = query.toLowerCase();

    // 검색어와 일치하는 텍스트 부분을 강조
    while (
        (indexOfHighlight = text.toLowerCase().indexOf(query, start)) != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: TextStyle(color: Colors.black),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(indexOfHighlight, indexOfHighlight + query.length),
        style: TextStyle(color: Color(0xFFFF6192)),
      ));
      start = indexOfHighlight + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(color: Colors.black),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(fontSize: Responsive.getFont(context, 14)),
      ),
    );
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
                          style: TextStyle(
                              decorationThickness: 0,
                              fontSize: Responsive.getFont(context, 14)),
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 16, bottom: 8),
                            labelStyle: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                            ),
                            hintText: '검색어를 입력해 주세요',
                            hintStyle: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                                color: Color(0xFF595959)),
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
                                BoxConstraints.tight(const Size(24, 24)),
                          ),
                          onChanged: (value) {
                            _filterSuggestions(value);
                          },
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _saveSearch(value);
                              _searchController.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchNoResult(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 10, bottom: 8, right: 15),
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
          GestureDetector(
            child: Container(
                margin: EdgeInsets.only(right: 16),
                child: SvgPicture.asset("assets/images/product/ic_smart.svg")),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const SearchScreen(),
              //   ),
              // );
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
                if (_searchHistory.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '최근 검색어',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: _clearSearchHistory,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/images/ic_delet.svg'),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text('전체삭제',
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 4,
                    runSpacing: 8,
                    children: _searchHistory.map((search) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.text =
                                search; // 검색 기록 누르면 텍스트 창에 반영
                          });
                        },
                        child: Container(
                          height: 38,
                          child: Chip(
                            label: Text(
                              search,
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 14),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                              side: const BorderSide(
                                color: Color(0xFFDDDDDD),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            deleteIcon: const Icon(Icons.close,
                                color: Color(0xFFACACAC)),
                            onDeleted: () {
                              setState(() {
                                _searchHistory.remove(search); // 삭제 기능
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (_suggestions.isEmpty) ...[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      '인기 검색어',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _popularSearches.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 9,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.text = _popularSearches[index];
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 25,
                              child: Text('${index + 1}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Text(
                              _popularSearches[index],
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                SearchRecommendItem(),
              ],
            ),
          ),
          if (_suggestions.isNotEmpty)
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          border: Border.all(color: Color(0xFFDDDDDD)),
                        ),
                        child: ClipOval(
                            child: Image.asset(
                          _suggestions[index]["logo"]!,
                          fit: BoxFit.cover,
                        ))),
                    title: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: _buildHighlightedText(
                          _suggestions[index]["name"]!, _searchController.text),
                    ),
                    onTap: () {
                      setState(() {
                        _searchController.text = _suggestions[index]["name"]!;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoreDetailScreen(),
                          ),
                        );
                      });
                    },
                  );
                },
              ),
            ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
