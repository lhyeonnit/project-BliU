import 'package:flutter/material.dart';

class MoveTopButton extends StatelessWidget {
  final ScrollController scrollController; // 스크롤 컨트롤러 받기

  const MoveTopButton({super.key, required this.scrollController});

  void _moveToTop() {
    scrollController.animateTo(
      0.0, // 페이지 맨 위로 이동
      duration: const Duration(milliseconds: 500), // 애니메이션 시간
      curve: Curves.easeInOut, // 애니메이션 효과
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: _moveToTop, // 버튼을 누르면 맨 위로 이동
          child: Image.asset(
            'assets/images/gotop_btn.png',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      );
  }
}