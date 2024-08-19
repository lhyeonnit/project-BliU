import 'package:flutter/material.dart';

class ProductFilterBottom extends StatelessWidget {
  final List<String> ageOptions;
  final List<String> styleOptions;
  final List<String> selectedAgeOption;
  final List<String> selectedStyleOption;
  final ValueChanged<String> onAgeOptionSelected;
  final ValueChanged<String> onStyleOptionSelected;
  final VoidCallback onResetFilters;
  final VoidCallback onApplyFilters;

  const ProductFilterBottom({
    Key? key,
    required this.ageOptions,
    required this.styleOptions,
    required this.selectedAgeOption,
    required this.selectedStyleOption,
    required this.onAgeOptionSelected,
    required this.onStyleOptionSelected,
    required this.onResetFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '연령',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: ageOptions.map((String option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedAgeOption.contains(option),
                  selectedColor: Colors.pinkAccent,
                  onSelected: (bool selected) {
                    onAgeOptionSelected(option);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            Text(
              '스타일',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: styleOptions.map((String option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedStyleOption.contains(option),
                  selectedColor: Colors.pinkAccent,
                  onSelected: (bool selected) {
                    onStyleOptionSelected(option);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 새로고침 버튼
                IconButton(
                  onPressed: () {
                    onResetFilters();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                ),
                // 상품보기 버튼
                ElevatedButton(
                  onPressed: () {
                    onApplyFilters();  // 필터를 적용하는 함수 호출
                    Navigator.pop(context); // 모달 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // 버튼 배경색을 회색으로 설정
                  ),
                  child: Text(
                    '상품보기',
                    style: TextStyle(
                      color: Colors.white, // 텍스트 색상을 흰색으로 설정
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show(
      BuildContext context, {
        required List<String> ageOptions,
        required List<String> styleOptions,
        required List<String> selectedAgeOption,
        required List<String> selectedStyleOption,
        required ValueChanged<String> onAgeOptionSelected,
        required ValueChanged<String> onStyleOptionSelected,
        required VoidCallback onResetFilters,
        required VoidCallback onApplyFilters,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: ProductFilterBottom(
            ageOptions: ageOptions,
            styleOptions: styleOptions,
            selectedAgeOption: selectedAgeOption,
            selectedStyleOption: selectedStyleOption,
            onAgeOptionSelected: onAgeOptionSelected,
            onStyleOptionSelected: onStyleOptionSelected,
            onResetFilters: onResetFilters,
            onApplyFilters: onApplyFilters,
          ),
        );
      },
    );
  }
}
