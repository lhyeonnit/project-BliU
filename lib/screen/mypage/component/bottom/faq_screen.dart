import 'package:BliU/data/faq_category_data.dart';
import 'package:BliU/data/faq_data.dart';
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
  List<FaqCategoryData> faqCategories = [FaqCategoryData(fcIdx: -1, cftName: "전체")];
  List<FaqData> faqDataList = [];

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'FAQ',
          style: TextStyle(
              color: Colors.black,
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _getList(true);
                });
              },
              decoration: InputDecoration(
                hintText: '내용을 입력해 주세요.',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
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
                      style: TextStyle(
                        color: isSelected ? Colors.pink : Colors.black, // 텍스트 색상
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
                        color: isSelected ? Colors.pink : Colors.grey, // 테두리 색상
                        width: 1.0,
                      ),
                    ),
                    showCheckmark: false, // 체크 표시 없애기
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: const Color(0xFFF5F9F9), // 색상 적용
            height: 10,
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, widget) {
                final model = ref.watch(faqModelProvider);
                faqDataList = model?.faqResponseDTO?.list ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: faqDataList.length,
                  itemBuilder: (context, index) {
                    final faq = faqDataList[index];
                    String cateName = "";
                    for(var cate in faqCategories) {
                      if (cate.fcIdx == faq.cftIdx) {
                        cateName = cate.cftName ?? "";
                      }
                    }
                    return Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // 선 제거
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        collapsedBackgroundColor: Colors.white, // 펼쳐지기 전 배경
                        backgroundColor: Colors.white, // 펼쳐진 후 배경
                        title: Row(
                          children: [
                            Text(
                              cateName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                faq.ftSubject ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    faq.ftSubject ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    faq.ftContent ?? "",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            ),
          ),
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
      'search_txt' : searchQuery,
      'faq_category' : faqCategory,
      'pg' : pg
    };

    ref.read(faqModelProvider.notifier).getList(requestData);
  }
}
