import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StyleSelectionSheet extends StatefulWidget {
  final List<StyleCategoryData> styleCategories;
  final StyleCategoryData? selectedStyle;
  final ValueChanged<StyleCategoryData?> onSelectionChanged;
  final ScrollController scrollController;

  const StyleSelectionSheet({
    required this.styleCategories,
    required this.selectedStyle,
    required this.onSelectionChanged,
    required this.scrollController,
    super.key,
  });

  @override
  State<StyleSelectionSheet> createState() => _StyleSelectionSheetState();
}

class _StyleSelectionSheetState extends State<StyleSelectionSheet> {
  late List<StyleCategoryData> _styleCategories;
  late StyleCategoryData? _tempSelectedStyle;

  @override
  void initState() {
    super.initState();
    _styleCategories = widget.styleCategories;
    _tempSelectedStyle = widget.selectedStyle;
  }

  void _toggleSelection(StyleCategoryData styleCategoryData) {
    setState(() {
      if (_tempSelectedStyle == styleCategoryData) {
        _tempSelectedStyle = null;
      } else {
        _tempSelectedStyle = styleCategoryData;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 17),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '스타일',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Wrap(
                        spacing: 4.0,
                        runSpacing: 10.0,
                        children: List.generate(_styleCategories.length, (index) {
                          final styleCategory = _styleCategories[index];
                          return  _buildStyleChip(styleCategory);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 11, right: 10, top: 9, bottom: 8),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xD000000)))),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _tempSelectedStyle = null;
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xFFDDDDDD))),
                        child: SvgPicture.asset('assets/images/store/ic_release.svg'),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onSelectionChanged(_tempSelectedStyle);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 9),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.black,
                          ),
                          width: double.infinity,
                          height: 48,
                          child: const Center(
                            child: Text(
                              '선택완료',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: Colors.white,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStyleChip(StyleCategoryData styleCategoryData) {
    final isSelected = _tempSelectedStyle == styleCategoryData ? true : false;
    return GestureDetector(
      onTap: () => _toggleSelection(styleCategoryData),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
            width: 1.0,
          ),
          color: Colors.white,
        ),
        child: Text(
          styleCategoryData.cstName ?? "",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: isSelected ? const Color(0xFFFF6192) : Colors.black,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
