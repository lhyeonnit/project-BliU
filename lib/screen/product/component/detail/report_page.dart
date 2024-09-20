import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int? _selectedReason;
  final TextEditingController _controller = TextEditingController();
  bool _isReported = false;

  void _submitReport() {
    setState(() {
      _isReported = true;
    });
    // Dismiss the success message after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isReported = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text("신고하기"),
        titleTextStyle: TextStyle(
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
           Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 16,vertical: 30),
                   child: Text(
                    '신고의 부적합한 사용자/글을 지속적으로 신고하는 경우 제재 조치가 취해질 수 있으니 유의해 주세요',
                    style: TextStyle(fontSize: Responsive.getFont(context, 14), color: Color(0xFF7B7B7B)),
                                   ),
                 ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildRadioOption(0, '거짓 정보 및 허위 사실'),
                      _buildRadioOption(1, '비속어 및 욕설'),
                      _buildRadioOption(2, '부적절한 사진 및 영상'),
                      _buildRadioOption(3, '개인정보 유출'),
                      _buildRadioOption(4, '광고 및 홍보'),
                      _buildRadioOption(5, '스팸 리뷰'),
                      _buildRadioOption(6, '타인 비방'),
                      _buildRadioOption(7, '리뷰의 무관성'),
                      _buildRadioOption(8, '기타'),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controller,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: '직접 입력해주세요',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('신고하기', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          if (_isReported)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "신고하기가 완료되었습니다!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(int value, String label) {
    return RadioListTile<int>(
      activeColor: Colors.pink,
      value: value,
      groupValue: _selectedReason,
      onChanged: (int? newValue) {
        setState(() {
          _selectedReason = newValue;
        });
      },
      title: Text(label),
    );
  }
}
