import 'dart:io';

import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/smart_lens_screen.dart';
import 'package:BliU/screen/_component/viewmodel/smart_lens_view_model.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/screen/product/product_detail_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmartLensResult extends ConsumerStatefulWidget {
  final File imagePath;
  const SmartLensResult({super.key, required this.imagePath});

  @override
  ConsumerState<SmartLensResult> createState() => _SmartLensResultState();
}

class _SmartLensResultState extends ConsumerState<SmartLensResult> {
  final ScrollController _scrollController = ScrollController();
  List<ProductData> _productList = [];
  final bool result = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼이 눌렸을 때 실행할 동작 정의
        Navigator.pop(context);
        Navigator.pop(context);
        return false; // 뒤로가기 동작을 취소하고 직접 정의한 동작만 실행
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text('스마트렌즈'),
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          titleSpacing: -1.0,
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
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    height: 300, // 상단 이미지 높이 설정
                    child: Image.file(
                      widget.imagePath, // 크롭된 이미지 파일을 사용
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: result == true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFF4F4F4),
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 17, top: 15),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDDDDD),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 13, bottom: 20),
                            child: Text(
                              '이미지와 비슷한 상품',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 20),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          buildItemCard(), // 기존에 있는 메서드 호출
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: result == false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.5,
                  maxChildSize: 0.5,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 17, top: 15),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFFDDDDDD),
                                borderRadius: BorderRadius.circular(3),
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
                          Container(
                            margin: const EdgeInsets.only(bottom: 25, top: 23),
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
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Text('비슷한 상품을 찾지 못했어요',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 18),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Text('다른 이미지로 찾아보세요.',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                              color: const Color(0xFFA4A4A4),
                              height: 1.2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SmartLensScreen(),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: const Color(0xFFDDDDDD)),
                              ),
                              child: Center(
                                child: Text('다시 검색하기',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemCard() {
    return Expanded(
      child: GridView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 12,
          mainAxisSpacing: 30,
        ),
        itemCount: _productList.length,
        // 실제 상품 수로 변경
        itemBuilder: (context, index) {
          final productData = _productList[index];

          return ProductListCard(productData: productData);
        },
      ),
    );
  }
  void _afterBuild(BuildContext context) {
    _getList();
  }
  void _getList() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final MultipartFile file = MultipartFile.fromFileSync(
      widget.imagePath.path,
      contentType: DioMediaType("image", "jpg"),
    );
    final formData = FormData.fromMap({
      'mt_idx': mtIdx,
      'search_img': file,
    });

    final productListResponseDTO = await ref.read(smartLensModelProvider.notifier).getList(formData);
    setState(() {
      _productList = productListResponseDTO?.list ?? [];
    });
  }
}
