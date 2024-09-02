import 'package:BliU/screen/product/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dummy/category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('카테고리'),
      ),
      body: Row(
        children: [
          // 왼쪽 상위 카테고리 목록
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]['ct_name']!),
                  onTap: () {
                    // 왼쪽 상위 카테고리 클릭 시 동작할 코드 (필요한 경우 추가)
                  },
                );
              },
            ),
          ),
          // 오른쪽 모든 상위 + 하위 카테고리 목록을 나열
          Expanded(
            child: ListView(
              children: categories.map((category) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상위 카테고리 제목과 이미지
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SvgPicture.network(
                            category['img']!,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            category['ct_name']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 하위 카테고리 목록
                    ...subCategories[int.parse(category['ct_idx']!)]!
                        .map((subCategory) => ListTile(
                      title: Text(subCategory),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // 하위 카테고리 선택 시 처리
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const ProductListScreen(),
                        ),
                        );
                      },
                    ))
                        ,
                    const Divider(), // 상위 카테고리 구분을 위한 구분선
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
