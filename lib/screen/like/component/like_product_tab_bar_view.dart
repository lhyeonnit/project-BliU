import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/like/viewmodel/like_product_tab_bar_view_view_model.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LikeProductTabBarView extends ConsumerStatefulWidget {
  final CategoryData categoryData;
  const LikeProductTabBarView({super.key, required this.categoryData});

  @override
  ConsumerState<LikeProductTabBarView> createState() => _LikeProductTabBarView();
}

class _LikeProductTabBarView extends ConsumerState<LikeProductTabBarView> {
  final ScrollController _scrollController = ScrollController();
  int _count = 0;
  List<ProductData> _productList = [];

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        _afterBuild(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String category = "all";
    if ((widget.categoryData.ctIdx ?? 0) > 0) {
      category = widget.categoryData.ctIdx.toString();
    }

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'category': category,
      'sub_category': "all",
      'pg': _page,
    };

    final productListResponseDTO = await ref.read(likeProductTabBarViewModelProvider.notifier).getList(requestData);
    _count = productListResponseDTO?.count ?? 0;
    _productList = productListResponseDTO?.list ?? [];

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {

    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 200){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();

      String category = "all";
      if ((widget.categoryData.ctIdx ?? 0) > 0) {
        category = widget.categoryData.ctIdx.toString();
      }

      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'category': category,
        'sub_category': "all",
        'pg': _page,
      };

      final productListResponseDTO = await ref.read(likeProductTabBarViewModelProvider.notifier).getList(requestData);
      if (productListResponseDTO != null) {
        _count = productListResponseDTO.count;
        if (productListResponseDTO.list.isNotEmpty) {
          setState(() {
            _productList.addAll(productListResponseDTO.list);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            '상품 $_count', // 상품 수 표시
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 30,
            ),
            itemCount: _productList.length, // 실제 상품 수로 변경
            itemBuilder: (context, index) {
              final productData = _productList[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(ptIdx: productData.ptIdx),
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
                                productData.ptImg ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {

                                final pref = await SharedPreferencesManager.getInstance();
                                final mtIdx = pref.getMtIdx() ?? "";
                                if (mtIdx.isNotEmpty) {
                                  final likeChk = productData.likeChk;

                                  Map<String, dynamic> requestData = {
                                    'mt_idx' : mtIdx,
                                    'pt_idx' : productData.ptIdx,
                                  };

                                  final defaultResponseDTO = await ref.read(likeProductTabBarViewModelProvider.notifier).productLike(requestData);
                                  if(defaultResponseDTO != null) {
                                    if (defaultResponseDTO.result == true) {
                                      setState(() {
                                        _productList.removeAt(index);
                                      });
                                    }
                                  }
                                }
                              },
                              child: Image.asset(
                                productData.likeChk == "Y" ? 'assets/images/home/like_btn_fill.png' : 'assets/images/home/like_btn.png',
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
                              productData.stName ?? "",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 12),
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            productData.ptName ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
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
                                  '${productData.ptDiscountPer ?? 0}%',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    color: const Color(0xFFFF6192),
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    "${Utils.getInstance().priceString(productData.ptPrice ?? 0)}원",
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
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
                                  '${productData.ptLike ?? ""}',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
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
                                        '${productData.ptReview ?? ""}',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
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
            },
          ),
        ),
      ],
    );
  }
}