import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../common/component/date_bottom.dart';
import '../../my_screen.dart';

class RecommendEdit extends StatefulWidget {
  const RecommendEdit({super.key});

  @override
  State<RecommendEdit> createState() => _RecommendEditState();
}

List<String> favoriteStyles = [
  '캐주얼 (Casual)',
  '스포티 (Sporty)',
  '포멀 / 클래식 (Formal/Classic)',
  '베이직 (Basic)',
  '프린세스 / 페어리 (Princess/Fairy)',
  '힙스터 (Hipster)',
  '럭셔리 (Luxury)',
  '어반 스트릿 (Urban Street)',
  '로맨틱 (Romantic)',
];

class _RecommendEditState extends State<RecommendEdit> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController _birthController =
      TextEditingController(text: '선택해주세요');

  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  List<String> selectedStyles = [];
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('추천정보'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
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
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 80),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '자녀의 출생년도',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 15),
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: Color(0xFFDDDDDD)),
                            ),
                            child: BirthdayText(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '자녀의 성별',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 15),
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _genderSelect(
                                    'assets/images/gender_select_boy.png',
                                    'Boy'),
                                SizedBox(
                                  width: 10,
                                ),
                                _genderSelect(
                                    'assets/images/gender_select_girl.png',
                                    'Girl'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '선호 스타일',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 15),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '* 다중선택가능',
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 13),
                                      color: Color(0xFFFF6192)),
                                ),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 4.0,
                            runSpacing: 10.0,
                            children: favoriteStyles.map((style) {
                              // 선택 여부 확인
                              bool isSelected = selectedStyles.contains(style);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedStyles.remove(style);
                                    } else {
                                      selectedStyles.add(style);
                                    }
                                  });
                                },
                                child: Chip(
                                  label: Text(
                                    style,
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color(0xFFFF6192)
                                          : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: isSelected
                                          ? const Color(0xFFFF6192)
                                          : const Color(0xFFDDDDDD),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                MoveTopButton(scrollController: _scrollController),
                Container(
                  width: double.infinity,
                  height: Responsive.getHeight(context, 48),
                  margin:
                      EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderSelect(String imgPath, String gender) {
    bool isSelected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: isSelected ? Color(0xFFFF6192) : Color(0xFFDDDDDD)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(bottom: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color(0xFFF5F9F9),
                ),
                child: Image.asset(
                  imgPath,
                  // colorBlendMode: isSelected ? BlendMode.luminosity : BlendMode.clear,
                  // TODO 사진 흑백으로 변경 필요
                  color: isSelected ? null : Color(0x10000000),
                ),
              ),
              Text(
                gender,
                style: TextStyle(fontSize: Responsive.getFont(context, 14), color: isSelected ? Color(0xFFFF6192) : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BirthdayText() {
    return GestureDetector(
      onTap: () {
        _selectDate();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Text(
                '출생년도',
                style: TextStyle(fontSize: Responsive.getFont(context, 14)),
              ),
            ),
            TextFormField(
              textAlign: TextAlign.center,
              enabled: false,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
              ),
              controller: _birthController,
              style: TextStyle(
                  fontSize: Responsive.getFont(context, 16),
                  color: Color(0xFFFF6192),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true, // 모달이 화면을 꽉 채우도록 설정
      builder: (context) {
        return Container(
          height: 400,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              // 상단 타이틀과 닫기 버튼
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, left: 16, top: 18, bottom: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '출생년도',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFEEEEEE),
              ),
              // 날짜 선택기
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 년도 선택 부분
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          diameterRatio: 5.0,
                          itemExtent: 50,
                          selectionOverlay: Container(
                            margin: EdgeInsets.only(left: 17, right: 15),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal:
                                      BorderSide(color: Color(0xFFDDDDDD))),
                            ),
                          ),
                          squeeze: 0.9,
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedYear - 1900),
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedYear = 1900 + index;
                            });
                          },
                          children: List<Widget>.generate(
                            DateTime.now().year - 1900 + 1,
                            (int index) {
                              return Center(
                                child: Text(
                                  '${1900 + index}년', // 년도로 표시
                                  style: TextStyle(
                                      fontSize: Responsive.getFont(context, 16),
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // 월 선택 부분
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 50,
                          selectionOverlay: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal:
                                      BorderSide(color: Color(0xFFDDDDDD))),
                            ),
                          ),
                          diameterRatio: 5.0,
                          squeeze: 0.9,
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedMonth - 1),
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedMonth = index + 1;
                            });
                          },
                          children: List<Widget>.generate(12, (int index) {
                            return Center(
                              child: Text(
                                '${index + 1}월', // 월로 표시
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 16),
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          }),
                        ),
                      ), // 일 선택 부분
                      Expanded(
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 50,
                          selectionOverlay: Container(
                            margin: EdgeInsets.only(left: 15, right: 17),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal:
                                      BorderSide(color: Color(0xFFDDDDDD))),
                            ),
                          ),
                          diameterRatio: 5.0,
                          squeeze: 0.9,
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedDay - 1),
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedDay = index + 1;
                            });
                          },
                          children: List<Widget>.generate(31, (int index) {
                            return Center(
                              child: Text(
                                '${index + 1}일', // 일로 표시
                                style: TextStyle(
                                    fontSize: Responsive.getFont(context, 16),
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // '선택하기' 버튼
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(
                      selectedYear,
                      selectedMonth,
                      selectedDay,
                    );
                    _birthController.text =
                        convertDateTimeDisplay(_selectedDate.toString());
                  });
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: double.infinity,
                  height: Responsive.getHeight(context, 48),
                  margin:
                      EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '선택하기',
                      style: TextStyle(
                        fontSize: Responsive.getFont(context, 14),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthController.text = convertDateTimeDisplay(pickedDate.toString());
      });
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('yyyy년 MM월 dd일');
    final DateTime displayDate = displayFormatter.parse(date);
    return serverFormatter.format(displayDate);
  }
}
