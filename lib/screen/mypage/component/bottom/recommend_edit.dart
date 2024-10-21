import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/common/viewmodel/recommend_info_view_model.dart';
import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/recommend_edit_info_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class RecommendEdit extends ConsumerStatefulWidget {
  const RecommendEdit({super.key});

  @override
  ConsumerState<RecommendEdit> createState() => _RecommendEditState();
}

class _RecommendEditState extends ConsumerState<RecommendEdit> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _birthController = TextEditingController(text: '선택해주세요');

  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  List<StyleCategoryData> styleCategories = [];
  List<StyleCategoryData> _selectedStyles = [];
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('추천정보'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/product/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: -1.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
          child: Container(
            color: const Color(0x0D000000), // 하단 구분선 색상
            height: 1.0, // 구분선의 두께 설정
            child: Container(
              height: 1.0, // 그림자 부분의 높이
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 6.0,
                    spreadRadius: 0.1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, bottom: 80),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '자녀의 출생년도',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 15),
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xFFDDDDDD)),
                          ),
                          child: birthdayText(),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '자녀의 성별',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 15),
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _genderSelect(
                                  'assets/images/gender_select_boy.png',
                                  'Boy'
                                ),
                                const SizedBox(width: 10,),
                                _genderSelect(
                                  'assets/images/gender_select_girl.png',
                                  'Girl'
                                ),
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
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '선호 스타일',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 15),
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                                Text(
                                  '* 다중선택가능',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 13),
                                    color: const Color(0xFFFF6192),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 4.0,
                            runSpacing: 10.0,
                            children: styleCategories.map((style) {
                              final isSelected = _selectedStyles.any((selected) => selected.fsIdx == style.fsIdx);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      // 이미 선택된 경우 선택 해제
                                      _selectedStyles.removeWhere((selected) => selected.fsIdx == style.fsIdx);
                                    } else {
                                      // 선택되지 않은 경우 추가
                                      _selectedStyles.add(style);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD),
                                      width: 1.0,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    style.cstName ?? '',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: Responsive.getFont(context, 14),
                                      color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                                      height: 1.2,
                                    ),
                                  ),
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
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () => _editRecommendInfo(),
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: Colors.white,
                            height: 1.2,
                          ),
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
    String genderValue = 'M';
    if (gender == 'Boy') {
      genderValue = 'M';
    } else if(gender == 'Girl') {
      genderValue = 'F';
    }

    bool isSelected = _selectedGender == genderValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = genderValue;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(
                color: isSelected ? const Color(0xFFFF6192) : const Color(0xFFDDDDDD)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                margin: const EdgeInsets.only(bottom: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xFFF5F9F9),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    const Color(0xFFF5F9F9),
                    isSelected ? BlendMode.dst : BlendMode.color, // 흑백 필터 적용
                  ),
                  child: Image.asset(
                    imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                gender,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  color: isSelected ? const Color(0xFFFF6192) : Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget birthdayText() {
    return GestureDetector(
      onTap: () {
        _selectDate();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                '출생년도',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: Responsive.getFont(context, 14),
                  height: 1.2,
                ),
              ),
            ),
            TextFormField(
              textAlign: TextAlign.center,
              enabled: false,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
              ),
              controller: _birthController,
              style: TextStyle(
                  fontFamily: 'Pretendard',
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
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12), // 상단 왼쪽, 오른쪽 12만큼 둥글게
            ),
          ),
          child: Column(
            children: <Widget>[
              // 상단 타이틀과 닫기 버튼
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, left: 16, top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '출생년도',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 18),
                        fontWeight: FontWeight.w600,
                        height: 1.2,
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
                          squeeze: 1,
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
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 16),
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
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
                          squeeze: 1,
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
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 16),
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
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
                          squeeze: 1,
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
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 16),
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
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
                    _birthController.text = convertDateTimeDisplay(_selectedDate.toString());
                  });
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  margin: EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
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
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 14),
                        color: Colors.white,
                        height: 1.2,
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

  void _afterBuild(BuildContext context) {
    _getStyleCategory();
  }
  void _getRecommendInfo() async {
    // SharedPreferences에서 사용자 정보 가져오기
    final pref = await SharedPreferencesManager.getInstance();
    final memberInfo = pref.getMemberInfo(); // 사용자의 전체 정보

    print("_getRecommendInfo ${memberInfo?.toJson()}");
    if (memberInfo != null) {
      setState(() {
        // 저장된 출생일 정보 설정
        if (memberInfo.mctBirth != null && memberInfo.mctBirth!.isNotEmpty) {
          _selectedDate = DateTime.parse(memberInfo.mctBirth!); // 출생일 데이터를 DateTime으로 변환
          _birthController.text = convertDateTimeDisplay(_selectedDate.toString());
        }
        // 저장된 성별 정보 설정
        _selectedGender = memberInfo.mctGender; // 성별 데이터

        // 저장된 스타일 정보 설정
        List<String> styleIds = memberInfo.mctStyle ?? [];
        _selectedStyles = styleCategories.where((style) {
          return styleIds.contains(style.fsIdx.toString());
        }).toList();
      });
    } else {
      if(!mounted) return;
      Utils.getInstance().showSnackBar(context, "저장된 사용자 정보를 불러오는 데 실패했습니다.");
    }
  }

  void _editRecommendInfo() async {
    final pref = await SharedPreferencesManager.getInstance();
    final memberInfo = pref.getMemberInfo();
    String? mtIdx = memberInfo?.mtIdx.toString();
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    List<String> selectedStyleIds = _selectedStyles.map((style) => style.fsIdx.toString()).toList();

    String styleValue = "";
    for (var selectedStyle in selectedStyleIds) {
      if(styleValue.isEmpty) {
        styleValue = selectedStyle;
      } else {
        styleValue += ",$selectedStyle";
      }
    }

    // 서버로 전송할 데이터
    Map<String, dynamic> requestData = {
      'idx': mtIdx,
      'birth': formattedDate,
      'gender': _selectedGender,
      'style': styleValue,
    };

    // 서버에 데이터 전송 및 응답 처리
    final defaultResponseDTO = await ref.read(RecommendEditInfoModelProvider.notifier).editRecommendInfo(requestData);

    if (defaultResponseDTO != null && defaultResponseDTO.result == true) {
      if (memberInfo != null) {
        memberInfo.mctBirth = formattedDate;
        memberInfo.mctGender = _selectedGender;
        memberInfo.mctStyle = selectedStyleIds;

        pref.login(memberInfo);

        if(!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );

        setState(() {
          ref.read(mainScreenProvider.notifier).selectNavigation(2);
        });
      } else {
        if(!mounted) return;
        Utils.getInstance().showSnackBar(context, "회원 정보를 불러오지 못했습니다.");
      }
    } else {
      // 적절한 데이터 타입이 아닌 경우 처리
      print("Unexpected data type: ${defaultResponseDTO?.runtimeType}");
    }
  }
  void _getStyleCategory() async {
    final styleCategoriesResponseDTO = await ref.read(RecommendInfoModelProvider.notifier).getStyleCategory();

    if (styleCategoriesResponseDTO != null && styleCategoriesResponseDTO.result == true) {
      setState(() {
        styleCategories = styleCategoriesResponseDTO.list ?? [];
      });

      // 스타일 카테고리 로드 후에 추천 정보를 불러옴
      _getRecommendInfo();
    } else {
      if(!mounted) return;
      Utils.getInstance().showSnackBar(context, "스타일 카테고리를 불러오는 데 실패했습니다.");
    }
  }
}
