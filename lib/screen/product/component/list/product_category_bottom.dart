import 'package:flutter/material.dart';

class ProductCategoryBottom extends StatelessWidget {
  final Function(String) onCategorySelected;  // Callback to handle category selection

  const ProductCategoryBottom({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 500,
      child: ListView(
        children: [
          const Text('카테고리', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ListTile(
            title: const Text('아우터'),
            onTap: () => onCategorySelected('아우터'),
          ),
          ListTile(
            title: const Text('상의'),
            onTap: () => onCategorySelected('상의'),
          ),
          ListTile(
            title: const Text('하의'),
            onTap: () => onCategorySelected('하의'),
          ),
          ListTile(
            title: const Text('슈즈'),
            onTap: () => onCategorySelected('슈즈'),
          ),
          ListTile(
            title: const Text('세트/한벌옷'),
            onTap: () => onCategorySelected('세트/한벌옷'),
          ),
          ListTile(
            title: const Text('언더웨어/홈웨어'),
            onTap: () => onCategorySelected('언더웨어/홈웨어'),
          ),
          ListTile(
            title: const Text('액세사리'),
            onTap: () => onCategorySelected('액세사리'),
          ),
          ListTile(
            title: const Text('베이비잡화'),
            onTap: () => onCategorySelected('베이비잡화'),
          ),
        ],
      ),
    );
  }
}
