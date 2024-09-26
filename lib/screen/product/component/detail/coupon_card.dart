import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponCard extends StatefulWidget {
  final String discount;
  final String title;
  final String expiryDate;
  final String discountDetails;
  final String couponKey;
  final bool isDownloaded;
  final VoidCallback onDownload;

  const CouponCard({
    super.key,
    required this.discount,
    required this.title,
    required this.expiryDate,
    required this.discountDetails,
    required this.couponKey,
    required this.isDownloaded,
    required this.onDownload,
  });

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  @override
  Widget build(BuildContext context) {
    // 부모로부터 전달된 `isDownloaded` 상태 반영
    bool isDownloaded = widget.isDownloaded;

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        border: Border.all(
            style: BorderStyle.solid, color: const Color(0xFFDDDDDD)),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.discount,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 16),
                            fontWeight: FontWeight.bold,
                            color: isDownloaded
                                ? const Color(0xFFA4A4A4)
                                : const Color(0xFFFF6192),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 16),
                              fontWeight: FontWeight.bold,
                              color: isDownloaded
                                  ? const Color(0xFFA4A4A4)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.expiryDate,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: isDownloaded
                              ? const Color(0xFFA4A4A4)
                              : Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      widget.discountDetails,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: const Color(0xFFA4A4A4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFDDDDDD))),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isDownloaded ? null : widget.onDownload,
                    child: SvgPicture.asset(
                      isDownloaded
                          ? 'assets/images/store/ic_cu_down_end.svg'
                          : 'assets/images/store/ic_cu_down.svg',
                    ),
                  ),
                  if (isDownloaded) // 다운로드된 경우에만 텍스트 표시
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        child: Text(
                          '사용완료',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 12),
                            color: isDownloaded ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
