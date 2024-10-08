import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/home/viewmodel/home_body_best_sales_view_model.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/screen/store/component/store_age_group_selection.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class HomeBodyBestSales extends ConsumerStatefulWidget {
  final List<CategoryData> categories;
  final List<CategoryData> ageCategories;
  const HomeBodyBestSales({super.key, required this.categories, required this.ageCategories});

  @override
  ConsumerState<HomeBodyBestSales> createState() => _HomeBodyBestSalesState();
}

class _HomeBodyBestSalesState extends ConsumerState<HomeBodyBestSales> {
  CategoryData? _selectedAgeGroup;
  int _selectedCategoryIndex = 0;
  final List<CategoryData> _categories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];
  List<ProductData> _productList = [];

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          ageCategories: widget.ageCategories,
          selectedAgeGroup: _selectedAgeGroup,
          onSelectionChanged: (CategoryData? newSelection) {
            setState(() {
              _selectedAgeGroup = newSelection;
              _getList();
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (_selectedAgeGroup == null) {
      return '연령';
    } else {
      return _selectedAgeGroup?.catName ?? "";
    }
  }

  @override
  void initState() {
    super.initState();
    for (var category in widget.categories) {
      _categories.add(category);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '판매베스트',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Widget>.generate(_categories.length, (index) {
                  return Container(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                          _getList();
                        });
                      },
                      child: categoryTab(index),
                    ),
                  );
                }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: _showAgeGroupSelection,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFDDDDDD), // 테두리 색상
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Text(
                            getSelectedAgeGroupText(),
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black,
                              height: 1.2,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/images/product/filter_select.svg",
                          width: 14,
                          height: 14,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, bottom: 29),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 30.0,
                childAspectRatio: 0.55,
              ),
              itemCount: _productList.length,
              itemBuilder: (context, index) {
                final productData = _productList[index];
                return ProductListCard(productData: productData);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    // TODO 회원 비회원 처리 필요
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    final category = _categories[_selectedCategoryIndex];
    String categoryStr = "all";
    if (_selectedCategoryIndex > 0) {
      categoryStr = category.ctIdx.toString();
    }
    String ageStr = "all";
    if (_selectedAgeGroup != null) {
      ageStr = (_selectedAgeGroup?.catIdx ?? 0).toString();
    }

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'category' : categoryStr,
      'age' : ageStr,
    };

    final productListResponseDTO = await ref.read(homeBodyBestSalesViewModelProvider.notifier).getList(requestData);
    if (productListResponseDTO != null) {
      if (productListResponseDTO.result == true) {
        setState(() {
          _productList = productListResponseDTO.list;
        });
      }
    }
  }

  Widget categoryTab(int index) {
    var borderColor = const Color(0xFFDDDDDD);
    var textColor = Colors.black;

    if (_selectedCategoryIndex == index) {
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
        _categories[index].ctName ?? "",
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 14),
          color: textColor,
          height: 1.2,
        ),
      ),
    );
  }
}
