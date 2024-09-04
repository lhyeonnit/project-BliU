import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<String> categories = ['전체', '배송', '주문/결제', '취소환불', '반품/교환'];

  int selectedCategoryIndex = 0;

  List<Map<String, String>> faqData = [
    {
      'category': '배송',
      'question': '주문 후 배송은 얼마나 걸리나요?',
      'answer':
          '평균 배송일은 영업일 기준 3~5일 정도 소요됩니다.\n(단, 주문제작, 프리오더, 액세서리 등 경우 평균보다 더 걸릴 수 있습니다)\n배송 지연이 오래 지속되는 경우 고객센터로 문의 부탁드립니다.\n\n고객센터 운영시간: 평일 10:00 ~ 17:00 / 점심시간 12:30 ~ 13:30\n전화: 1600-7346',
    },
    {
      'category': '주문/결제',
      'question': '주문을 확인하고 싶어요',
      'answer':
          '주문 확인은 마이페이지 내 주문내역에서 가능합니다.\n자세한 주문 내역을 확인하시려면 해당 주문을 선택해주세요.',
    },
    // 추가 FAQ 데이터 삽입 가능
  ];

  String searchQuery = "";

  List<Map<String, String>> getFilteredFAQData() {
    List<Map<String, String>> filteredFAQ;

    if (selectedCategoryIndex == 0) {
      filteredFAQ = faqData;
    } else {
      filteredFAQ = faqData
          .where((faq) => faq['category'] == categories[selectedCategoryIndex])
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredFAQ = filteredFAQ
          .where((faq) =>
              faq['question']!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              faq['answer']!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredFAQ;
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
        title: const Text(
          'FAQ',
          style: TextStyle(color: Colors.black),
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
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final bool isSelected = selectedCategoryIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: FilterChip(
                    label: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.pink : Colors.black, // 텍스트 색상
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategoryIndex = index;
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: getFilteredFAQData().length,
              itemBuilder: (context, index) {
                final faq = getFilteredFAQData()[index];
                return Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // 선 제거
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      collapsedBackgroundColor: Colors.transparent, // 펼쳐지기 전 배경
                      backgroundColor: Colors.transparent, // 펼쳐진 후 배경
                      title: Row(
                        children: [
                          Text(
                            faq['category']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              faq['question']!,
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
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  faq['question']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  faq['answer']!,
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
            ),
          ),
        ],
      ),
    );
  }
}
