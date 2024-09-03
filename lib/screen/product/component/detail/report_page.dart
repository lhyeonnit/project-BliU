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
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Removes default leading widget (back button)
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '신고하기',
              style: TextStyle(color: Colors.black),
            ),
            IconButton(
              icon: SvgPicture.asset("assets/images/product/ic_close.svg"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '신고의 부적합한 사용자/글을 지속적으로 신고하는 경우 제재 조치가 취해질 수 있으니 유의해 주세요',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
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
