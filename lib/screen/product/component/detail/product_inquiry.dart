import 'package:BliU/data/qna_data.dart';
import 'package:BliU/screen/product/viewmodel/product_inquiry_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ProductInquiry extends ConsumerStatefulWidget {
  final int? ptIdx;

  const ProductInquiry({super.key, required this.ptIdx});

  @override
  _ProductInquiryState createState() => _ProductInquiryState();
}

class _ProductInquiryState extends ConsumerState<ProductInquiry> {
  late int ptIdx;
  int currentPage = 1;
  int totalPages = 10;

  @override
  void initState() {
    super.initState();
    ptIdx = widget.ptIdx ?? 0;
    _getList(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 10),
          height: 10,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F9F9),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Text(
            '상품문의',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 20),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        Consumer(builder: (context, ref, widget) {
          final model = ref.watch(productInquiryModelProvider);
          final list = model?.qnaListResponseDTO?.list ?? [];

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                // 리스트가 다른 스크롤뷰 내에 있으므로 높이 제한
                physics: const NeverScrollableScrollPhysics(),
                // 부모 스크롤에 따라 스크롤
                itemCount: list.length,
                // 페이지당 문의 개수
                itemBuilder: (context, index) {
                  final qnaData = list[index];

                  final qtStatus = qnaData.qtStatus;
                  final myQna = qnaData.myQna;

                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                qtStatus == "Y" ? '답변완료' : '미답변',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 11, right: 10),
                                child: Text(
                                  qnaData.mtId ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: const Color(0xFF7B7B7B),
                                    fontSize: Responsive.getFont(context, 12),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Text('${qnaData.qtWdate}',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: const Color(0xFF7B7B7B),
                                  fontSize: Responsive.getFont(context, 12),
                                  height: 1.2,
                                )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12, right: 16, left: 16),
                          child: Row(
                            children: [
                              myQna == "N" ? SvgPicture.asset('assets/images/product/ic_lock.svg') : const SizedBox(),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    qnaData.qtTitle ?? "",
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Divider(
                            thickness: 1,
                            color: Color(0xFFEEEEEE)
                          )
                        ),
                      ],
                    ),
                  );
                },
              ),

              // TODO 페이징 처리 필요
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset('assets/images/product/pager_prev.svg'),
                        onPressed: () {
                          if (currentPage > 1) {
                            setState(() {
                              currentPage--;
                            });
                          }
                        }
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              currentPage.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 16),
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              ' / $totalPages',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 16),
                                color: const Color(0xFFCCCCCC),
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset('assets/images/product/pager_next.svg'),
                        onPressed: () {
                          if (currentPage < totalPages) {
                            setState(() {
                              currentPage++;
                            });
                          }
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  void _getList(bool isNew) async {
    // TODO 페이징 처리
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx': pref.getMtIdx(),
      'pt_idx': ptIdx,
      'pg': 1,
    };

    ref.read(productInquiryModelProvider.notifier).getList(requestData);
  }
}
