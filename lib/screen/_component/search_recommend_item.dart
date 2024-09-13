import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class SearchRecommendItem extends StatefulWidget {
  const SearchRecommendItem({super.key});

  @override
  State<SearchRecommendItem> createState() => _SearchRecommendItemState();
}

class _SearchRecommendItemState extends State<SearchRecommendItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          child: Text(
            '이런 아이템은 어떠세요?',
            style: TextStyle(
                fontSize: Responsive.getFont(context, 18),
                fontWeight: FontWeight.bold),
          ),
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
                        builder: (context) =>
                        const ProductDetailScreen(),
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
                          borderRadius: const BorderRadius.all(
                              Radius.circular(5)),
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
    );
  }
}
