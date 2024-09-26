import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportPage extends StatefulWidget {
  final int rtIdx;
  const ReportPage({super.key, required this.rtIdx});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int? _selectedReason;
  final TextEditingController _controller = TextEditingController();
  bool _isReported = false;

  bool get _isOtherSelected => _selectedReason == 8;

  void _submitReport() {
    setState(() {
      _isReported = true;
    });
    // Dismiss the success message after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isReported = false;
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text("신고하기"),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: EdgeInsets.only(right: 16),
                child: SvgPicture.asset('assets/images/product/ic_close.svg')),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: ScrollController(),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      child: Text(
                        '신고의 부적합한 사용자/글을 지속적으로 신고하는 경우 제재 조치가 취해질 수 있으니 유의해 주세요',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Color(0xFF7B7B7B)),
                      ),
                    ),
                    _buildRadioOption(0, '거짓 정보 및 허위 사실'),
                    _buildRadioOption(1, '비속어 및 욕설'),
                    _buildRadioOption(2, '부적절한 사진 및 영상'),
                    _buildRadioOption(3, '개인정보 유출'),
                    _buildRadioOption(4, '광고 및 홍보'),
                    _buildRadioOption(5, '스팸 리뷰'),
                    _buildRadioOption(6, '타인 비방'),
                    _buildRadioOption(7, '리뷰의 무관성'),
                    _buildRadioOption(8, '기타'),
                    if (_isOtherSelected)
                      Container(
                        margin: EdgeInsets.only(
                            top: 10.0, bottom: 300, right: 16, left: 16),
                        child: TextField(
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                          ),
                          controller: _controller,
                          maxLines: 4,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 15),
                            hintText: '직접 입력해주세요',
                            hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: Color(0xFF595959)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (_isReported)
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xCC000000), // 알림창 배경색
                      borderRadius: BorderRadius.circular(22), // 둥근 모서리
                    ),
                    child: const Text(
                      "신고하기가 완료되었습니다!",
                      style: TextStyle(
                          fontFamily: 'Pretendard', color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _submitReport,
              child: Container(
                width: double.infinity,
                height: Responsive.getHeight(context, 48),
                margin:
                    EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 9),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
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

  Widget _buildRadioOption(int value, String label) {
    return Row(
      children: [
        Radio<int>(
          activeColor: Color(0xFFFF6192),
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (!states.contains(MaterialState.selected)) {
              return const Color(0xFFDDDDDD); // 비선택 상태의 라디오 버튼 색상
            }
            return const Color(0xFFFF6192); // 선택된 상태의 색상
          }),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: value,
          groupValue: _selectedReason,
          onChanged: (int? newValue) {
            setState(() {
              _selectedReason = newValue;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14)),
        ),
      ],
    );
  }
}
