// product_sort_bottom.dart

import 'package:BliU/utils/responsive.dart';
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
      height: 270,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 17, top: 15),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sortText('최신순', context),
                  _sortText('인기순', context),
                  _sortText('추천순', context),
                  _sortText('가격 낮은 순', context),
                  _sortText('가격 높은 순', context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _sortText(String title, BuildContext context) {

    return Container(
        margin: EdgeInsets.only(bottom: 24),
        child: Text(title, style: TextStyle(fontSize: Responsive.getFont(context, 16)),));
  }
}
