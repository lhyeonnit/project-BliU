import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductFilterBottom extends StatefulWidget {
  final bool isMoveBottom;
  final List<CategoryData> ageCategories;
  final List<StyleCategoryData> styleCategories;
  final CategoryData? selectedAgeOption;
  final List<StyleCategoryData> selectedStyleOption;
  final RangeValues selectedRangeValuesOption;
  final ValueChanged<Map<String, dynamic>> onValueSelected;

  const ProductFilterBottom({
    super.key,
    required this.isMoveBottom,
    required this.ageCategories,
    required this.styleCategories,
    required this.selectedAgeOption,
    required this.selectedStyleOption,
    required this.selectedRangeValuesOption,
    required this.onValueSelected,
  });

  @override
  State<ProductFilterBottom> createState() => _ProductFilterBottomState();
}

class _ProductFilterBottomState extends State<ProductFilterBottom> {
  final _scrollController = ScrollController();
  late List<CategoryData> _ageCategories;
  late List<StyleCategoryData> _styleCategories;
  late CategoryData? _tempSelectedAgeGroup;
  late List<StyleCategoryData> _tempSelectedStyle;
  late RangeValues _tempSelectedRange;

  @override
  void initState() {
    super.initState();
    _ageCategories = widget.ageCategories;
    _styleCategories = widget.styleCategories;
    _tempSelectedAgeGroup = widget.selectedAgeOption;
    _tempSelectedStyle = List.from(widget.selectedStyleOption);
    _tempSelectedRange = widget.selectedRangeValuesOption;
    WidgetsBinding.instance.addPostFrameCallback((_){
      if (widget.isMoveBottom) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _toggleAgeSelection(CategoryData ageCategory) {
    setState(() {
      if (_tempSelectedAgeGroup?.catIdx == ageCategory.catIdx) {
        _tempSelectedAgeGroup = null;
      } else {
        _tempSelectedAgeGroup = ageCategory;
      }
    });
  }

  void _toggleStyleSelection(StyleCategoryData styleCategory) {
    setState(() {
      if (_tempSelectedStyle.contains(styleCategory)) {
        _tempSelectedStyle.remove(styleCategory);
      } else {
        _tempSelectedStyle.add(styleCategory);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                  margin: const EdgeInsets.only(bottom: 80),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 7, bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '연령',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              _ageCategories.length, (index) {
                                final ageCategory = _ageCategories[index];
                                return Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: _buildAgeGroupChip(ageCategory));
                              }
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: const Color(0xFFEEEEEE)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
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
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 4.0,
                            runSpacing: 10.0,
                            children: List.generate(
                              _styleCategories.length, (index) {
                                final styleCategory = _styleCategories[index];
                                return  _buildStyleChip(styleCategory);
                              }
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: const Color(0xFFEEEEEE)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '가격',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 18),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              '${_tempSelectedRange.start.toInt()}원 ~ ${_tempSelectedRange.end.toInt()}원',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 18),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                        // 실제 RangeSlider
                        RangeSlider(
                          values: _tempSelectedRange,
                          min: 0,
                          max: 100000,
                          divisions: 100,
                          activeColor: const Color(0xFFFF6192),
                          // 슬라이더의 활성 부분 색상
                          inactiveColor: const Color(0xFFEEEEEE),
                          // 슬라이더의 비활성 부분 색상
                          labels: RangeLabels(
                            _tempSelectedRange.start.round().toString(),
                            _tempSelectedRange.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _tempSelectedRange = values; // 슬라이더 값 업데이트
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 11, right: 10, top: 9, bottom: 8),
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: const Color(0xFFDDDDDD))
                    ),
                    child: SvgPicture.asset('assets/images/store/ic_release.svg'),
                  ),
                  onTap: () {
                    setState(() {
                      _tempSelectedAgeGroup = null;
                      _tempSelectedStyle.clear();
                      _tempSelectedRange = const RangeValues(0, 100000);
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Map<String, dynamic> value = {
                        'age' : _tempSelectedAgeGroup,
                        'style' : _tempSelectedStyle,
                        'range' : _tempSelectedRange,
                      };
                      widget.onValueSelected(value);

                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 9),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.black
                      ),
                      width: double.infinity,
                      height: 48,
                      child: const Center(
                        child: Text(
                          '상품보기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: Colors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeGroupChip(CategoryData ageCategory) {
    final isSelected = _tempSelectedAgeGroup?.catIdx == ageCategory.catIdx ? true : false;
    return GestureDetector(
      onTap: () => _toggleAgeSelection(ageCategory),
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
          ageCategory.catName ?? "",
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

  Widget _buildStyleChip(StyleCategoryData styleCategory) {
    final isSelected = _tempSelectedStyle.contains(styleCategory);
    return GestureDetector(
      onTap: () => _toggleStyleSelection(styleCategory),
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
          styleCategory.cstName ?? "",
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
