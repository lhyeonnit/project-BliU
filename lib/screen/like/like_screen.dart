
import 'package:flutter/material.dart';

import '../../utils/responsive.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}
final List<String> categories = [
  '전체',
  '아우터',
  '상의',
  '하의',
  '슈즈',
  '세트/한벌옷',
  '언더웨어/홈웨어',
];

final List<Map<String, String>> items = [
  {
    'image': 'http://example.com/item1.png',
    'name': '꿈꾸는데이지 안나 토션 레이스 베스트',
    'brand': '꿈꾸는데이지',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
  {
    'image': 'http://example.com/item2.png',
    'name': '레인보우꿈 안나 토션 레이스 베스트',
    'brand': '레인보우꿈',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
  {
    'image': 'http://example.com/item3.png',
    'name': '기글옷장 안나 토션 레이스 베스트',
    'brand': '기글옷장',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
  {
    'image': 'http://example.com/item4.png',
    'name': '스파클나라 안나 토션 레이스 베스트',
    'brand': '스파클나라',
    'price': '32,800원',
    'discount': '15%',
    'likes': '13,000',
    'comments': '49'
  },
];

class _LikeScreenState extends State<LikeScreen> {
  String selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 기본 뒤로가기 버튼을 숨김
        scrolledUnderElevation: 0,
        title: const Text('좋아요'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(categories.length, (index){
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: selectedCategory == categories[index]
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: selectedCategory == categories[index]
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (selectedCategory == categories[index])
                          Container(
                            margin: const EdgeInsets.only(top: 4.0),
                            height: 2.0,
                            width: 20.0,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '상품 128,123',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // 정렬방식 선택하는 액션 추가
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return buildItemCard(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemCard(Map<String, String> item) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Image.network(
                item['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            )
          ),
          Text(
              item['brand']!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // 길이가 길면 생략
            ),
          Text(
            item['name']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
            overflow: TextOverflow.ellipsis, // 길이가 길면 생략
          ),
          Text(
            '${item['discount']} ${item['price']}',
            style: const TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.grey,
                size: 16.0,
              ),
              const SizedBox(width: 4.0),
              Text(item['likes']!),
              const SizedBox(width: 16.0),
              const Icon(
                Icons.chat_bubble,
                color: Colors.grey,
                size: 16.0,
              ),
              const SizedBox(width: 4.0),
              Text(item['comments']!),
            ],
          ),
        ],
      )
    );
  }
}