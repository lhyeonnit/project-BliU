

import 'package:BliU/data/qna_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_non/non_mypage/bottom/component/non_inquiry_one_detail.dart';
import 'package:BliU/screen/mypage/viewmodel/service_inquiry_one_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NonServiceInquiryOne extends ConsumerStatefulWidget {
  const NonServiceInquiryOne({super.key});

  @override
  _NonServiceInquiryOneState createState() => _NonServiceInquiryOneState();
}

class _NonServiceInquiryOneState extends ConsumerState<NonServiceInquiryOne> {
  int currentPage = 1;
  final int itemsPerPage = 5; // 한 페이지에 보여줄 항목 수
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _getList(true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          color: Colors.white,
          child: Consumer(builder: (context, ref, widget) {
            final model = ref.watch(serviceInquiryOneModelProvider);
            int count = model?.qnaListResponseDTO?.count ?? 0;
            List<QnaData> list = model?.qnaListResponseDTO?.list ?? [];

            // TODO 페이징 처리 필요
            // 페이지 수 계산
            int totalPages = 0;
            if (count > 0) {
              totalPages = (count / itemsPerPage).ceil();
            }

            return Column(
              children: [
                // 문의 리스트
                ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final qnaData = list[index];

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          title: Row(
                            children: [
                              Text(
                                qnaData.qtStatusTxt ?? "",
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    fontWeight: FontWeight.w600),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 11),
                                child: Text(qnaData.qtWdate ?? "",
                                    style: TextStyle(
                                        fontSize: Responsive.getFont(context, 12),
                                        color: Color(0xFF7B7B7B))),
                              ),
                            ],
                          ),
                          subtitle: Text(qnaData.qtTitle ?? "",
                              style: TextStyle(fontSize: Responsive.getFont(context, 14),
                                  fontWeight: FontWeight.w400)),
                          onTap: () {
                            final qtIdx = qnaData.qtIdx;
                            if (qtIdx != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NonInquiryOneDetail(
                                    qtIdx: qtIdx,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Divider(
                          thickness: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                      ],
                    );
                  },
                ),

                // 페이지 네비게이션
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/images/product/pager_prev.svg'),
                          onPressed: currentPage > 1
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                '${currentPage.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: Responsive.getFont(context, 16),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' / $totalPages',
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 16),
                                    color: Color(0xFFCCCCCC),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/images/product/pager_next.svg'),
                          onPressed: currentPage < totalPages
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        MoveTopButton(scrollController: _scrollController)
      ],
    );
  }

  void _getList(bool isNew) {
    if (isNew) {
      currentPage = 1;
      ref
          .read(serviceInquiryOneModelProvider)
          ?.qnaListResponseDTO
          ?.list
          ?.clear();
    }

    SharedPreferencesManager.getInstance().then((pref) {
      Map<String, dynamic> requestData = {
        'mt_idx': pref.getMtIdx(),
        'qna_type': 1,
        'pg': currentPage,
      };
      ref.read(serviceInquiryOneModelProvider.notifier).getList(requestData);
    });
  }
}
