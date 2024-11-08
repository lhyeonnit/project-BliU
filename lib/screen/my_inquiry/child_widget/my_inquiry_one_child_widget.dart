import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/_component/non_data_screen.dart';
import 'package:BliU/screen/inquiry_one_detail/inquiry_one_detail_screen.dart';
import 'package:BliU/screen/my_inquiry/view_model/my_inquiry_one_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyInquiryOneChildWidget extends ConsumerWidget {
  final ScrollController _scrollController = ScrollController();

  MyInquiryOneChildWidget({super.key});

  void _getList(bool isNew, WidgetRef ref) {
    final viewModel = ref.read(myInquiryOneViewModelProvider.notifier);
    final model = ref.read(myInquiryOneViewModelProvider);
    int currentPage = model.currentPage;
    if (isNew) {
      currentPage = 1;
      viewModel.setCurrentPage(currentPage);
    }
    SharedPreferencesManager.getInstance().then((pref) {
      Map<String, dynamic> requestData = {
        'mt_idx': pref.getMtIdx(),
        'qna_type': 1,
        'pg': currentPage,
      };

      viewModel.clearQnaList();
      viewModel.getList(requestData);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _getList(true, ref);
    return Consumer(
      builder: (context, ref, widget) {
        final viewModel = ref.read(myInquiryOneViewModelProvider.notifier);
        final model = ref.watch(myInquiryOneViewModelProvider);
        final count = model.count;
        final qnaList = model.qnaList;
        final totalPages = model.totalPages;
        final currentPage = model.currentPage;

        String currentPageStr = currentPage.toString();
        if (currentPage < 10) {
          currentPageStr = "0$currentPage";
        }

        String totalPagesStr = totalPages.toString();
        if (totalPages < 10) {
          totalPagesStr = "0$totalPages";
        }

        return Stack(
          children: [
            Visibility(
              visible: count > 0 ? false : true,
              child: const NonDataScreen(text: '등록된 내역이 없습니다.',),
            ),
            Visibility(
              visible: count > 0,
              child: Container(
              margin: const EdgeInsets.only(top: 10),
              color: Colors.white,
              child: Column(
                children: [
                  // 문의 리스트
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: qnaList.length,
                      itemBuilder: (context, index) {
                        final qnaData = qnaList[index];

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
                                ),
                              ),
                              onTap: () async {
                                int? qtIdx = qnaData.qtIdx;
                                if (qtIdx != null) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InquiryOneDetailScreen(qtIdx: qtIdx,),
                                    ),
                                  );
                                  if (result == true) {
                                    _getList(true, ref);
                                  }
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
                                  viewModel.setCurrentPage(currentPage - 1);
                                  _getList(false, ref);
                                }
                              },
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
                                  viewModel.setCurrentPage(currentPage + 1);
                                  _getList(false, ref);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
            MoveTopButton(scrollController: _scrollController)
          ],
        );
      },
    );
  }
}
