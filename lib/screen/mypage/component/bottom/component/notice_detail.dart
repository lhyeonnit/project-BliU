import 'package:BliU/screen/mypage/viewmodel/notice_detail_view_model.dart';
import 'package:BliU/screen/mypage/viewmodel/notice_list_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class NoticeDetail extends ConsumerWidget {
  final int ntIdx;

  const NoticeDetail({super.key, required this.ntIdx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> requestData = {
      'nt_idx' : ntIdx,
    };

    ref.read(noticeDetailModelProvider.notifier).getDetail(requestData);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '공지사항',
          style: TextStyle(
              color: Colors.black,
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, widget){
            final model = ref.watch(noticeDetailModelProvider);
            if (model?.noticeDetailResponseDTO?.result == false) {
              Utils.getInstance().showSnackBar(context, model?.noticeDetailResponseDTO?.message ?? "");
            }

            final noticeData = model?.noticeDetailResponseDTO?.data;
            final ntTitle= noticeData?.ntTitle ?? "";
            final ntWdate = noticeData?.ntWdate ?? "";
            final ntContent = noticeData?.ntContent ?? "";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        ntTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ntWdate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),
                const SizedBox(height: 24),
                Text(
                  ntContent,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
