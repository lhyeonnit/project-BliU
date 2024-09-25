import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductBanner extends StatefulWidget {
  final List<String> imgArr;
  const ProductBanner({super.key, required this.imgArr});

  @override
  _ProductBannerState createState() => _ProductBannerState();
}

class _ProductBannerState extends State<ProductBanner> {
  PageController? _pageController;
  int _currentPage = 0;
  late List<String> _imgArr = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _imgArr = widget.imgArr;

    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth, // 가로 길이를 화면 전체로 설정
      height: screenWidth, // 세로 길이도 가로 길이와 동일하게 설정
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _imgArr.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                child: Image.network(
                  _imgArr[index],
                  fit: BoxFit.cover, // 이미지가 컨테이너를 꽉 채우도록 설정
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
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
                    style: TextStyle( fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 13),
                        color: Colors.white),
                  ),
                  Text(
                    '/${_imgArr.length}',
                    style: TextStyle( fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 13),
                        color: Color(0x80FFFFFF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
