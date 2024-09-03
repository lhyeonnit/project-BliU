import 'package:BliU/data/coupon_data.dart';
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
  _MyCouponCardState createState() => _MyCouponCardState();
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
    return isDownloaded && widget.isDownloaded
        ? Container() // 발급 완료된 쿠폰은 사용 가능 목록에서 숨김
        : buildCouponCard(context);
  }

  Widget buildCouponCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: Color(0xFFDDDDDD)),
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
                            fontSize: Responsive.getFont(context, 16),
                            fontWeight: FontWeight.bold,
                            color: isDownloaded ? Color(0xFFA4A4A4) : Color(0xFFFF6192),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: Responsive.getFont(context, 16),
                              fontWeight: FontWeight.bold,
                              color: isDownloaded ? Color(0xFFA4A4A4) : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.expiryDate,
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: isDownloaded ? Color(0xFFA4A4A4) : Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      widget.discountDetails,
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 12),
                        color: Color(0xFFA4A4A4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFDDDDDD))),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isDownloaded ? null : _handleDownload,
                    child: SvgPicture.asset(
                      isDownloaded ? 'assets/images/store/ic_cu_down_end.svg' : 'assets/images/store/ic_cu_down.svg',
                    ),
                  ),
                  SizedBox(
                    height: 16,
                    child: Text(
                      isDownloaded ? "발급완료" : '발급받기',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDownloaded ? Colors.grey : Colors.black,
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