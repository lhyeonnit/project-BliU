import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductFilterBottom extends StatefulWidget {
  final String selectedAgeOption;
  final List<String> selectedStyleOption;
  final RangeValues selectedRangeValuesOption;
  final ValueChanged<String> onAgeOptionSelected;
  final ValueChanged<List<String>> onStyleOptionSelected;
  final ValueChanged<RangeValues> onRangeValuesSelected;

  const ProductFilterBottom({
    super.key,
    required this.selectedAgeOption,
    required this.selectedStyleOption,
    required this.selectedRangeValuesOption,
    required this.onAgeOptionSelected,
    required this.onStyleOptionSelected,
    required this.onRangeValuesSelected,
  });

  @override
  _ProductFilterBottomState createState() => _ProductFilterBottomState();
}

class _ProductFilterBottomState extends State<ProductFilterBottom> {
  late String _tempSelectedAgeGroup;
  late List<String> _tempSelectedStyle;
  late RangeValues _tempSelectedRange;
  @override
  void initState() {
    super.initState();
    _tempSelectedAgeGroup = widget.selectedAgeOption;
    _tempSelectedStyle = List.from(widget.selectedStyleOption);
    _tempSelectedRange = widget.selectedRangeValuesOption;
  }

  void _toggleAgeSelection(String ageGroup) {
    setState(() {
      if (_tempSelectedAgeGroup == ageGroup) {
        _tempSelectedAgeGroup = "";
      } else {
        _tempSelectedAgeGroup = ageGroup;
      }
    });
  }

  void _toggleStyleSelection(String style) {
    setState(() {
      if (_tempSelectedStyle.contains(style)) {
        _tempSelectedStyle.remove(style);
      } else {
        _tempSelectedStyle.add(style);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 17, top: 15),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 80),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '연령',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 18),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAgeGroupChip('베이비(0-24개월)'),
                              _buildAgeGroupChip('키즈(3-8세)'),
                              _buildAgeGroupChip('주니어(9세이상)'),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Color(0xFFEEEEEE)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '스타일',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 18),
                                fontWeight: FontWeight.bold),
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
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Color(0xFFEEEEEE)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '가격',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 18),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              '${_tempSelectedRange.start.toInt()}원 ~ ${_tempSelectedRange.end.toInt()}원',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // 실제 RangeSlider
                        RangeSlider(
                          values: _tempSelectedRange,
                          min: 0,
                          max: 100000,
                          divisions: 100,
                          activeColor: Color(0xFFFF6192), // 슬라이더의 활성 부분 색상
                          inactiveColor: Color(0xFFEEEEEE), // 슬라이더의 비활성 부분 색상
                          labels: RangeLabels(
                            _tempSelectedRange.start.round().toString(),
                            _tempSelectedRange.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _tempSelectedRange = values; // 슬라이더 값 업데이트
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 11, right: 10, top: 9, bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: const Color(0xFFDDDDDD))),
                  child: GestureDetector(
                    child:
                        SvgPicture.asset('assets/images/store/ic_release.svg'),
                    onTap: () {
                      setState(() {
                        _tempSelectedAgeGroup = "";
                        _tempSelectedStyle.clear();
                        _tempSelectedRange = RangeValues(0, 0);
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
                        '상품보기',
                        style: TextStyle(color: Colors.white),
                      )),
                      onTap: () {
                        widget.onAgeOptionSelected(_tempSelectedAgeGroup);
                        widget.onStyleOptionSelected(_tempSelectedStyle);
                        widget.onRangeValuesSelected(_tempSelectedRange);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeGroupChip(String ageGroup) {
    final isSelected = _tempSelectedAgeGroup.contains(ageGroup);
    return GestureDetector(
      onTap: () => _toggleAgeSelection(ageGroup),
      child: Chip(
        label: Text(
          ageGroup,
          style: TextStyle(
            fontSize: Responsive.getFont(context, 14),
            color: isSelected ? const Color(0xFFFF6192) : Colors.black,
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

  Widget _buildStyleChip(String style) {
    final isSelected = _tempSelectedStyle.contains(style);
    return GestureDetector(
      onTap: () => _toggleStyleSelection(style),
      child: Chip(
        label: Text(
          style,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFF6192) : Colors.black,
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
