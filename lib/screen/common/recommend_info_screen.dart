import 'package:BliU/data/style_category_data.dart';
import 'package:BliU/screen/_component/move_top_button.dart';
import 'package:BliU/screen/common/viewmodel/recommend_info_view_model.dart';
import 'package:BliU/screen/main_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class RecommendInfoScreen extends ConsumerStatefulWidget {
  const RecommendInfoScreen({super.key});

  @override
  ConsumerState<RecommendInfoScreen> createState() =>
      _RecommendInfoScreenState();
}

class _RecommendInfoScreenState extends ConsumerState<RecommendInfoScreen>
    with SingleTickerProviderStateMixin {
  bool _isBottomSheetVisible = false;
  bool _isAppBarVisible = false;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _birthController = TextEditingController(text: '선택해주세요');

  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  List<StyleCategoryData> styleCategories = [];
  final List<StyleCategoryData> _selectedStyles = [];
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // 애니메이션 컨트롤러 설정
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900), vsync: this,
    );

    // 바텀시트 애니메이션 시작 위치와 끝 위치
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // 화면 아래에서 시작
      end: Offset.zero, // 화면 안으로 들어옴
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // 부드러운 애니메이션 곡선
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isAppBarVisible = true;
        _isBottomSheetVisible = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _animationController.forward();
        }
      });
      _afterBuild(context);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isAppBarVisible
          ? AppBar(
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
                  color: const Color(0xFFF4F4F4), // 하단 구분선 색상
                  height: 1.0, // 구분선의 두께 설정
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/마스크 그룹 14.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              bottom: 55,
                right: 74,
                left: 75,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0x9069828B),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Center(
                    child: Text(
                      '당신의 자녀는 어떤아이인가요?',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: Responsive.getFont(context, 15),
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
            ),
            // Visibility(
            //   visible: _isAppBarVisible,
            //   child: Positioned(
            //     top: 0,
            //     left: 0,
            //     right: 0,
            //     child: SafeArea(
            //       child: Container(
            //         height: 56.0,  // 기본 AppBar 높이
            //         decoration: const BoxDecoration(
            //           color: Colors.white, // 앱바 배경색
            //           boxShadow: [
            //             BoxShadow(
            //               color: Color(0x0D000000),
            //               spreadRadius: 1,
            //               blurRadius: 6,
            //               offset: Offset(0, 3), // 그림자 위치
            //             ),
            //           ],
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Container(
            //               margin: const EdgeInsets.only(left: 16, right: 15),
            //               child: GestureDetector(
            //                 onTap: () {
            //                   Navigator.pop(context);
            //                 },
            //                 child: SvgPicture.asset("assets/images/product/ic_back.svg"),
            //               ),
            //             ),
            //             Text(
            //               '추천정보',
            //               style: TextStyle(
            //                 fontFamily: 'Pretendard',
            //                 fontSize: Responsive.getFont(context, 18),
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.black,
            //                 height: 1.2,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            Visibility(
              visible: _isBottomSheetVisible,
              child: SlideTransition(
                position: _offsetAnimation,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5, // 바텀 시트가 처음 열릴 때 높이
                  minChildSize: 0.5,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          controller: scrollController, // 스크롤 가능하도록 설정
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFF4F4F4),
                                  blurRadius: 6.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20, bottom: 17),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDDDDDD),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 12.5, bottom: 80),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '자녀의 정보를 입력해주세요',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: Responsive.getFont(context, 20),
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 8, bottom: 30),
                                            child: Text(
                                              '입력해주신 정보를 토대로 상품을 추천해드립니다.',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: Responsive.getFont(context, 14),
                                                color: const Color(0xFF7B7B7B),
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                              border: Border.all(
                                                color: const Color(0xFFDDDDDD),
                                              ),
                                            ),
                                            child: _birthdayText(),
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
                                                      'Boy'),
                                                  const SizedBox(width: 10),
                                                  _genderSelect(
                                                      'assets/images/gender_select_girl.png',
                                                      'Girl'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                  onTap: () => _submitRecommendInfo(),
                                  child: Container(
                                    height: 48,
                                    margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(Radius.circular(6),
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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

  Widget _birthdayText() {
    return GestureDetector(
      onTap: () {
        _selectDate();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
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
                  color: const Color(0xFFFF6192),
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
      barrierColor: Colors.black.withOpacity(0.3),
      isScrollControlled: true, // 모달이 화면을 꽉 채우도록 설정
      builder: (context) {
        return SafeArea(
          child: Container(
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
                  padding: const EdgeInsets.only(right: 16.0, left: 16, top: 15, bottom: 15),
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
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                ),
                // 날짜 선택기
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 17),
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
                              margin: const EdgeInsets.only(left: 17, right: 15),
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(color: Color(0xFFDDDDDD))),
                              ),
                            ),
                            squeeze: 1,
                            scrollController: FixedExtentScrollController(initialItem: selectedYear - 1900),
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
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(color: Color(0xFFDDDDDD))),
                              ),
                            ),
                            diameterRatio: 5.0,
                            squeeze: 1,
                            scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
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
                              margin: const EdgeInsets.only(left: 15, right: 17),
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(color: Color(0xFFDDDDDD))),
                              ),
                            ),
                            diameterRatio: 5.0,
                            squeeze: 1,
                            scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
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
                    margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(6),
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

  void _submitRecommendInfo() async {
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
    Map<String, dynamic> requestData = {
      'idx': mtIdx,
      'birth': formattedDate,
      'gender': _selectedGender,
      'style': styleValue,
    };

    final defaultResponseDTO = await ref.read(recommendInfoModelProvider.notifier).saveRecommendInfo(requestData);

    if (defaultResponseDTO != null && defaultResponseDTO.result == true) {
      if (memberInfo != null) {
        formattedDate = memberInfo.mctBirth ?? '';
        _selectedGender = memberInfo.mctGender ?? '';
        selectedStyleIds = memberInfo.mctStyle ?? [];
        pref.login(memberInfo);

        if(!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        ref.read(mainScreenProvider.notifier).selectNavigation(2);
      } else {
        if(!mounted) return;
        Utils.getInstance().showSnackBar(context, "회원 정보를 불러오지 못했습니다.");
      }
    } else {
      // 적절한 데이터 타입이 아닌 경우 처리
      if (kDebugMode) {
        print("Unexpected data type: ${defaultResponseDTO?.runtimeType}");
      }
    }
  }

  void _getStyleCategory() async {
    final styleCategoriesResponseDTO = await ref.read(recommendInfoModelProvider.notifier).getStyleCategory();

    if (styleCategoriesResponseDTO != null) {
      if (styleCategoriesResponseDTO.result == true) {
        setState(() {
          styleCategories = styleCategoriesResponseDTO.list ?? [];
        });
      }
    }
  }
}
