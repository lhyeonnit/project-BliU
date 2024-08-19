import 'package:flutter/material.dart';

import 'dashe_border_painter.dart';

class CustomStyles {
  static const Color primaryColor = Colors.white;
  static const Color textColor = Color(0xFF222222);
  static const Color greyColor = Color(0xFFD5D5DB);
  static const Color borderColor = Color(0xFFE7E7E7);
  static const Color shadowColor = Colors.black;
  static const Color redColor = Color(0xFFF32828);

  static final double defaultPadding = 16.0;

  static final BoxDecoration shadowBoxDecoration = BoxDecoration(
    color: primaryColor,
    boxShadow: [
      BoxShadow(
        color: shadowColor.withOpacity(0.1),
        blurRadius: 5.0,
        offset: Offset(0, 4),
      ),
    ],
  );

  static final TextStyle headerTextStyle = TextStyle(
    color: textColor,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodyTextStyle = TextStyle(
    color: textColor,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle greyTextStyle = TextStyle(
    color: greyColor,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );

  static final BoxDecoration shadowBox1Decoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.12),
        blurRadius: 4.0,
        offset: Offset(0, 0),
      ),
    ],
  );

  static final BoxDecoration footerBoxDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.circular(8.0),
  );
}

class DashedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: CustomStyles.primaryColor,
      child: CustomPaint(
        painter: DashedBorderPainter(color: CustomStyles.borderColor),
        child: Center(child: Text("Dashed Border")),
      ),
    );
  }
}
