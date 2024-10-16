import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

// Custom ExpansionTile Widget
class CustomExpansionTile extends StatelessWidget {
  final String title;
  final Widget content;

  const CustomExpansionTile({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 19.5),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFEEEEEE),
                ),
              ),
            ),
            child: content,
          ),
        ],
      ),
    );
  }
}