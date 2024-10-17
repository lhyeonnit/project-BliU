import 'package:BliU/data/review_data.dart';
import 'package:BliU/screen/mypage/viewmodel/my_review_view_model.dart';
import 'package:BliU/screen/product/component/detail/product_review_detail.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyReviewScreen extends ConsumerStatefulWidget {

  const MyReviewScreen({super.key});

  @override
  ConsumerState<MyReviewScreen> createState() => MyReviewScreenState();
}

class MyReviewScreenState extends ConsumerState<MyReviewScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ReviewData> _reviewList = [];

  bool _isListVisible = false;
  int _reviewCount = 0;

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_nextLoad);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_nextLoad);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('나의리뷰'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            child: Text(
              '작성한 리뷰 $_reviewCount',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14)
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Divider(
              height: 1,
              color: Color(0xFFEEEEEE),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: _isListVisible,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _reviewList.length, // 리뷰 개수에 맞춰 설정
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final reviewData = _reviewList[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductReviewDetail(rtIdx: reviewData.rtIdx ?? 0),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 상품 이미지
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Image.network(
                                    reviewData.rtImg ?? "",
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return const SizedBox();
                                    }
                                  ),
                                ),
                              ),
                              // 상품 정보 텍스트
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reviewData.stName ?? "",
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 12),
                                        color: const Color(0xFF7B7B7B),
                                        height: 1.2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        reviewData.ptName ?? "",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: Responsive.getFont(context, 14),
                                          height: 1.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Text(
                                      reviewData.ctOptName ?? "",
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: Responsive.getFont(context, 13),
                                        color: const Color(0xFF7B7B7B),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ),
                Visibility(
                  visible: !_isListVisible,
                  child: Center(
                    child: Text(
                      "작성하신 리뷰가 없습니다.",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 16),
                        color: Colors.grey,
                        height: 1.2,
                      ),
                    ),
                  )
                )
              ],
            )
          ),
        ],
      ),
    );
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
    Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'pg' : _page,
    };

    final reviewInfoResponseDTO = await ref.read(myReviewViewModelProvider.notifier).getList(requestData);
    _reviewCount = reviewInfoResponseDTO?.count ?? 0;
    _reviewList = reviewInfoResponseDTO?.list ?? [];
    if (_reviewList.isNotEmpty) {
      _isListVisible = true;
    }

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
      Map<String, dynamic> requestData = {
        'mt_idx': mtIdx,
        'pg' : _page,
      };

      final reviewInfoResponseDTO = await ref.read(myReviewViewModelProvider.notifier).getList(requestData);
      if (reviewInfoResponseDTO != null) {
        if ((reviewInfoResponseDTO.list ?? []).isNotEmpty) {
          setState(() {
            _reviewCount = reviewInfoResponseDTO.count ?? 0;
            _reviewList.addAll(reviewInfoResponseDTO.list ?? []);
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
}
