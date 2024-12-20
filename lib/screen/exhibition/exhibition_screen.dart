import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/top_cart_button.dart';
import 'package:BliU/screen/exhibition/view_model/exhibition_view_model.dart';
import 'package:BliU/screen/product_list/item/product_list_item.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class ExhibitionScreen extends ConsumerStatefulWidget {
  final int etIdx;
  const ExhibitionScreen({super.key, required this.etIdx});

  @override
  ConsumerState<ExhibitionScreen> createState() => ExhibitionScreenState();
}

class ExhibitionScreenState extends ConsumerState<ExhibitionScreen> {
  final ScrollController _scrollController = ScrollController();

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

  void _afterBuild(BuildContext context) {
    _getDetail();
  }

  void _getDetail() async {
    final requestData = await _makeRequestData();
    ref.read(exhibitionViewModelProvider.notifier).listLoad(requestData);
  }

  void _nextLoad() async {
    if (_scrollController.position.extentAfter < 200) {
      final requestData = await _makeRequestData();
      ref.read(exhibitionViewModelProvider.notifier).listNextLoad(requestData);
    }
  }

  Future<Map<String, dynamic>> _makeRequestData() async {
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx() ?? "";

    Map<String, dynamic> requestData = {
      'et_idx': widget.etIdx,
      'mt_idx': mtIdx,
    };

    return requestData;
  }

  void _viewWillAppear(BuildContext context) {
    _getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context);
      },
      child: Consumer(
        builder: (context, ref, widget) {
          final model = ref.watch(exhibitionViewModelProvider);
          final exhibitionData = model.exhibitionData;
          final productList = model.productList;

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
              title: Text(exhibitionData?.etTitle ?? ""),
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
                    Navigator.pushNamed(context, '/search');
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
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CachedNetworkImage(
                              imageUrl: exhibitionData?.etDetailBanner ?? '',
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return SvgPicture.asset(
                                  'assets/images/no_imge.svg',
                                  width: double.infinity,
                                  height: 300,
                                  fit: BoxFit.contain,
                                );
                              },
                            ),
                            // TODO 다운로드 작업 필요
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                //margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '쿠폰 다운로드',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30, bottom: 10),
                          child: Text(
                            exhibitionData?.etTitle ?? "",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.getFont(context, 20),
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          exhibitionData?.etSubTitle ?? "",
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
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              final productData = productList[index];
                              return ProductListItem(productData: productData);
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
        },
      ),
    );
  }
}
