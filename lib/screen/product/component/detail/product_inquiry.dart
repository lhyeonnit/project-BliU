import 'package:BliU/data/qna_data.dart';
import 'package:BliU/screen/product/viewmodel/product_inquiry_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text(
            '상품문의',
            style: TextStyle(
              fontSize: Responsive.getFont(context, 24),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Consumer(
          builder: (context, ref, widget) {
            final model = ref.watch(productInquiryModelProvider);
            final list = model?.qnaListResponseDTO?.list ?? [];

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true, // 리스트가 다른 스크롤뷰 내에 있으므로 높이 제한
                  physics: const NeverScrollableScrollPhysics(), // 부모 스크롤에 따라 스크롤
                  itemCount: list.length, // 페이지당 문의 개수
                  itemBuilder: (context, index) {
                    final qnaData = list[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                qnaData.qtStatus == "Y" ? '답변완료' : '미답변',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(
                                  '${qnaData.mtId.toString().substring(0, 2)}   ${qnaData.qtWdate}',
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.lock, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  qnaData.qtTitle ?? "",
                                  style: TextStyle(
                                    fontSize: Responsive.getFont(context, 14),
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(thickness: 1, color: Colors.grey[300]),
                        ],
                      ),
                    );
                  },
                ),
                // TODO 페이징 처리 필요
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: currentPage > 1
                            ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                            : null,
                      ),
                      Text(
                        '${currentPage.toString().padLeft(2, '0')} / $totalPages',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 16)
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
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
              ],
            );
          }
        ),
      ],
    );
  }

  void _getList(bool isNew) async {
    // TODO 페이징 처리
    final pref = await SharedPreferencesManager.getInstance();
    Map<String, dynamic> requestData = {
      'mt_idx' : pref.getMtIdx(),
      'pt_idx' : ptIdx,
      'pg' : 1,
    };

    ref.read(productInquiryModelProvider.notifier).getList(requestData);
  }
}
