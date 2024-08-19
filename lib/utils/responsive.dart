import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Responsive {
  static const double _figmaWidth = 412.0; // FIGMA 기준 창 너비
  static const double _figmaHeight = 760.0; // FIGMA 기준 창 높이

  // 화면 너비에 따라 비율 계산
  static double getWidth(BuildContext context, double width) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (width / _figmaWidth) * screenWidth;
  }

  // 화면 높이에 따라 비율 계산
  static double getHeight(BuildContext context, double height) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (height / _figmaHeight) * screenHeight;
  }

  // 폰트 크기 계산
  static double getFont(BuildContext context, double fontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (fontSize / _figmaWidth) * screenWidth;
  }
}
