import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/home/viewmodel/home_body_best_sales_view_model.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
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
  _HomeBodyBestSalesState createState() => _HomeBodyBestSalesState();
}

class _HomeBodyBestSalesState extends ConsumerState<HomeBodyBestSales> {
  CategoryData? selectedAgeGroup;
  int selectedCategoryIndex = 0;
  List<CategoryData> categories = [
    CategoryData(ctIdx: 0, cstIdx: 0, img: '', ctName: '전체', catIdx: 0, catName: '', subList: [])
  ];
  List<ProductData> productList = [];

  void _showAgeGroupSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StoreAgeGroupSelection(
          ageCategories: widget.ageCategories,
          selectedAgeGroup: selectedAgeGroup,
          onSelectionChanged: (CategoryData? newSelection) {
            setState(() {
              selectedAgeGroup = newSelection;
              _getList();
            });
          },
        );
      },
    );
  }

  String getSelectedAgeGroupText() {
    if (selectedAgeGroup == null) {
      return '연령';
    } else {
      return selectedAgeGroup?.catName ?? "";
    }
  }

  @override
  void initState() {
    super.initState();
    for (var category in widget.categories) {
      categories.add(category);
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
                children: List<Widget>.generate(categories.length, (index) {
                  return Container(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
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
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return buildItemCard(productList[index]);
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

    final category = categories[selectedCategoryIndex];
    String categoryStr = "all";
    if (selectedCategoryIndex > 0) {
      categoryStr = category.ctIdx.toString();
    }
    String ageStr = "all";
    if (selectedAgeGroup != null) {
      ageStr = (selectedAgeGroup?.catIdx ?? 0).toString();
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
          productList = productListResponseDTO.list;
        });
      }
    }
  }

  Widget categoryTab(int index) {
    var borderColor = const Color(0xFFDDDDDD);
    var textColor = Colors.black;

    if (selectedCategoryIndex == index) {
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
        categories[index].ctName ?? "",
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 14),
          color: textColor,
          height: 1.2,
        ),
      ),
    );
  }

  Widget buildItemCard(ProductData product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(ptIdx: product.ptIdx),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: Image.network(
                      product.ptImg ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // TODO 좋아요 작업
                      });
                    },
                    child: SvgPicture.asset(
                      product.likeChk == "Y"
                          ? 'assets/images/home/like_btn_fill.svg'
                          : 'assets/images/home/like_btn.svg',
                      color: product.likeChk == "Y"
                          ? const Color(0xFFFF6191)
                          : null,
                      // 좋아요 상태에 따라 내부 색상 변경
                      height: Responsive.getHeight(context, 34),
                      width: Responsive.getWidth(context, 34),
                      // 하트 내부를 채울 때만 색상 채우기, 채워지지 않은 상태는 투명 처리
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    product.stName ?? "",
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 12),
                      color: Colors.grey,
                      height: 1.2,
                    ),
                  ),
                ),
                Text(
                  product.ptName ?? "",
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "${product.ptDiscountPer}%",
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: const Color(0xFFFF6192),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          "${product.ptPrice}원",
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/home/item_like.svg',
                      width: Responsive.getWidth(context, 13),
                      height: Responsive.getHeight(context, 11),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 2, bottom: 2),
                      child: Text(
                        "${product.ptLike ?? ""}",
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 12),
                          color: Colors.grey,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/home/item_comment.svg',
                            width: Responsive.getWidth(context, 13),
                            height: Responsive.getHeight(context, 12),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 2, bottom: 2),
                            child: Text(
                              "${product.ptReview ?? ""}",
                              style: TextStyle(
                                fontSize: Responsive.getFont(context, 12),
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
