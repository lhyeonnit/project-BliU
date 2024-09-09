import 'package:BliU/data/qna_data.dart';
import 'package:BliU/screen/mypage/viewmodel/service_inquiry_one_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'inquiry_one_detail.dart';

class ServiceInquiryOne extends ConsumerStatefulWidget {
  const ServiceInquiryOne({super.key});

  @override
  _ServiceInquiryOneState createState() => _ServiceInquiryOneState();
}

class _ServiceInquiryOneState extends ConsumerState<ServiceInquiryOne> {
  int currentPage = 1;
  final int itemsPerPage = 5; // 한 페이지에 보여줄 항목 수

  @override
  void initState() {
    super.initState();

    _getList(true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(serviceInquiryOneModelProvider);
        int count = model?.qnaListResponseDTO?.count ?? 0;
        List<QnaData> list = model?.qnaListResponseDTO?.list ?? [];

        // 페이지 수 계산
        int totalPages = 0;
        if (count > 0) {
          totalPages = (count / itemsPerPage).ceil();
        }

        return Column(
          children: [
            // 문의 리스트
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: list.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final qnaData = list[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      title: Row(
                        children: [
                          Text(
                            qnaData.qtStatusTxt ?? "",
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 16),
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              qnaData.qtWdate ?? "",
                              style: TextStyle(
                                  fontSize: Responsive.getFont(context, 14),
                                  color: Colors.grey
                              )
                          ),
                        ],
                      ),
                      subtitle: Text(
                          qnaData.qtTitle ?? "",
                          style: const TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InquiryOneDetail(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            // 페이지 네비게이션
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: currentPage > 1
                          ? () {
                        setState(() {
                          currentPage--;
                        });
                      }
                          : null, // 첫 페이지일 때 비활성화
                    ),
                    Text(
                      '$currentPage / $totalPages',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: currentPage < totalPages
                          ? () {
                        setState(() {
                          currentPage++;
                        });
                      }
                          : null, // 마지막 페이지일 때 비활성화
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  void _getList(bool isNew) {
    if (isNew) {
      currentPage = 1;
      ref.read(serviceInquiryOneModelProvider)?.qnaListResponseDTO?.list?.clear();
    }

    SharedPreferencesManager.getInstance().then((pref) {
      Map<String, dynamic> requestData = {
        'mt_idx' : pref.getMtIdx(),
        'qna_type' : '1',
        'pg' : currentPage,
      };
      ref.read(serviceInquiryOneModelProvider.notifier).getList(requestData);
    });
  }
}
