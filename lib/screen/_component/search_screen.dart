import 'package:BliU/data/search_my_data.dart';
import 'package:BliU/data/search_popular_data.dart';
import 'package:BliU/data/search_product_data.dart';
import 'package:BliU/data/search_store_data.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/dto/search_response_dto.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_recommend_item.dart';
import 'package:BliU/screen/_component/smart_lens_screen.dart';
import 'package:BliU/screen/_component/viewmodel/search_view_model.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/screen/store/store_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isFirst = true;
  bool _isSearching = false; // 검색 중인지 여부를 나타내는 플래그
  bool _searchCompleted = false;
  bool _searchFailed = false;
  List<bool> isFavoriteList = List<bool>.generate(10, (index) => false);
  List<SearchPopularData>? searchPopularList = [];
  List<SearchMyData> searchMyList = [];
  List<SearchStoreData> searchStoreData = [];
  List<SearchProductData> searchProductData = [];
  SearchResponseDTO? searchResponseDTO;
  List<dynamic> _filteredResults = [];
  List<ProductListResponseDTO?> productList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  void _afterBuild(BuildContext context) {
    _searchMyList();
    _getPopularList();
  }

  void _getList() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    String searchTxt = _searchController.text.toLowerCase();
    Map<String, dynamic> requestSearchData = {
      'mt_idx': mtIdx,
      'token': '',
      'search_txt': searchTxt,
      'research': 'N',
    };
    Map<String, dynamic> requestProductData = {
      'mt_idx': mtIdx,
      'category': 'all',
      'sub_category': 'all',
      'sort': '',
      'age': '',
      'styles': '',
      'min_price': 0,
      'max_price': 99999,
      'pg': 1,
      'search_txt' :searchTxt,
    };
    final productListResponseDTO = await ref.read(searchModelProvider.notifier).getProductList(requestProductData);
    if (productListResponseDTO != null) {
      if (productListResponseDTO.result == true) {
        productList.add(productListResponseDTO);
      } else {
        productList.add(null);
      }
    } else {
      productList.add(null);
    }

    final searchList = await ref.read(searchModelProvider.notifier).getSearchList(requestSearchData);
    setState(() {
        searchStoreData = searchList?.storeSearch ?? [];
        searchProductData = searchList?.productSearch ?? [];
        // 상점 및 상품 필터링 결과를 합쳐서 _filteredResults에 저장
        _filteredResults = <dynamic>[...searchProductData, ...searchStoreData];
    });
  }
  void _getPopularList() async {
    final searchPopularResponseDTO = await ref.read(searchModelProvider.notifier).getPopularList();

    if (searchPopularResponseDTO != null && searchPopularResponseDTO.result == true) {
      setState(() {
        searchPopularList = searchPopularResponseDTO.list ?? [];
      });
    }
  }

  void _searchMyList() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    Map<String, dynamic> requestSearchMyData = {
      'mt_idx': mtIdx,
    };
    final searchMyListResponseDTO = await ref.read(searchModelProvider.notifier).getSearchMyList(requestSearchMyData);
    setState(() {
      searchMyList = searchMyListResponseDTO?.list ?? [];
    });
  }

  void _searchMyDel(int stIdx) async {
    // TODO 회원 비회원 구분
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'slt_idx': stIdx,
    };

    final defaultResponseDTO =
        await ref.read(searchModelProvider.notifier).searchDel(requestData);
    if (defaultResponseDTO != null) {
      if (defaultResponseDTO.result == true) {
        _searchMyList();
      }
    }
  }

  void _searchAllDel() async {
    // TODO 회원 비회원 구분
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'slt_idx': 'all',
    };

    final defaultResponseDTO =
        await ref.read(searchModelProvider.notifier).searchDel(requestData);
    if (defaultResponseDTO != null) {
      if (defaultResponseDTO.result == true) {
        _searchMyList();
      }
      setState(() {
        searchMyList.clear();
      });
    }
  }

  Widget _buildHighlightedText(String text, String query) {
    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    query = query.toLowerCase();

    // 검색어와 일치하는 텍스트 부분을 강조
    while (
        (indexOfHighlight = text.toLowerCase().indexOf(query, start)) != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: TextStyle(
            height: 1.2,
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
          ),
        ));
      }
      spans.add(
        TextSpan(
          text: text.substring(indexOfHighlight, indexOfHighlight + query.length),
          style: TextStyle(
            height: 1.2,
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: const Color(0xFFFF6192)
          ),
        )
      );
      start = indexOfHighlight + query.length;
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(
            height: 1.2,
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: Colors.black
          ),
        )
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(
          height: 1.2,
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 14),
        ),
      ),
    );
  }
  void _startSearch() {
    setState(() {
      _isFirst = false;        // 첫 화면 아님
      _isSearching = true;     // 검색 중임
      _searchCompleted = false; // 검색 완료 상태 아님
      _searchFailed = false;   // 검색 실패 상태 아님
    });
  }

  void _completeSearch() {
    setState(() {
      _isSearching = false;    // 더 이상 검색 중이 아님
      _searchCompleted = true; // 검색 완료 상태로 설정
      _searchFailed = false;   // 검색 실패 상태 아님
    });
  }

  void _failSearch() {
    setState(() {
      _isSearching = false;    // 더 이상 검색 중이 아님
      _searchCompleted = false; // 검색 완료 상태 아님
      _searchFailed = true;    // 검색 실패 상태로 설정
    });
  }

  void _resetSearch() {
    setState(() {
      _isFirst = true;         // 첫 화면으로 돌아감
      _isSearching = false;    // 검색 중이 아님
      _searchCompleted = false; // 검색 완료 상태 아님
      _searchFailed = false;   // 검색 실패 상태 아님
    });
  }

  void _searchAction(String query) async {
    // 검색을 시작할 때 상태 업데이트
    _startSearch();

    try {
      // 실제 검색 로직 수행: _getList()와 동일한 로직을 이곳에 적용
      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();
      String searchTxt = query.toLowerCase();  // query로 받은 검색어를 소문자로 변환

      // API 호출을 위한 데이터 준비
      Map<String, dynamic> requestSearchData = {
        'mt_idx': mtIdx,
        'token': '',
        'search_txt': searchTxt,
        'research': 'N',
      };

      // 검색 결과 가져오기
      final searchList = await ref.read(searchModelProvider.notifier).getSearchList(requestSearchData);

      if (searchList != null && (searchList.storeSearch?.isNotEmpty ?? false) || (searchList?.productSearch?.isNotEmpty ?? false)) {
        // 검색 결과가 있으면 상태에 반영하고 완료 상태로 전환
        setState(() {
          searchStoreData = searchList?.storeSearch ?? [];
          searchProductData = searchList?.productSearch ?? [];
          // 상점 및 상품 필터링 결과를 합쳐서 _filteredResults에 저장
          _filteredResults = <dynamic>[...searchProductData, ...searchStoreData];
        });
        _completeSearch();
      } else {
        // 검색 결과가 없으면 실패 상태로 전환
        _failSearch();
      }
    } catch (e) {
      // 오류 발생 시에도 실패 상태로 전환
      _failSearch();
      print('Error during search: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: -1.0,
        title: SizedBox(
          width: double.infinity,
          height: 56,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            height: 1.2,
                            fontSize: Responsive.getFont(context, 14)
                          ),
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 16, bottom: 8),
                            hintText: '검색어를 입력해 주세요',
                            hintStyle: TextStyle(
                              height: 1.2,
                              fontSize: Responsive.getFont(context, 14),
                              color: const Color(0xFF595959)
                            ),
                            border: InputBorder.none,
                            suffixIcon: Visibility(
                              visible: _searchController.text.isNotEmpty,
                              child: GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    searchMyList.clear();
                                    _resetSearch();
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/ic_word_del.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            suffixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _isSearching = false;
                                _isFirst = true;
                              });
                            } else {
                              setState(() {
                                _isSearching = true;
                                _isFirst = false;
                              });
                              _getList();
                            }
                          },
                          // 검색 중인 상태
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _searchAction(value); // 검색어를 입력하고 검색을 실행
                            }
                          }, // 검색 완료 시
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10, bottom: 8, right: 15),
                        child: GestureDetector(
                          onTap: () {
                            String search = _searchController.text;
                            if (search.isNotEmpty) {
                              _searchMyList();
                              _searchController.clear();
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/images/home/ic_top_sch_w.svg',
                            color: Colors.black,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            child: Container(
                margin: EdgeInsets.only(right: 16),
                child: SvgPicture.asset("assets/images/product/ic_smart.svg")),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SmartLensScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Visibility(
            visible: _isSearching,
            child: _buildSearching(), // 검색 중 로딩 상태 UI
          ),
          Visibility(
            visible: _searchCompleted,
            child: _buildSearchResults(), // 검색 결과를 보여주는 UI
          ),
          Visibility(
            visible: _searchFailed,
            child: _buildNoResults(), // 검색 실패 시의 UI
          ),
          Visibility(
            visible: _isFirst,
            child: _buildDefaultSearchPage(),
          ),
        ],
      )
      // body: _isSearching
      //     ? _buildSearching() // 검색 중일 때 화면
      //     : _searchCompleted // 검색이 완료되었을 때
      //         ? (_searchCompleted
      //             ? _buildSearchResults() // 검색 결과가 있을 때
      //             : _buildNoResults()) // 검색 결과가 없을 때
      //         : _buildDefaultSearchPage(), // 검색 전 기본 화면 (추천 검색어 등)
    );
  }

  Widget _buildSearchHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 최근 검색어 UI
          Container(
            margin: const EdgeInsets.only(top: 40.0, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '최근 검색어',
                  style: TextStyle(
                      height: 1.2,
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 18),
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: _searchAllDel,
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/images/ic_delet.svg'),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          '전체삭제',
                          style: TextStyle(
                            height: 1.2,
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14)
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 검색 히스토리 표시
          Wrap(
            spacing: 4,
            runSpacing: 8,
            children: searchMyList.asMap().entries.map((entry) {
              SearchMyData searchData = entry.value;
              int stIdx = searchData.sltIdx ?? 0;
              String search = searchData.sltTxt ?? '';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.text = search; // 검색 기록 누르면 텍스트 창에 반영
                  });
                },
                child: Chip(
                  label: Text(
                    search,
                    style: TextStyle(
                      height: 1.2,
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14)
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  backgroundColor: Colors.white,
                  deleteIcon: SvgPicture.asset(
                    'assets/images/product/filter_del.svg',
                    color: const Color(0xFFACACAC)
                  ),
                  onDeleted: () {
                    setState(() {
                      _searchMyDel(stIdx); // 삭제 기능
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultSearchPage() {
    return Stack(
      children: [
        // 검색 중이 아닐 때 보여줄 화면
        Visibility(
          visible: !_isSearching,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (searchMyList.isNotEmpty) ...[
                  _buildSearchHistory(), // 검색 기록을 표시하는 위젯
                ],
                _buildPopularSearches(),
                SearchRecommendItem(),
              ],
            ),
          ),
        ),

        MoveTopButton(scrollController: _scrollController),
      ],
    );
  }

  Widget _buildPopularSearches() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20, top: 40),
            child: Text(
              '인기 검색어',
              style: TextStyle(
                  height: 1.2,
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 18),
                  fontWeight: FontWeight.bold),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchPopularList!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 9,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              final popularData = searchPopularList![index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.text = popularData.sltTxt!;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      child: Text('${popularData.sltRank}',
                          style: TextStyle(
                              height: 1.2,
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 15),
                              fontWeight: FontWeight.w600)),
                    ),
                    Text(
                      popularData.sltTxt ?? "",
                      style: TextStyle(
                          height: 1.2,
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 15)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearching() {
    return Stack(
      children:[ GestureDetector(
        onTap: () {
          // 검색 화면 외부를 터치하면 검색 종료
          _searchController.clear();
          setState(() {
            _isSearching = false;
          });
        },
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredResults.length,
            itemBuilder: (context, index) {
              final result = _filteredResults[index];
              if (result is SearchStoreData) {
                return ListTile(
                  leading: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: ClipOval(
                        child: Image.network(
                          result.stProfile ?? '',
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                  title: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: _buildHighlightedText(result.stName ?? '', _searchController.text),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const StoreDetailScreen(),
                      ),
                    );
                  },
                );
              } else {
                return ListTile(
                  leading: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/home/sch_front.png'),
                    ),
                  ),
                  title: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: _buildHighlightedText(result.ptName ?? '', _searchController.text),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ProductDetailScreen(ptIdx: 3),
                      ),
                    );
                  },
                );
              }

              // return Column(
              //   children: [
              //     ListTile(
              //       leading: Container(
              //         margin: const EdgeInsets.only(bottom: 10),
              //         width: 50,
              //         height: 50,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           border: Border.all(color: const Color(0xFFDDDDDD)),
              //         ),
              //         child: ClipOval(
              //             child: Image.network(
              //               result.stProfile ?? '',
              //               fit: BoxFit.cover,
              //             )
              //         ),
              //       ),
              //       title: Container(
              //         margin: const EdgeInsets.only(bottom: 10),
              //         child: _buildHighlightedText(result.stName ?? '', _searchController.text),),
              //       onTap: () {
              //         setState(() {
              //           _searchController.text = result.stName ?? '';
              //         });
              //       },
              //     ),
              //     ListTile(
              //       leading: Container(
              //         margin: const EdgeInsets.only(bottom: 10),
              //         width: 50,
              //         height: 50,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           border: Border.all(color: const Color(0xFFDDDDDD)),
              //         ),
              //         child: ClipOval(
              //           child: Image.asset('assets/images/home/sch_front.png'),
              //         ),
              //       ),
              //       title: Container(
              //         margin: const EdgeInsets.only(bottom: 10),
              //         child: _buildHighlightedText(item.ptName ?? '', _searchController.text),
              //       ),
              //       onTap: () {
              //         setState(() {
              //           _searchController.text = item.ptName ?? '';
              //         });
              //       },
              //     )
              //   ],
              // );
            },
          ),
        ),
      ),
    ],
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상품 ${productList.length}',
            style: TextStyle(
                height: 1.2,
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14)),
          ),
          GridView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 15.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 30,
              childAspectRatio: 0.55,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final productDataList = productList[index]?.list ?? [];
              final productData = productDataList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductDetailScreen(
                        ptIdx: 1,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 184,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: AspectRatio(
                              aspectRatio: 1,
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
                              onTap: () {
                                // TODO like update
                                setState(() {
                                  isFavoriteList[index] =
                                      !isFavoriteList[index]; // 좋아요 상태 토글
                                });
                              },
                              child: SvgPicture.asset(
                                productData.likeChk == "Y"
                                    ? 'assets/images/home/like_btn_fill.svg'
                                    : 'assets/images/home/like_btn.svg',
                                color: isFavoriteList[index]
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
                            margin: EdgeInsets.only(top: 12, bottom: 4),
                            child: Text(
                              productData.stName ?? '',
                              style: TextStyle(
                                height: 1.2,
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 12),
                                color: Color(0xFF7B7B7B),
                              ),
                            ),
                          ),
                          Text(
                            productData.ptName ?? '',
                            style: TextStyle(
                              height: 1.2,
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${productData.ptDiscountPer}%' ,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    color: const Color(0xFFFF6192),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    '${Utils.getInstance().priceString(productData.ptPrice ?? 0)}원',
                                    style: TextStyle(
                                      height: 1.2,
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      fontWeight: FontWeight.bold,
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
                                color: Color(0xFFA4A4A4),
                                width: Responsive.getWidth(context, 13),
                                height: Responsive.getHeight(context, 11),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 2, bottom: 2),
                                child: Text(
                                  '${productData.ptLike ?? ""}',
                                  style: TextStyle(
                                    height: 1.2,
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 12),
                                    color: Color(0xFFA4A4A4),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/home/item_comment.svg',
                                      width: Responsive.getWidth(context, 13),
                                      height: Responsive.getHeight(context, 12),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 2, bottom: 2),
                                      child: Text(
                                        '${productData.ptReview ?? ""}',
                                        style: TextStyle(
                                          height: 1.2,
                                          fontFamily: 'Pretendard',
                                          fontSize:
                                              Responsive.getFont(context, 12),
                                          color: Color(0xFFA4A4A4),
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
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F9F9),
                  borderRadius: BorderRadius.all(Radius.circular(70)),
                ),
                child: SvgPicture.asset(
                  'assets/images/product/ic_top_sch.svg',
                  height: 50,
                  width: 50,
                )),
            Container(
                margin: const EdgeInsets.only(top: 25, bottom: 10),
                child: Text('검색하신 결과가 없습니다.',
                    style: TextStyle(
                        height: 1.2,
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 18),
                        fontWeight: FontWeight.bold))),
            Text('다른 내용으로 검색해보세요.',
                style: TextStyle(
                    height: 1.2,
                    fontFamily: 'Pretendard',
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFFA4A4A4))),
          ],
        ),
      ),
    );
  }
}
