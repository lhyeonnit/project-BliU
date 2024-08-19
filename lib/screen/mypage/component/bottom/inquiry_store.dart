import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InquiryStore extends StatefulWidget {
  const InquiryStore({Key? key}) : super(key: key);

  @override
  _InquiryStoreState createState() => _InquiryStoreState();
}

class _InquiryStoreState extends State<InquiryStore> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '문의하기',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/login/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 문의 제목 입력
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '문의 제목 입력',
              ),
            ),
            const SizedBox(height: 16.0),

            // 문의 내용 입력
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '문의 내용을 최소 10자 이상 입력해 주세요.',
              ),
            ),
            const SizedBox(height: 16.0),

            // 이미지 선택 영역
            Row(
              children: [
                const Text(
                  '이미지',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                const Text(
                  '0/4',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // 이미지 선택 버튼
            GestureDetector(
              onTap: () {
                // 이미지 선택 동작 추가
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, size: 40, color: Colors.grey),
                    Text('사진선택', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // 등록 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 등록 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  '등록',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
