import 'package:BliU/data/store_data.dart';
import 'package:BliU/screen/_component/message_dialog.dart';
import 'package:BliU/screen/store/viewmodel/store_info_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreInfoPage extends ConsumerStatefulWidget {
  final StoreData? storeData;

  const StoreInfoPage({super.key, required this.storeData});

  @override
  ConsumerState<StoreInfoPage> createState() => StoreInfoPageState();
}

class StoreInfoPageState extends ConsumerState<StoreInfoPage> {

  @override
  void initState() {
    super.initState();
  }
  Future<void> _downloadCoupon() async {
    // 쿠폰 다운로드를 위한 requestData 준비
    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();
    final Map<String, dynamic> requestData = {
      'mt_idx': mtIdx,
      'st_idx': widget.storeData?.stIdx, // 실제 쿠폰 ID 값을 여기 넣어야 합니다
    };

    try {
      // 쿠폰 다운로드 요청 수행
      await ref.read(storeInfoViewModelProvider.notifier).downStoreCoupon(requestData);

      // 다운로드가 완료되었으면 사용자에게 알림
      final storeDownloadResponse = ref.read(storeInfoViewModelProvider)?.storeDownloadResponseDTO;
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, storeDownloadResponse!.data.toString());
      setState(() {
        widget.storeData?.downCoupon = "N";
      });
    } catch (e) {
      // 오류 발생 시 로그 및 사용자에게 알림
      print("쿠폰 다운로드 중 오류 발생: $e");
      if (!mounted) return;
      Utils.getInstance().showSnackBar(context, "쿠폰 다운로드 중 오류가 발생했습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack으로 이미지와 로고를 겹치기
          Stack(
            clipBehavior: Clip.none, // 클리핑을 하지 않도록 설정
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.storeData?.stBackground ?? "",
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const SizedBox();
                  }
                ),
              ),
              Positioned(
                bottom: -30, // 이미지 하단에 겹치도록 설정
                left: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29000000),
                        blurRadius: 3.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.storeData?.stProfile ?? "",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return const SizedBox();
                      }
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
          // 상점 정보 부분
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상점명 및 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.storeData?.stName ?? "",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.storeData?.stStyleTxt?.split(',').first ?? ""}, ${widget.storeData?.stAgeTxt ?? ""}',
                        // 쉼표로 분리 후 첫 번째 값만 가져옴
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 13),
                          color: const Color(0xFF7B7B7B),
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // 즐겨찾기 및 아이콘
                GestureDetector(
                  onTap: () async {
                    final pref = await SharedPreferencesManager.getInstance();
                    final mtIdx = pref.getMtIdx() ?? "";

                    if (mtIdx.isEmpty) {
                      if(!context.mounted) return;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const MessageDialog(title: "알림", message: "로그인이 필요합니다.",);
                          }
                      );
                      return;
                    }

                    Map<String, dynamic> requestData = {
                      'mt_idx': mtIdx,
                      'st_idx': widget.storeData?.stIdx ?? 0,
                    };
                    final responseData = await ref.read(storeInfoViewModelProvider.notifier).toggleLike(requestData);
                    if (responseData != null) {
                      if (responseData["result"] == true) {
                        setState(() {
                          if (widget.storeData?.checkMark == "Y") {
                            widget.storeData?.checkMark = "N";
                            widget.storeData?.stLike = (widget.storeData?.stLike ?? 0) - 1;
                          } else {
                            widget.storeData?.checkMark = "Y";
                            widget.storeData?.stLike = (widget.storeData?.stLike ?? 0) + 1;
                          }
                        });
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '즐겨찾기 ${widget.storeData?.stLike}',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(width: 8), // 텍스트와 아이콘 사이의 간격

                            widget.storeData?.checkMark == "Y" ? SvgPicture.asset(
                              'assets/images/store/book_mark.svg',
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFFF6192),
                                BlendMode.srcIn,
                              ),
                            ) : SvgPicture.asset('assets/images/store/book_mark.svg'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 설명 텍스트
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              widget.storeData?.stTxt2 ?? '',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: Responsive.getFont(context, 14),
                color: const Color(0xFF7B7B7B),
                height: 1.2,
              ),
            ),
          ),
          // 쿠폰 다운로드 버튼
          Visibility(
            visible: widget.storeData?.downCoupon == "Y" ? true : false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              margin: const EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () {
                  _downloadCoupon();
                },
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                  ),
                  child: Center(
                    child: Text(
                      '쿠폰 다운로드',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
