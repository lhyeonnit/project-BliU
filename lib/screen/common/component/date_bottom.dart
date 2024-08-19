import 'package:flutter/material.dart';

class DateBottom extends StatelessWidget {
  final Function(String) onDateSelected; // 선택된 날짜를 전달하기 위한 콜백 함수
  final String initialDate; // 초기 날짜

  DateBottom({required this.onDateSelected, this.initialDate = '출생년도 선택'});

  @override
  Widget build(BuildContext context) {
    String selectedYear = initialDate;
    String selectedMonth = '';
    String selectedDay = '';

    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '출생년도',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
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
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('선택하기'),
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
        physics: FixedExtentScrollPhysics(),
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
