import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NonDataScreen extends StatelessWidget {
  final String text;
  const NonDataScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 200, bottom: 15),
            child: SvgPicture.asset('assets/images/product/no_data_img.svg',
              width: 90,
              height: 90,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 14),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF7B7B7B),
              height: 1.2,

            ),
          ),
        ],
      ),
    );
  }
}
