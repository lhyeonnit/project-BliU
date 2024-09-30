import 'package:BliU/data/qna_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/mypage/component/bottom/component/inquiry_one_detail.dart';
import 'package:BliU/screen/mypage/viewmodel/service_inquiry_one_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceInquiryOne extends ConsumerStatefulWidget {
  const ServiceInquiryOne({super.key});

  @override
  ConsumerState<ServiceInquiryOne> createState() => _ServiceInquiryOneState();
}

class _ServiceInquiryOneState extends ConsumerState<ServiceInquiryOne> {
  int currentPage = 1;
  int totalPages = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.white,
          child: Consumer(builder: (context, ref, widget) {
            final model = ref.watch(serviceInquiryOneModelProvider);
            int count = model?.qnaListResponseDTO?.count ?? 0;
            List<QnaData> list = model?.qnaListResponseDTO?.list ?? [];

            if (count > 0) {
              totalPages = (count~/10);
              if ((count%10) > 0) {
                totalPages = totalPages + 1;
              }
            }

            String currentPageStr = currentPage.toString();
            if (currentPage < 10) {
              currentPageStr = "0$currentPage";
            }

            String totalPagesStr = totalPages.toString();
            if (totalPages < 10) {
              totalPagesStr = "0$totalPages";
            }

            return Column(
              children: [
                // 문의 리스트
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final qnaData = list[index];

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            title: Row(
                              children: [
                                Text(
                                  qnaData.qtStatusTxt ?? "",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 14),
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 11),
                                  child: Text(qnaData.qtWdate ?? "",
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 12),
                                      color: const Color(0xFF7B7B7B),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(qnaData.qtTitle ?? "",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                )
                            ),
                            onTap: () {
                              final qtIdx = qnaData.qtIdx;
                              if (qtIdx != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InquiryOneDetail(qtIdx: qtIdx,),
                                  ),
                                );
                              }
                            },
                          ),
                          const Divider(thickness: 1, color: Color(0xFFEEEEEE),),
                        ],
                      );
                    },
                  ),
                ),
                // 페이지 네비게이션
                Visibility(
                  visible: count == 0 ? false : true,
                  child: Container(
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
                                  _getList();
                                });
                              }
                            }
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  currentPageStr,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 16),
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                                Text(
                                  ' / $totalPagesStr',
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
                                  _getList();
                                });
                              }
                            }
                          ),
                        ],
                      ),
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

  void _afterBuild(BuildContext context) {
    _getList();
  }

  void _getList() {
    SharedPreferencesManager.getInstance().then((pref) {
      Map<String, dynamic> requestData = {
        'mt_idx': pref.getMtIdx(),
        'qna_type': 1,
        'pg': currentPage,
      };
      ref.read(serviceInquiryOneModelProvider)?.qnaListResponseDTO?.list?.clear();
      ref.read(serviceInquiryOneModelProvider.notifier).getList(requestData);
    });
  }
}
