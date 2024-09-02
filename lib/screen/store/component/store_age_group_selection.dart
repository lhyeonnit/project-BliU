import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class StoreAgeGroupSelection extends StatefulWidget {
  final List<String> selectedAgeGroups;
  final ValueChanged<List<String>> onSelectionChanged;

  const StoreAgeGroupSelection({
    required this.selectedAgeGroups,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  _StoreAgeGroupSelectionState createState() => _StoreAgeGroupSelectionState();
}

class _StoreAgeGroupSelectionState extends State<StoreAgeGroupSelection> {
  late List<String> _tempSelectedAgeGroups;

  @override
  void initState() {
    super.initState();
    _tempSelectedAgeGroups = List.from(widget.selectedAgeGroups);
  }

  void _toggleSelection(String ageGroup) {
    setState(() {
      if (_tempSelectedAgeGroups.contains(ageGroup)) {
        _tempSelectedAgeGroups.remove(ageGroup);
      } else {
        _tempSelectedAgeGroups.add(ageGroup);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.getWidth(context, 412),
      padding:  const EdgeInsets.symmetric(vertical: 16.0),
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
           const SizedBox(height: 16.0),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 16),
             child: Text(
              '연령대',
              style: TextStyle(fontSize: Responsive.getFont(context, 18), fontWeight: FontWeight.bold),
                       ),
           ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAgeGroupChip('베이비(0-24개월)'),
                _buildAgeGroupChip('키즈(3-8세)'),
                _buildAgeGroupChip('주니어(9세이상)'),
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
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: const Color(0xFFDDDDDD))),
                  child: GestureDetector(
                    child: const Icon(Icons.refresh),
                    onTap: () {
                      setState(() {
                        _tempSelectedAgeGroups.clear();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: Responsive.getWidth(context, 9),
                ),
                Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)),color: Colors.black),
                  width: Responsive.getWidth(context, 336),
                  height: Responsive.getHeight(context, 48),
                  child: GestureDetector(
                    child:  const Center(child: Text('선택완료',style: TextStyle(color: Colors.white),)),
                    onTap: () {
                      widget.onSelectionChanged(_tempSelectedAgeGroups);
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

  Widget _buildAgeGroupChip(String ageGroup) {
    final isSelected = _tempSelectedAgeGroups.contains(ageGroup);
    return GestureDetector(
      onTap: () => _toggleSelection(ageGroup),
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
            color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
