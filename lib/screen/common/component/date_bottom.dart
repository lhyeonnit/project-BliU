import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';

class DateBottom extends StatelessWidget {
  final Function(String) onDateSelected; // 선택된 날짜를 전달하기 위한 콜백 함수
  final String initialDate; // 초기 날짜

  const DateBottom({super.key, required this.onDateSelected, this.initialDate = '출생년도 선택'});

  @override
  Widget build(BuildContext context) {
    String selectedYear = initialDate;
    String selectedMonth = '';
    String selectedDay = '';

    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '출생년도',
                style: TextStyle(
                  fontSize: Responsive.getFont(context, 18),
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 연도 선택
                _buildDateColumn(context, 2020, 2024, (year) {
                  selectedYear = '$year년';
                }),
                // 월 선택
                _buildDateColumn(context, 1, 12, (month) {
                  selectedMonth = ' $month월';
                }),
                // 일 선택
                _buildDateColumn(context, 1, 31, (day) {
                  selectedDay = ' $day일';
                }),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onDateSelected('$selectedYear$selectedMonth$selectedDay');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('선택하기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(BuildContext context, int start, int end, Function(int) onSelected) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          onSelected(start + index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return index + start <= end
                ? Center(child: Text('${start + index}'))
                : null;
          },
          childCount: end - start + 1,
        ),
      ),
    );
  }
}
