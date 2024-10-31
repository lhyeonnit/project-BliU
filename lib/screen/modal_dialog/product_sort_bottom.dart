import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductSortBottom extends StatefulWidget {
  final String sortOption;
  final ValueChanged<String> onSortOptionSelected;

  const ProductSortBottom({super.key, required this.sortOption, required this.onSortOptionSelected,});

  @override
  State<ProductSortBottom> createState() => ProductSortBottomState();
}

class ProductSortBottomState extends State<ProductSortBottom> {
  late String _tempSelectedSortGroup;

  @override
  void initState() {
    super.initState();
    _tempSelectedSortGroup = widget.sortOption;
  }

  void _toggleSelection(String sortOption) {
    setState(() {
      if (_tempSelectedSortGroup == sortOption) {
        _tempSelectedSortGroup = sortOption;
      } else {
        _tempSelectedSortGroup = sortOption;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sortText('최신순'),
                  _sortText('인기순'),
                  _sortText('추천순'),
                  _sortText('가격 낮은 순'),
                  _sortText('가격 높은 순'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortText(String sortOption) {
    final isSelected = _tempSelectedSortGroup.contains(sortOption);
    return GestureDetector(
      onTap: () {
        _toggleSelection(sortOption);
        widget.onSortOptionSelected(_tempSelectedSortGroup);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Text(
          sortOption,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 16),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            height: 1.2,
          ),
        )
      ),
    );
  }
}
