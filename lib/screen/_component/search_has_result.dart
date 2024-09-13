import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHasResult extends StatefulWidget {
  const SearchHasResult({super.key});

  @override
  State<SearchHasResult> createState() => _SearchHasResultState();
}

class _SearchHasResultState extends State<SearchHasResult> {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16,vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('상품 128,123', style: TextStyle(fontSize: Responsive.getFont(context, 14)),),
                  GridView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 15.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: 0.5,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    //itemCount: model.productList!.length,
                    itemCount: 20,
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
                          width: 184,
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
                                  height: 184,
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
                                        fontSize: Responsive.getFont(context, 12),
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                      height: Responsive.getHeight(context, 4)),
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
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '15%',
                                        style: TextStyle(
                                          fontSize: Responsive.getFont(context, 14),
                                          color: const Color(0xFFFF6192),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '32,800원',
                                        style: TextStyle(
                                          fontSize: Responsive.getFont(context, 14),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/home/item_like.svg',
                                    width: Responsive.getWidth(context, 13),
                                    height: Responsive.getHeight(context, 11),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '13,000',
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 12),
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    'assets/images/home/item_comment.svg',
                                    width: Responsive.getWidth(context, 13),
                                    height: Responsive.getHeight(context, 12),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '49',
                                    style: TextStyle(
                                      fontSize: Responsive.getFont(context, 12),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
