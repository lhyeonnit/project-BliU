import 'package:BliU/screen/mypage/component/top/component/my_review_edit.dart';
import 'package:BliU/screen/mypage/component/top/review_write_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyReviewDetail extends StatefulWidget {
  final Review review;

  const MyReviewDetail({
    super.key,
    required this.review,

  });
  @override
  _MyReviewDetailState createState() => _MyReviewDetailState();
}

class _MyReviewDetailState extends State<MyReviewDetail> {
  late Review _currentReview;
  PageController? _pageController;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _currentReview = widget.review;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
  Future<void> _editReview() async {
    final updatedReview = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyReviewEdit(review: _currentReview)),
    );

    if (updatedReview != null) {
      // 수정된 리뷰를 반영
      setState(() {
        _currentReview = updatedReview;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('리뷰 상세'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
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
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: Responsive.getHeight(context, 412),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _currentReview.images.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.file(
                        _currentReview.images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0x45000000),
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_currentPage + 1}',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 13),
                              color: Colors.white),
                        ),
                        Text(
                          '/${_currentReview.images.length}',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 13),
                              color: Color(0x80FFFFFF)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'blackpink22',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 12),
                            color: Color(0xFF7B7B7B)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '2024.04.14',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 12),
                              color: Color(0xFF7B7B7B)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/product/ic_rv_on.svg'),
                        SvgPicture.asset('assets/images/product/ic_rv_on.svg'),
                        SvgPicture.asset('assets/images/product/ic_rv_on.svg'),
                        SvgPicture.asset('assets/images/product/ic_rv_on.svg'),
                        SvgPicture.asset('assets/images/product/ic_rv_off.svg'),
                      ],
                    ),
                  ),
                  Text(
                    _currentReview.reviewText,
                    style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                  ),
                  GestureDetector(
                    onTap:  _editReview,
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white
                      ),
                      child: Center(
                        child: Text(
                          '수정',
                          style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
