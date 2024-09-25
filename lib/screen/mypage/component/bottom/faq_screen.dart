import 'package:BliU/data/faq_category_data.dart';
import 'package:BliU/data/faq_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/viewmodel/faq_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAQScreen extends ConsumerStatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends ConsumerState<FAQScreen> {
  List<FaqCategoryData> faqCategories = [
    FaqCategoryData(fcIdx: -1, cftName: "전체")
  ];
  List<FaqData> faqDataList = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int pg = 0;

  int selectedCategoryIndex = 0;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('FAQ'),
        titleTextStyle: TextStyle( fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
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
      ),
      body: Stack(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    height: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Color(0xFFE1E1E1))),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle( fontFamily: 'Pretendard',
                                decorationThickness: 0,
                                fontSize: Responsive.getFont(context, 14)),
                            controller: _searchController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 15),
                              labelStyle: TextStyle( fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                              ),
                              hintText: '내용을 입력해 주세요.',
                              hintStyle: TextStyle( fontFamily: 'Pretendard',
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
                                // TODO 검색기능
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
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: faqCategories.length,
                    itemBuilder: (context, index) {
                      final bool isSelected = selectedCategoryIndex == index;
                      final faqCategoryData = faqCategories[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: FilterChip(
                          label: Text(
                            faqCategoryData.cftName ?? "",
                            style: TextStyle( fontFamily: 'Pretendard',
                              color: isSelected
                                  ? Color(0xFFFF6192)
                                  : Colors.black, // 텍스트 색상
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedCategoryIndex = index;
                              _getList(true);
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? Color(0xFFFF6192)
                                  : Color(0xFFDDDDDD), // 테두리 색상
                              width: 1.0,
                            ),
                          ),
                          showCheckmark: false, // 체크 표시 없애기
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  color: const Color(0xFFF5F9F9), // 색상 적용
                  height: 10,
                ),
                Expanded(
                  child: Consumer(builder: (context, ref, widget) {
                    final model = ref.watch(faqModelProvider);
                    faqDataList = model?.faqResponseDTO?.list ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: faqDataList.length,
                      itemBuilder: (context, index) {
                        final faq = faqDataList[index];
                        String cateName = "";
                        for (var cate in faqCategories) {
                          if (cate.fcIdx == faq.cftIdx) {
                            cateName = cate.cftName ?? "";
                          }
                        }
                        return Theme(
                          data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent), // 선 제거
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            collapsedBackgroundColor: Colors.white,
                            // 펼쳐지기 전 배경
                            backgroundColor: Colors.white,
                            // 펼쳐진 후 배경
                            title: Row(
                              children: [
                                Text(
                                  cateName,
                                  style: TextStyle( fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.getFont(context, 14),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      faq.ftSubject ?? "",
                                      style: TextStyle( fontFamily: 'Pretendard',
                                        fontSize:
                                            Responsive.getFont(context, 14),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F9F9),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      faq.ftSubject ?? "",
                                      style: TextStyle( fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            Responsive.getFont(context, 14),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        faq.ftContent ?? "",
                                        style: TextStyle( fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(
                                                context, 14)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getCategory();
  }

  void _getCategory() {
    ref.read(faqModelProvider.notifier).getCategory().then((list) {
      if (list != null) {
        for (var data in list) {
          faqCategories.add(data);
        }

        setState(() {
          _getList(true);
        });
      }
    });
  }

  // TODO 페이징
  void _getList(bool isNew) {
    if (isNew) {
      ref.read(faqModelProvider)?.faqResponseDTO?.list?.clear();
      pg = 0;
    }

    var faqCategory = "all";
    if (selectedCategoryIndex > 0) {
      faqCategory = faqCategories[selectedCategoryIndex].fcIdx.toString();
    }

    Map<String, dynamic> requestData = {
      'search_txt': searchQuery,
      'faq_category': faqCategory,
      'pg': pg
    };

    ref.read(faqModelProvider.notifier).getList(requestData);
  }
}
