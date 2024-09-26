import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreAgeGroupSelection extends StatefulWidget {
  final String selectedAgeGroup;
  final ValueChanged<String> onSelectionChanged;

  const StoreAgeGroupSelection({
    required this.selectedAgeGroup,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  _StoreAgeGroupSelectionState createState() => _StoreAgeGroupSelectionState();
}

class _StoreAgeGroupSelectionState extends State<StoreAgeGroupSelection> {
  late String _tempSelectedAgeGroup;

  @override
  void initState() {
    super.initState();
    _tempSelectedAgeGroup = widget.selectedAgeGroup;
  }

  void _toggleSelection(String ageGroup) {
    setState(() {
      if (_tempSelectedAgeGroup == ageGroup) {
        _tempSelectedAgeGroup = "";
      } else {
        _tempSelectedAgeGroup = ageGroup;
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
            '연령대',
            style: TextStyle(
                fontFamily: 'Pretendard',
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
                      _tempSelectedAgeGroup = "";
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
                          fontFamily: 'Pretendard', color: Colors.white),
                    )),
                    onTap: () {
                      widget.onSelectionChanged(_tempSelectedAgeGroup);
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

  Widget _buildAgeGroupChip(String ageGroup) {
    final isSelected = _tempSelectedAgeGroup.contains(ageGroup);
    return GestureDetector(
      onTap: () => _toggleSelection(ageGroup),
      child: Chip(
        label: Text(
          ageGroup,
          style: TextStyle(
            fontFamily: 'Pretendard',
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
}
