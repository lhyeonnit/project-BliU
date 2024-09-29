import 'package:BliU/screen/product/component/list/product_sort_bottom.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreGroupSelection extends StatefulWidget {
  const StoreGroupSelection({super.key});

  @override
  State<StoreGroupSelection> createState() => _StoreGroupSelectionState();
}

class _StoreGroupSelectionState extends State<StoreGroupSelection> {
  String selectedAgeGroup = '';
  String sortOption = '최신순';
  String sortOptionSelected = '';

  void _openSortBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ProductSortBottom(
          sortOption: sortOption,
          onSortOptionSelected: (String newSelection) {
            setState(() {
              sortOptionSelected = newSelection;
              sortOption = newSelection; // 선택된 정렬 옵션으로 업데이트
            });
          },
        );
      },
    );
  }

  void _showAgeGroupSelection() {
    // showModalBottomSheet(
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
    //   ),
    //   context: context,
    //   backgroundColor: Colors.white,
    //   builder: (BuildContext context) {
    //     return StoreAgeGroupSelection(
    //       selectedAgeGroup: selectedAgeGroup,
    //       onSelectionChanged: (String newSelection) {
    //         setState(() {
    //           selectedAgeGroup = newSelection;
    //         });
    //       },
    //     );
    //   },
    // );
  }

  String getSelectedSortGroupText() {
    if (sortOptionSelected.isEmpty) {
      return sortOption;
    } else {
      return sortOptionSelected;
    }
  }

  String getSelectedAgeGroupText() {
    if (selectedAgeGroup.isEmpty) {
      return '연령';
    } else {
      return selectedAgeGroup;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _openSortBottomSheet, // 정렬 순서 변경 로직
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/home/ic_filter02.svg',
                    height: 18,
                    width: 18,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    getSelectedSortGroupText(), // 정렬 순서 텍스트
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // TODO 유아악세사리카테고리에서는 표시x
          Flexible(
            child: GestureDetector(
              onTap: _showAgeGroupSelection, // 연령대 필터 선택
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 17, top: 11, bottom: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Color(0xFFDDDDDD)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Text(
                        getSelectedAgeGroupText(), // 선택된 연령대 표시
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SvgPicture.asset('assets/images/product/filter_select.svg'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
