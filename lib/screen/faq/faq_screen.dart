import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/faq/view_model/faq_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAQScreen extends ConsumerStatefulWidget {
  const FAQScreen({super.key});

  @override
  ConsumerState<FAQScreen> createState() => FAQScreenState();
}

class FAQScreenState extends ConsumerState<FAQScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  void _afterBuild(BuildContext context) {
    ref.read(faqViewModelProvider.notifier).getCategory();
    _getList();
  }

  void _getList() {
    ref.read(faqViewModelProvider.notifier).listLoad();
  }

  void _nextLoad() async {
    if (_scrollController.position.extentAfter < 200) {
      ref.read(faqViewModelProvider.notifier).listNextLoad();
    }
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
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, widget) {
            final model = ref.watch(faqViewModelProvider);
            final faqCategories = model.faqCategories;
            final selectedCategoryIndex = model.selectedCategoryIndex;
            final faqList = model.faqList;

            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        height: 56,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE1E1E1))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                style: TextStyle(
                                    decorationThickness: 0,
                                    height: 1.2,
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14)
                                ),
                                controller: _searchController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                  ),
                                  hintText: '내용을 입력해 주세요.',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: const Color(0xFF595959)
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
                                  suffixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _searchController.clear();
                                    ref.read(faqViewModelProvider.notifier).setSearchTxt(value);
                                    _getList();
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 10, bottom: 8, right: 15),
                              child: GestureDetector(
                                onTap: () {
                                  String search = _searchController.text;
                                  if (search.isNotEmpty) {
                                    _searchController.clear();
                                    ref.read(faqViewModelProvider.notifier).setSearchTxt(search);
                                    _getList();
                                  }
                                },
                                child: SvgPicture.asset(
                                  'assets/images/home/ic_top_sch_w.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
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
                            padding: const EdgeInsets.only(right: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                ref.read(faqViewModelProvider.notifier).setSelectedCategoryIndex(index);
                                _getList();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
                                    width: 1.0,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    faqCategoryData.cftName ?? "",
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      color: const Color(0xFFF5F9F9), // 색상 적용
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: faqList.length,
                        itemBuilder: (context, index) {
                          final faq = faqList[index];
                          String cateName = "";
                          for (var cate in faqCategories) {
                            if (cate.fcIdx == faq.cftIdx) {
                              cateName = cate.cftName ?? "";
                            }
                          }
                          return Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // 선 제거
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
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.getFont(context, 14),
                                      height: 1.2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        faq.ftSubject ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
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
                                    color: const Color(0xFFF5F9F9),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        faq.ftSubject ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.bold,
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          faq.ftContent ?? "",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: Responsive.getFont(context, 14),
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                MoveTopButton(scrollController: _scrollController),
              ],
            );
          },
        ),
      ),
    );
  }
}
