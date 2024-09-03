import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCouponCard extends StatefulWidget {

  final String discount;
  final String title;
  final String expiryDate;
  final String discountDetails;
  final String couponKey; // 쿠폰을 구분하기 위한 키
  final bool isDownloaded;
  final VoidCallback onDownload;

  const MyCouponCard({super.key,
    required this.discount,
    required this.title,
    required this.expiryDate,
    required this.discountDetails,
    required this.couponKey,
    required this.isDownloaded,  // 이 부분 추가
    required this.onDownload,
  });

  @override
  _MyCouponCardState createState() => _MyCouponCardState();
}

class _MyCouponCardState extends State<MyCouponCard> {
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _loadDownloadStatus(); // 쿠폰 발급 상태를 로드
  }

  // 쿠폰 발급 상태를 로드하는 함수
  Future<void> _loadDownloadStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? downloaded = prefs.getBool(widget.couponKey); // 쿠폰 발급 상태 불러오기
    if (downloaded != null && downloaded == true) {
      setState(() {
        isDownloaded = true;
      });
    }
  }

  // 쿠폰 발급 상태를 저장하는 함수
  Future<void> _saveDownloadStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.couponKey, value); // 쿠폰 발급 상태 저장
  }

  // 다운로드 클릭 이벤트 처리
  void _handleDownload() {
    setState(() {
      isDownloaded = true;
    });
    _saveDownloadStatus(true); // 상태 저장
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Color(0xFFDDDDDD),
          style: BorderStyle.none
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
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
                            color: isDownloaded ?  Color(0xFFA4A4A4) : Color(0xFFFF6192),
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
                        fontSize: 12,
                        color: Color(0xFFA4A4A4),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isDownloaded ? null : _handleDownload,
                    child: SvgPicture.asset(
                      isDownloaded ? 'assets/images/store/ic_cu_down_end.svg' : 'assets/images/store/ic_cu_down.svg',
                    ),
                  ),
                  // const SizedBox(height: 8),
                  SizedBox(
                    height: 16, // 고정된 공간을 차지하도록 설정
                    child: Text(
                      isDownloaded ? "발급완료" : '발급받기', // 발급 완료일 때만 표시
                      style: TextStyle(
                        fontSize: 12,
                        color: isDownloaded ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
