import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:BliU/utils/responsive.dart';
import '../store_age_group_selection.dart';
import 'store_category_item.dart';

class StoreCategory extends StatefulWidget {
  @override
  _StoreCategoryState createState() => _StoreCategoryState();
}

class _StoreCategoryState extends State<StoreCategory>
    with SingleTickerProviderStateMixin {
  final List<String> categories = [
    '전체',
    '아우터',
    '상의',
    '하의',
    '원피스',
    '슈즈',
    '세트/한벌옷',
    '언더웨어/홈웨어',
    '악세서리',
    '베이비 잡화'
  ];

  String sortOrder = '최신순';
  List<ScrollController> scrollControllers = [];
  List<int> productCounts = [];


  late TabController _tabController;
  List<String> selectedAgeGroups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    productCounts = List<int>.filled(categories.length, 10); // 각 탭에 대해 초기 상품 수 설정

    // 각 탭마다 독립적인 ScrollController 설정
    for (int i = 0; i < categories.length; i++) {
      scrollControllers.add(ScrollController());

      // 무한 스크롤 감지
      scrollControllers[i].addListener(() {
        if (scrollControllers[i].position.pixels ==
            scrollControllers[i].position.maxScrollExtent) {
          setState(() {
            productCounts[i] += 10; // 상품을 10개씩 추가
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (ScrollController controller in scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          selectedAgeGroups: selectedAgeGroups,
          onSelectionChanged: (List<String> newSelection) {
            setState(() {
              selectedAgeGroups = newSelection;
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupsText() {
    if (selectedAgeGroups.isEmpty) {
      return '연령';
    } else {
      return selectedAgeGroups.join(', ');
    }
  }

  void _onSortOrderChanged() {
    setState(() {
      sortOrder = sortOrder == '최신순' ? '인기순' : '최신순';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: TabBar(
            controller: _tabController,
            labelStyle: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              fontWeight: FontWeight.w600,
            ),
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            unselectedLabelColor: Color(0xFF7B7B7B),
            isScrollable: true,
            indicatorWeight: 2.0,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.symmetric(horizontal: 12),
            tabs: categories.map((category) {
              return Tab(text: category);
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _onSortOrderChanged,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/ic_filter02.svg',
                        height: 18,
                        width: 18,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        sortOrder,
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14)),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: OutlinedButton(
                  onPressed: _showAgeGroupSelection,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          getSelectedAgeGroupsText(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      SvgPicture.asset(
                          'assets/images/product/filter_select.svg'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            '상품 ${productCounts[_tabController.index]}',
            style: TextStyle(
                fontSize: Responsive.getFont(context, 14),
                color: Colors.black),
          ),
        ),
        // Expanded(
        //   child: TabBarView(
        //     controller: _tabController,
        //     children: List.generate(categories.length, (index) {
        //       return StoreCategoryItem(scrollControllers: scrollControllers,
        //         productCounts: productCounts, index: index,);
        //     }),
        //   ),
        // ),
      ],
    );
  }
}
