import 'package:BliU/data/store_data.dart';
import 'package:BliU/screen/modal_dialog/message_dialog.dart';
import 'package:BliU/screen/modal_dialog/store_coupon_bottom.dart';
import 'package:BliU/screen/store_detail/view_model/store_info_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreInfoChildWidget extends ConsumerStatefulWidget {
  final StoreData? storeData;

  const StoreInfoChildWidget({super.key, required this.storeData});

  @override
  ConsumerState<StoreInfoChildWidget> createState() => StoreInfoChildWidgetState();
}

class StoreInfoChildWidgetState extends ConsumerState<StoreInfoChildWidget> {

  @override
  void initState() {
    super.initState();
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
                    return SizedBox(
                      width: 90,
                      height: 500,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/no_imge.svg',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  },
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
                        return SizedBox(
                          width: 70,
                          height: 70,
                          child: SvgPicture.asset('assets/images/no_imge_shop.svg'),
                        );
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
                              '즐겨찾기 ${widget.storeData?.stLike ?? 0}',
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
                  if (widget.storeData != null) {
                    StoreCouponBottom.showBottomSheet(context, widget.storeData!, (isAllDown) {
                      if (isAllDown) {
                        setState(() {
                          widget.storeData?.downCoupon = "N";
                        });
                      }
                    });
                  }
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
