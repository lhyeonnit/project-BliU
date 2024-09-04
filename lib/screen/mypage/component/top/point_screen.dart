import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PointScreen extends StatefulWidget {
  const PointScreen({super.key});

  @override
  _PointScreenState createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  final ScrollController _scrollController = ScrollController();

  List<String> categories = ['전체', '적립', '사용'];

  final List<Map<String, String>> pointData = [
    {
      'type': '적립',
      'point': '+530P',
      'description': '구매확정 적립',
      'date': '2023-01-01'
    },
    {
      'type': '차감',
      'point': '-530P',
      'description': '결제시 사용',
      'date': '2023-01-01'
    },
    {
      'type': '차감',
      'point': '-530P',
      'description': '결제시 사용',
      'date': '2023-01-01'
    },
    {
      'type': '적립',
      'point': '+530P',
      'description': '이벤트참여 적립',
      'date': '2023-01-01'
    },
    // 추가 데이터 삽입 가능
  ];
  int selectedCategoryIndex = 0;

  List<Map<String, String>> getFilteredPointData() {
    List<Map<String, String>> filteredPoints;

    if (selectedCategoryIndex == 0) {
      // 전체 보기
      filteredPoints = pointData;
    } else if (selectedCategoryIndex == 1) {
      // 적립 보기
      filteredPoints =
          pointData.where((point) => point['type'] == '적립').toList();
    } else {
      // 사용 보기
      filteredPoints =
          pointData.where((point) => point['type'] == '차감').toList();
    }

    return filteredPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('포인트'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0xFFF4F4F4), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF4F4F4),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '나의 포인트',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.black),
                      ),
                      Text(
                        '5,100P',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 38,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final bool isSelected = selectedCategoryIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: FilterChip(
                          label: Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              color: isSelected
                                  ? Colors.pink
                                  : Colors.black, // 텍스트 색상
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.white,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected ? Colors.pink : Colors.grey,
                              // 테두리 색상
                              width: 1.0,
                            ),
                          ),
                          showCheckmark: false, // 체크 표시 없애기
                        ),
                      );
                    },
                  ),
                ),
                const Divider(thickness: 10, color: Color(0xFFF5F9F9)),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: pointData.length,
                    itemBuilder: (context, index) {
                      // 데이터를 사용하여 아이템 생성
                      final pointItem = pointData[index];
                      return _buildPointItem(
                        pointItem['type']!,
                        pointItem['point']!,
                        pointItem['description']!,
                        pointItem['date']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }

  Widget _buildPointItem(
      String type, String point, String description, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(
              color: type == '적립' ? const Color(0xFFFF6192) : const Color(0xFF7B7B7B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                point,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Color(0xFF7B7B7B)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(color: Color(0xFF7B7B7B)),
          ),
        ],
      ),
    );
  }
}
