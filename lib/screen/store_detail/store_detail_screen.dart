import 'package:BliU/data/category_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/store_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/modal_dialog/product_sort_bottom.dart';
import 'package:BliU/screen/product_list/item/product_list_item.dart';
import 'package:BliU/screen/store_detail/child_widget/store_info_child_widget.dart';
import 'package:BliU/screen/store_detail/view_model/store_product_view_model.dart';
import 'package:BliU/utils/my_app_bar.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  const StoreDetailScreen({super.key});

  @override
  ConsumerState<StoreDetailScreen> createState() => StoreDetailScreenState();
}

class StoreDetailScreenState extends ConsumerState<StoreDetailScreen> with TickerProviderStateMixin {
  int _stIdx = 0;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _maxScrollHeight = 0;// NestedScrollView 사용시 최대 높이를 저장하기 위한 변수

  String _sortOption = '최신순';
  String _sortOptionSelected = '';

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _count = 0;
  final List<CategoryData> categories = [
    CategoryData(
      ctIdx: 0,
      cstIdx: 0,
      img: '',
      ctName: '전체',
      subList: [],
      catIdx: null,
      catName: null
    )
  ];
  StoreData? storeData;
  List<ProductData> _productList = [];

  @override
  void initState() {
    super.initState();
    try {
      _stIdx = int.parse(Get.parameters["st_idx"].toString());
    } catch(e) {
      //
    }
    _tabController = TabController(length: categories.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _afterBuild(BuildContext context) {
    _getCategoryList();
    _getList();
  }

  void _getCategoryList() async {
    Map<String, dynamic> requestData = {'category_type': '1'};
    final categoryResponseDTO = await ref.read(storeProductViewModelProvider.notifier).getCategory(requestData);
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        final list = categoryResponseDTO.list ?? [];
        for (var item in list) {
          categories.add(item);
        }

        setState(() {
          _tabController = TabController(length: categories.length, vsync: this);
          _tabController.addListener(_tabChangeCallBack);
        });
      }
    }
  }

  void _openSortBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: ProductSortBottom(
            sortOption: _sortOption,
            onSortOptionSelected: (selectedOption) {
              setState(() {
                _sortOptionSelected = selectedOption;
                _sortOption = selectedOption; // 선택된 정렬 옵션으로 업데이트
                _getList();
              });
            },
          ),
        );
      },
    );
  }

  void _tabChangeCallBack() {
    if (_tabController.indexIsChanging) {
      _hasNextPage = true;
      _isLoadMoreRunning = false;

      _getList();
    }
  }

  void _getList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _page = 1;

    final requestData = await _makeRequestData();

    setState(() {
      _count = 0;
      _productList = [];
    });

    final storeResponseDTO = await ref.read(storeProductViewModelProvider.notifier).getStoreList(requestData);
    storeData ??= storeResponseDTO?.data;
    _count = storeResponseDTO?.data.count ?? 0;
    _productList = storeResponseDTO?.data.list ?? [];

    setState(() {
      _isFirstLoadRunning = false;
    });
  }
  void _nextLoad() async {

    if (_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning){
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final requestData = await _makeRequestData();

      final storeResponseDTO = await ref.read(storeProductViewModelProvider.notifier).getStoreList(requestData);
      if (storeResponseDTO != null) {
        if (storeResponseDTO.data.list.isNotEmpty) {
          setState(() {
            _productList.addAll(storeResponseDTO.data.list);
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

  Future<Map<String, dynamic>> _makeRequestData() async {
    // TODO 정렬관련 API 작업 필요
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    String category = "all";
    final categoryData = categories[_tabController.index];
    if ((categoryData.ctIdx ?? 0) > 0) {
      category = categoryData.ctIdx.toString();
    }

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'category': category,
      'st_idx': _stIdx,
      'pg': _page,
    };

    return requestData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 동작
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Utils.getInstance().isWebView(
          Stack(
            children: [
              NotificationListener(
                onNotification: (scrollNotification){
                  if (scrollNotification is ScrollEndNotification) {
                    var metrics = scrollNotification.metrics;
                    if (metrics.axisDirection != AxisDirection.down) return false;
                    if (_maxScrollHeight < metrics.maxScrollExtent) {
                      _maxScrollHeight = metrics.maxScrollExtent;
                    }
                    if (_maxScrollHeight - metrics.pixels < 600) {
                      _nextLoad();
                    }
                  }
                  return false;
                },
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: StoreInfoChildWidget(storeData: storeData),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 60.0,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TabBar(
                                controller: _tabController,
                                labelStyle: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  fontWeight: FontWeight.w600,
                                ),
                                overlayColor: WidgetStateColor.transparent,
                                indicatorColor: Colors.black,
                                dividerColor: const Color(0xFFDDDDDD),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.black,
                                unselectedLabelColor: const Color(0xFF7B7B7B),
                                isScrollable: true,
                                indicatorWeight: 2.0,
                                tabAlignment: TabAlignment.start,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                tabs: categories.map((category) {
                                  return Tab(text: category.ctName ?? "");
                                }).toList(),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '상품 $_count', // 상품 수 표시
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _openSortBottomSheet, // 정렬 옵션 선택 창 열기
                                    child: Row(
                                      children: [
                                        SvgPicture.asset('assets/images/product/ic_filter02.svg'),
                                        Container(
                                          margin: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            _sortOptionSelected.isNotEmpty ? _sortOptionSelected : '최신순', // 선택된 정렬 옵션 표시
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 14),
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ), // 상단 고정된 컨텐츠
                      )
                    ];
                  },
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: List.generate(
                      categories.length, (index) {
                      if (index == _tabController.index) {
                        return _buildProductGrid();
                      } else {
                        return Container();
                      }
                    },
                    ),
                  ),
                ),
              ),
              MoveTopButton(scrollController: _scrollController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

        return ProductListItem(productData: productData);
      },
    );
  }
}
