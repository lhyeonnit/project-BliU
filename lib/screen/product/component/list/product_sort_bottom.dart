// product_sort_bottom.dart

import 'package:flutter/material.dart';

class ProductSortBottom extends StatelessWidget {
  final String sortOption;
  final ValueChanged<String> onSortOptionSelected;

  const ProductSortBottom({
    super.key,
    required this.sortOption,
    required this.onSortOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 320,
      child: Column(
        children: [
          ListTile(
            title: const Text('최신순'),
            onTap: () {
              onSortOptionSelected('최신순');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('인기순'),
            onTap: () {
              onSortOptionSelected('인기순');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('추천순'),
            onTap: () {
              onSortOptionSelected('추천순');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('가격 낮은순'),
            onTap: () {
              onSortOptionSelected('가격 낮은순');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('가격 높은순'),
            onTap: () {
              onSortOptionSelected('가격 높은순');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
