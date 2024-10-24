import 'package:BliU/data/exhibition_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/search_screen.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/home/viewmodel/exhibition_view_model.dart';
import 'package:BliU/screen/product/component/list/product_list_card.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

//기획전
class ExhibitionScreen extends ConsumerStatefulWidget {
  final int etIdx;
  const ExhibitionScreen({super.key, required this.etIdx});

  @override
  ConsumerState<ExhibitionScreen> createState() => ExhibitionScreenState();
}

class ExhibitionScreenState extends ConsumerState<ExhibitionScreen> {
  final ScrollController _scrollController = ScrollController();
  ExhibitionData? _exhibitionData;
  List<ProductData> _productList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/exhibition/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        titleSpacing: -1.0,
        title: Text(_exhibitionData?.etTitle ?? ""),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
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
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/exhibition/ic_top_sch.svg"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          const TopCartButton(),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1/1.5,
                    child: Image.network(
                      _exhibitionData?.etDetailBanner ?? "",
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return const SizedBox();
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      _exhibitionData?.etTitle ?? "",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 20),
                        height: 1.2,
                      ),
                    ),
                  ),
                  Text(
                    _exhibitionData?.etSubTitle ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: const Color(0xFF7B7B7B),
                      height: 1.2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 30.0,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: _productList.length,
                      itemBuilder: (context, index) {
                        final productData = _productList[index];
                        return ProductListCard(productData: productData);
                      },
                    ),
                  ),
                ],
              ),
            ),
            MoveTopButton(scrollController: _scrollController)
          ],
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getDetail();
  }

  void _getDetail() async {
    Map<String, dynamic> requestData = {
      'et_idx': widget.etIdx,
    };

    final exhibitionDetailResponseDTO = await ref.read(exhibitionViewModelProvider.notifier).getDetail(requestData);
    if (exhibitionDetailResponseDTO != null) {
      if (exhibitionDetailResponseDTO.result == true) {
        setState(() {
          _exhibitionData = exhibitionDetailResponseDTO.data;
          _productList = exhibitionDetailResponseDTO.data?.product ?? [];
        });
      }
    }
  }
}
