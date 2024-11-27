import 'package:BliU/data/category_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/cart/cart_screen.dart';
import 'package:BliU/screen/main/page_screen/home/child_widget/home_body_ai_child_widget.dart';
import 'package:BliU/screen/main/page_screen/home/child_widget/home_body_category_child_widget.dart';
import 'package:BliU/screen/main/page_screen/home/child_widget/home_body_exhibition_child_widget.dart';
import 'package:BliU/screen/main/page_screen/home/child_widget/home_footer_child_widget.dart';
import 'package:BliU/screen/main/page_screen/home/child_widget/home_header_child_widget.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_body_ai_view_model.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_body_exhibition_view_model.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_footer_view_model.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_header_view_model.dart';
import 'package:BliU/screen/main/page_screen/home/view_model/home_view_model.dart';
import 'package:BliU/screen/main/view_model/main_view_model.dart';
import 'package:BliU/screen/modal_dialog/store_age_group_selection.dart';
import 'package:BliU/screen/product_list/item/product_list_item.dart';
import 'package:BliU/screen/search/search_screen.dart';
import 'package:BliU/screen/smart_lens/smart_lens_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // 페이징
      // final viewModel = ref.read(homeViewModelProvider.notifier);
      // final model = ref.read(homeViewModelProvider);
      // final isScrolled = model.isScrolled;
      // if (_scrollController.offset > 50 && !isScrolled) {
      //   viewModel.setIsScrolled(true);
      // } else if (_scrollController.offset <= 50 && isScrolled) {
      //   viewModel.setIsScrolled(false);
      // }
      //
      // if (_scrollController.position.maxScrollExtent - _scrollController.offset < 100) {
      //   ref.read(homeViewModelProvider.notifier).listNextLoad();
      // }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _viewWillAppear(BuildContext context) {
    ref.read(homeHeaderViewModelProvider.notifier).getBanner();
    ref.read(homeBodyExhibitionViewModelProvider.notifier).getList();
    ref.read(homeViewModelProvider.notifier).listLoad();

    _getAiList();
    _getCartCount();
  }

  void _afterBuild(BuildContext context) {
    ref.read(homeFooterViewModelProvider.notifier).getFoot();
  }

  void _getCartCount() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";
    int type = 1;
    if (mtIdx.isEmpty) {
      type = 2;
    }

    Map<String, dynamic> requestData = {
      'type': type,
      'mt_idx': mtIdx,
      'temp_mt_id': pref.getToken(),
    };

    ref.read(homeViewModelProvider.notifier).getCartCount(requestData);
  }

  void _getAiList() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? '';
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
    };

    ref.read(homeBodyAiViewModelProvider.notifier).getList(requestData);
  }

  void _showAgeGroupSelection() {
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final mainModel = ref.read(mainViewModelProvider);
    final homeModel = ref.read(homeViewModelProvider);
    final ageCategories = mainModel.ageCategories;
    final selectedAgeGroup = homeModel.selectedAgeGroup;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: StoreAgeGroupSelection(
            ageCategories: ageCategories,
            selectedAgeGroup: selectedAgeGroup,
            onSelectionChanged: (CategoryData? newSelection) {
              viewModel.setSelectedAgeGroup(newSelection);
              viewModel.listLoad();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
      child: Consumer(
        builder: (context, ref, widget){
          final viewModel = ref.read(homeViewModelProvider.notifier);
          final mainModel = ref.watch(mainViewModelProvider);
          final homeModel = ref.watch(homeViewModelProvider);
          final cartCount = homeModel.cartCount;
          final productList = homeModel.productList;

          final productCategories = mainModel.productCategories;

          final isScrolled = homeModel.isScrolled;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverAppBar(
                            scrolledUnderElevation: 0,
                            pinned: true,
                            automaticallyImplyLeading: false,
                            // 기본 뒤로가기 버튼을 숨김
                            backgroundColor: isScrolled ? Colors.white : Colors.transparent,
                            expandedHeight: MediaQuery.of(context).size.width * 1.4,
                            centerTitle: false,
                            title: SvgPicture.asset(
                              'assets/images/home/bottom_home.svg', // SVG 파일 경로
                              colorFilter: ColorFilter.mode(
                                isScrolled ? Colors.black : Colors.white,
                                BlendMode.srcIn,
                              ),
                              // 색상 조건부 변경
                              height: Responsive.getHeight(context, 40),
                            ),
                            flexibleSpace: const FlexibleSpaceBar(
                              background: HomeHeaderChildWidget(),
                            ),
                            actions: [
                              Container(
                                padding: EdgeInsets.only(right: Responsive.getWidth(context, 8)),
                                // 왼쪽 여백 추가
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/images/home/ic_top_sch_w.svg",
                                        colorFilter: ColorFilter.mode(
                                          isScrolled ? Colors.black : Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                        height: Responsive.getHeight(context, 30),
                                        width: Responsive.getWidth(context, 30),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SearchScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        isScrolled ? "assets/images/product/ic_smart.svg" : "assets/images/home/ic_smart_w.svg",
                                        height: Responsive.getHeight(context, 30),
                                        width: Responsive.getWidth(context, 30),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SmartLensScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    Stack(
                                      children: [
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            "assets/images/product/ic_cart.svg",
                                            colorFilter: ColorFilter.mode(
                                              isScrolled ? Colors.black : Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                            height: Responsive.getHeight(context, 30),
                                            width: Responsive.getWidth(context, 30),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const CartScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: 23,
                                          child: Visibility(
                                            visible: cartCount == "0" ? false : true,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFFF6191),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                cartCount,
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  color: Colors.white,
                                                  fontSize: Responsive.getFont(context, 9),
                                                  height: 1.2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                const HomeBodyCategoryChildWidget(),
                                const HomeBodyAiChildWidget(),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.0),
                                  child: SizedBox(
                                    height: 451, // 고정된 높이
                                    child: HomeBodyExhibitionChildWidget(),
                                  ),
                                ),
                                Container(
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
                                            children: List<Widget>.generate(productCategories.length, (index) {
                                              return Container(
                                                padding: const EdgeInsets.only(right: 4.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ref.read(homeViewModelProvider.notifier).setSelectedCategoryIndex(index);
                                                    ref.read(homeViewModelProvider.notifier).listLoad();
                                                  },
                                                  child: categoryTab(index),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        margin: const EdgeInsets.only(top: 20.0),
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: FittedBox(
                                          child: GestureDetector(
                                            onTap: () {
                                              _showAgeGroupSelection();
                                            },
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
                                                      viewModel.getSelectedAgeGroupText(),
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
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 16, bottom: 29, top: 20),
                                        child: GridView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12.0,
                                            mainAxisSpacing: 30.0,
                                            childAspectRatio: 0.5,
                                          ),
                                          itemCount: productList.length,
                                          itemBuilder: (context, index) {
                                            final productData = productList[index];
                                            return ProductListItem(productData: productData);
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: productList.isEmpty,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 200),
                                          child: const NonDataScreen(text: '등록된 상품이 없습니다.',),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const HomeFooterChildWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                MoveTopButton(scrollController: _scrollController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget categoryTab(int index) {
    final mainModel = ref.watch(mainViewModelProvider);
    final homeModel = ref.watch(homeViewModelProvider);
    final selectedCategoryIndex = homeModel.selectedCategoryIndex;
    final productCategories = mainModel.productCategories;

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
        productCategories[index].ctName ?? "",
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
