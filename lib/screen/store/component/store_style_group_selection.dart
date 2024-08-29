import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class StyleSelectionSheet extends StatefulWidget {
  final List<String> selectedStyles;
  final ValueChanged<List<String>> onSelectionChanged;

  const StyleSelectionSheet({
    required this.selectedStyles,
    required this.onSelectionChanged,
    Key? key,
  }) : super(key: key);

  @override
  _StyleSelectionSheetState createState() => _StyleSelectionSheetState();
}

class _StyleSelectionSheetState extends State<StyleSelectionSheet> {
  late List<String> _tempSelectedStyles;

  @override
  void initState() {
    super.initState();
    _tempSelectedStyles = List.from(widget.selectedStyles);
  }

  void _toggleSelection(String style) {
    setState(() {
      if (_tempSelectedStyles.contains(style)) {
        _tempSelectedStyles.remove(style);
      } else {
        _tempSelectedStyles.add(style);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.getWidth(context, 412),
      padding:  EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '스타일',
              style: TextStyle(fontSize: Responsive.getFont(context, 18), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
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
          SizedBox(height: Responsive.getHeight(context, 20)),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: Responsive.getWidth(context, 9)),
            child: Row(
              children: [
                Container(
                  width: Responsive.getWidth(context, 48),
                  height: Responsive.getHeight(context, 48),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: Color(0xFFDDDDDD))),
                  child: GestureDetector(
                    child: Icon(Icons.refresh),
                    onTap: () {
                      setState(() {
                        _tempSelectedStyles.clear();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: Responsive.getWidth(context, 9),
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)),color: Colors.black),
                  width: Responsive.getWidth(context, 336),
                  height: Responsive.getHeight(context, 48),
                  child: GestureDetector(
                    child:  Center(child: Text('선택완료',style: TextStyle(color: Colors.white),)),
                    onTap: () {
                      widget.onSelectionChanged(_tempSelectedStyles);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleChip(String style) {
    final isSelected = _tempSelectedStyles.contains(style);
    return GestureDetector(
      onTap: () => _toggleSelection(style),
      child: Chip(
        label: Text(
          style,
          style: TextStyle(
            color: isSelected ? Color(0xFFFF6192) : Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? Color(0xFFFF6192) : Colors.grey,
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
