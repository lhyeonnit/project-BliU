import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchNoResult extends StatefulWidget {
  const SearchNoResult({super.key});

  @override
  State<SearchNoResult> createState() => _SearchNoResultState();
}

class _SearchNoResultState extends State<SearchNoResult> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
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
                              fontFamily: 'Pretendard',
                              decorationThickness: 0,
                              fontSize: Responsive.getFont(context, 14)),
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 16, bottom: 8),
                            labelStyle: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                            ),
                            hintText: '검색어를 입력해 주세요',
                            hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
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
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _searchController.clear();
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
      body: Container(
        margin: EdgeInsets.only(top: 130),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 90,
                  height: 90,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F9F9),
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/product/ic_top_sch.svg',
                    height: 50,
                    width: 50,
                  )),
              Container(
                margin: const EdgeInsets.only(top: 25, bottom: 10),
                child: Text('검색하신 결과가 없습니다.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 18),
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Text('다른 내용으로 검색해보세요.',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: const Color(0xFFA4A4A4),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
