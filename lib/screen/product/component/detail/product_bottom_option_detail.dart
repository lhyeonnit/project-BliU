import 'package:BliU/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductBottomOptionDetail extends StatelessWidget {
  final VoidCallback onRemove; // 삭제 함수

  const ProductBottomOptionDetail({
    super.key,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F9F9),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '베이지 / 110',
                  style: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                  ),
                ),
                GestureDetector(
                  onTap: onRemove, // 삭제 함수 호출
                  child: SvgPicture.asset('assets/images/ic_del.svg'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Responsive.getWidth(context, 96),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                  border: Border.all(color: const Color(0xFFE3E3E3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Icon(CupertinoIcons.minus, size: 20),
                      onTap: () {},
                    ),
                    const Text('1', style: TextStyle(fontSize: 14)),
                    GestureDetector(
                      child: const Icon(Icons.add, size: 20),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const Text(
                '9,900원',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

