import 'package:BliU/screen/mypage/viewmodel/event_detail_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class EventDetail extends ConsumerWidget {
  final int btIdx;

  const EventDetail({super.key, required this.btIdx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> requestData = {
      'bt_idx' : btIdx,
    };

    ref.read(eventDetailModelProvider.notifier).getDetail(requestData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '이벤트',
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
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Consumer(
          builder: (context, ref, widget){
            final model = ref.watch(eventDetailModelProvider);
            if (model?.eventDetailResponseDTO?.result == false) {
              Utils.getInstance().showSnackBar(context, model?.eventDetailResponseDTO?.message ?? "");
            }

            final eventData = model?.eventDetailResponseDTO?.data;
            final btTitle = eventData?.btTitle ?? "";
            final btWdate = eventData?.btWdate ?? "";
            final btImage = eventData?.btImg ?? "";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        btTitle,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        btWdate,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                //Image.asset('assets/images/my/event_dt.png'),
                Image.network(btImage)
              ],
            );
          }
        ),
      ),
    );
  }
}
