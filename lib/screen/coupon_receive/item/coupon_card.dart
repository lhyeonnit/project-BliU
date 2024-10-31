import 'package:BliU/utils/responsive.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponCard extends StatefulWidget {
  final String discount;
  final String title;
  final String expiryDate;
  final String discountDetails;
  final String couponKey;
  final bool isDownload;
  final VoidCallback onDownload;

  const CouponCard({
    super.key,
    required this.discount,
    required this.title,
    required this.expiryDate,
    required this.discountDetails,
    required this.couponKey,
    required this.isDownload,
    required this.onDownload,
  });

  @override
  State<CouponCard> createState() => CouponCardState();
}

class CouponCardState extends State<CouponCard> {
  @override
  Widget build(BuildContext context) {
    // 부모로부터 전달된 `isDownloaded` 상태 반영
    bool isDownload = widget.isDownload;

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          color: const Color(0xFFDDDDDD),
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
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
                            color: isDownload ? const Color(0xFFFF6192) : const Color(0xFFA4A4A4),
                            height: 1.2,
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
                              color: isDownload ? Colors.black :const Color(0xFFA4A4A4),
                              height: 1.2,
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
                          color: isDownload ? Colors.black : const Color(0xFFA4A4A4),
                          height: 1.2,
                        ),
                      ),
                    ),
                    Text(
                      widget.discountDetails,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 12),
                        color: const Color(0xFFA4A4A4),
                        height: 1.2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      child: Text(
                        '다른 쿠폰과 중복 사용불가',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 12),
                          color: const Color(0xFFA4A4A4),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const DottedLine(
              dashColor: Color(0xFFDDDDDD),
              direction: Axis.vertical,
              lineLength: 135,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isDownload ? widget.onDownload : null,
                    child: SvgPicture.asset(
                      isDownload ? 'assets/images/store/ic_cu_down.svg' : 'assets/images/store/ic_cu_down_end.svg',
                    ),
                  ),
                  if (!isDownload) // 다운로드된 경우에만 텍스트 표시
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        child: Text(
                          '사용완료',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 12),
                            color: isDownload ? Colors.black : Colors.grey,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
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
