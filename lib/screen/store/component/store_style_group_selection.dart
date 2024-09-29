import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StyleSelectionSheet extends StatefulWidget {
  final String selectedStyle;
  final ValueChanged<String> onSelectionChanged;

  const StyleSelectionSheet({
    required this.selectedStyle,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  _StyleSelectionSheetState createState() => _StyleSelectionSheetState();
}

class _StyleSelectionSheetState extends State<StyleSelectionSheet> {
  late String _tempSelectedStyle;

  @override
  void initState() {
    super.initState();
    _tempSelectedStyle = widget.selectedStyle;
  }

  void _toggleSelection(String style) {
    setState(() {
      if (_tempSelectedStyle == style) {
        _tempSelectedStyle = "";
      } else {
        _tempSelectedStyle = style;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 15, bottom: 17),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '스타일',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: Responsive.getFont(context, 18),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.only(bottom: 10),
          child: Wrap(
            spacing: 4.0,
            children: [
              _buildStyleChip('캐주얼 (Casual)'),
              _buildStyleChip('스포티 (Sporty)'),
              _buildStyleChip('포멀 / 클래식 (Formal/Classic)'),
              _buildStyleChip('베이직 (Basic)'),
              _buildStyleChip('프린세스 / 페어리 (Princess/Fairy)'),
              _buildStyleChip('힙스터 (Hipster)'),
              _buildStyleChip('럭셔리 (Luxury)'),
              _buildStyleChip('어반 스트릿 (Urban Street)'),
              _buildStyleChip('로맨틱 (Romantic)'),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 11, right: 10, top: 9, bottom: 8),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
            color: Color(0xD000000),
          ))),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: const Color(0xFFDDDDDD))),
                child: GestureDetector(
                  child: SvgPicture.asset('assets/images/store/ic_release.svg'),
                  onTap: () {
                    setState(() {
                      _tempSelectedStyle = "";
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 9),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.black),
                  width: double.infinity,
                  height: 48,
                  child: GestureDetector(
                    child: const Center(
                      child: Text(
                        '선택완료',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Colors.white,
                          height: 1.2,
                        ),
                      )
                    ),
                    onTap: () {
                      widget.onSelectionChanged(_tempSelectedStyle);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStyleChip(String style) {
    final isSelected = _tempSelectedStyle.contains(style);
    return GestureDetector(
      onTap: () => _toggleSelection(style),
      child: Chip(
        label: Text(
          style,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: isSelected ? const Color(0xFFFF6192) : Colors.black,
            height: 1.2,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color:
                isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
