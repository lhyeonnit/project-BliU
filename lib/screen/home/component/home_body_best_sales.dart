import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class HomeBodyBestSales extends StatefulWidget {
  const HomeBodyBestSales({super.key});

  @override
  State<HomeBodyBestSales> createState() => _HomeBodyBestSalesState();
}

class _HomeBodyBestSalesState extends State<HomeBodyBestSales> {
  final List<String> categories = [
    '전체',
    '아우터',
    '상의',
    '하의',
    '원피스',
    '슈즈',
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

  String selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '판매베스트',
            style: TextStyle(
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 31),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Widget>.generate(categories.length, (index){
                  return Container(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                      },
                      child: categoryTab(index),
                    ),
                  );
                }),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO 정렬
                    },
                    child: Row (
                      children: [
                        Image.asset(
                          "assets/images/exhibition/exhibition_img.png",
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                        ),
                        Text(
                          '최신순',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO 검색 카테고리
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(200),
                      border: Border.all(
                        color: const Color(0xFFDDDDDD), // 테두리 색상
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '연령',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black
                          ),
                        ),
                        Image.asset(
                          "assets/images/exhibition/exhibition_img.png",
                          width: 14,
                          height: 14,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 16, 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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

  Widget categoryTab(int index) {
    var borderColor = const Color(0xFFDDDDDD);
    var textColor = Colors.black;

    if (selectedCategory == categories[index]) {
      borderColor = const Color(0xFFFF6192);
      textColor = const Color(0xFFFF6192);
    }
    
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(200),
        border: Border.all(
          color: borderColor, // 테두리 색상
          width: 1.0,
        ),
      ),
      child: Text(
        categories[index],
        style: TextStyle(
          fontSize: Responsive.getFont(context, 14),
          color: textColor
        ),
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
