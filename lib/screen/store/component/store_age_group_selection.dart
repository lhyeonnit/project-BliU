import 'package:BliU/data/category_data.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreAgeGroupSelection extends StatefulWidget {
  final List<CategoryData> ageCategories;
  final CategoryData? selectedAgeGroup;
  final ValueChanged<CategoryData?> onSelectionChanged;

  const StoreAgeGroupSelection({
    required this.ageCategories,
    required this.selectedAgeGroup,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  State<StoreAgeGroupSelection> createState() => _StoreAgeGroupSelectionState();
}

class _StoreAgeGroupSelectionState extends State<StoreAgeGroupSelection> {
  CategoryData? _tempSelectedAgeGroup;

  @override
  void initState() {
    super.initState();
    _tempSelectedAgeGroup = widget.selectedAgeGroup;
  }

  void _toggleSelection(CategoryData ageGroup) {
    setState(() {
      if (_tempSelectedAgeGroup?.catIdx == ageGroup.catIdx) {
        _tempSelectedAgeGroup = null;
      } else {
        _tempSelectedAgeGroup = ageGroup;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '연령대',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.ageCategories.map((category) {
                return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: _buildAgeGroupChip(category),
                );
              }),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 11, right: 10, top: 9, bottom: 8),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xD0000000)
              )
            )
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _tempSelectedAgeGroup = null;
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: const Color(0xFFDDDDDD))
                  ),
                  child: SvgPicture.asset('assets/images/store/ic_release.svg'),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onSelectionChanged(_tempSelectedAgeGroup);
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
      ],
    );
  }

  Widget _buildAgeGroupChip(CategoryData ageGroup) {
    final isSelected = _tempSelectedAgeGroup?.catIdx == ageGroup.catIdx;
    return GestureDetector(
      onTap: () => _toggleSelection(ageGroup),
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
          ageGroup.catName ?? "",
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
