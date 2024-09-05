import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/responsive.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final ScrollController _scrollController = ScrollController();

  // 배송 데이터 리스트
  final List<Map<String, String>> deliveryData = [
    {
      'time': '2020-12-01 11:11:11',
      'location': '서울 남대문',
      'status': '배달완료',
    },
    {
      'time': '2020-12-01 10:10:10',
      'location': '서울 남대문',
      'status': '배달출발',
    },
    {
      'time': '2020-12-01 09:09:09',
      'location': '남서울 터미널',
      'status': '배달전',
    },
    {
      'time': '2020-12-01 08:08:08',
      'location': '대전 HUB',
      'status': '간선상차',
    },
    {
      'time': '2020-12-01 07:07:07',
      'location': '서북직영',
      'status': '집하처리',
    },
    {
      'time': '2020-12-01 06:06:06',
      'location': '고객',
      'status': '인수자등록',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('배송현황'),
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
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Text(
                      '스마트택배 배송현황',
                      style: TextStyle(
                          fontSize: Responsive.getFont(context, 18),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('수령인',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black)),
                              Text('김크루',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('택배사',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black)),
                              Text('CJ대한통운',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 10,
                    width: double.infinity,
                    color: Color(0xFFF5F9F9),
                  ),

                  // 테이블 헤더
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '시간',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '현재위치',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '배송상태',
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 14),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // 데이터 리스트 표시 (배경색 반복)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: deliveryData.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> data = entry.value;
                        Color rowColor = index % 2 == 1
                            ? Colors.white // 짝수 행 색상
                            : Color(0xFFF5F9F9); // 홀수 행 색상
                    
                        return Container(
                          color: rowColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['time'] ?? '',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 30),
                                    child: Text(
                                      data['location'] ?? '',
                                      style: TextStyle(
                                          fontSize: Responsive.getFont(context, 14)),
                                    ),
                                  ),
                                ),
                                Text(
                                  data['status'] ?? '',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 14)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          MoveTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
