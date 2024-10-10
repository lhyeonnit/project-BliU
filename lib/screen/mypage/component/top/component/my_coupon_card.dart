import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCouponCard extends StatefulWidget {
  final String discount;
  final String title;
  final String expiryDate;
  final String discountDetails;
  final String couponKey;
  final bool isDownloaded;
  final VoidCallback onDownload;

  const MyCouponCard({
    Key? key,
    required this.discount,
    required this.title,
    required this.expiryDate,
    required this.discountDetails,
    required this.couponKey,
    required this.isDownloaded,
    required this.onDownload,
  }) : super(key: key);

  @override
  State<MyCouponCard> createState() => _MyCouponCardState();
}

class _MyCouponCardState extends State<MyCouponCard> {
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _loadDownloadStatus();
  }

  Future<void> _loadDownloadStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? downloaded = prefs.getBool(widget.couponKey);
    if (downloaded != null && downloaded == true) {
      setState(() {
        isDownloaded = true;
      });
    }
  }

  Future<void> _saveDownloadStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.couponKey, value);
  }

  void _handleDownload() {
    setState(() {
      isDownloaded = true;
    });
    _saveDownloadStatus(true);
    widget.onDownload(); // 발급 시 동작 추가
  }

  @override
  Widget build(BuildContext context) {
    // "사용가능" 목록에서 이미 다운로드된 쿠폰은 숨기고, "완료/만료" 목록에서만 표시
    if (isDownloaded && !widget.isDownloaded) {
      return Container();
    }

    return buildCouponCard(context);
  }

  Widget buildCouponCard(BuildContext context) {
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
              flex: 8,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.discount,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 16),
                            fontWeight: FontWeight.bold,
                            color: isDownloaded ? const Color(0xFFA4A4A4) : const Color(0xFFFF6192),
                            height: 1.2,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 16),
                                fontWeight: FontWeight.bold,
                                color: isDownloaded ? const Color(0xFFA4A4A4) : Colors.black,
                                height: 1.2,
                              ),
                              softWrap: true,
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
                          color: isDownloaded ? const Color(0xFFA4A4A4) : Colors.black,
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
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Color(0xFFDDDDDD))),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isDownloaded == true ? null : _handleDownload,
                      child: SvgPicture.asset(
                        isDownloaded
                            ? 'assets/images/store/ic_cu_down_end.svg'
                            : 'assets/images/store/ic_cu_down.svg',
                      ),
                    ),
                    if (isDownloaded == true) // 다운로드된 경우에만 텍스트 표시
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          child: Text(
                            '사용완료',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 12),
                              color: Colors.grey,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
