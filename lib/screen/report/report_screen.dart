import 'package:BliU/data/category_data.dart';
import 'package:BliU/screen/report/view_model/report_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportScreen extends ConsumerStatefulWidget {
  final int rtIdx;
  const ReportScreen({super.key, required this.rtIdx});

  @override
  ConsumerState<ReportScreen> createState() => ReportScreenState();
}

class ReportScreenState extends ConsumerState<ReportScreen> {
  final TextEditingController _controller = TextEditingController();
  
  List<CategoryData> categories = [];
  
  int? _selectedReason;
  
  bool _isReported = false;

  bool get _isOtherSelected => _selectedReason == 1;

  void _submitReport() async {
    if (_selectedReason == null) {
      Utils.getInstance().showSnackBar(context, "신고 사유를 선택해 주세요.");
      return;
    }

    if (_isOtherSelected) {
      if (_controller.text.isEmpty) {
        Utils.getInstance().showSnackBar(context, "신고 사유를 입력해 주세요.");
        return;
      }
    }

    final pref = await SharedPreferencesManager.getInstance();
    final mtIdx = pref.getMtIdx();

    Map<String, dynamic> requestData = {
      'mt_idx' : mtIdx,
      'rt_idx' : widget.rtIdx,
      'rt_category' : _selectedReason,
      'rt_category_txt' : _controller.text,
    };

    final defaultResponseDTO = await ref.read(reportViewModelProvider.notifier).reviewSingo(requestData);
    if (defaultResponseDTO != null) {
      if (defaultResponseDTO.result == true) {
        setState(() {
          _isReported = true;
        });

        // Dismiss the success message after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isReported = false;
            Navigator.pop(context);
          });
        });
      } else {
        if (!mounted) return;
        Utils.getInstance().showSnackBar(context, defaultResponseDTO.message ?? "");
      }
    }
  }

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text("신고하기"),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset('assets/images/product/ic_close.svg')
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: ScrollController(),
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        child: Text(
                          '신고의 부적합한 사용자/글을 지속적으로 신고하는 경우 제재 조치가 취해질 수 있으니 유의해 주세요',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            color: const Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ),
                      ...categories.map((category) {
                        final idx = category.cstIdx ?? 0;
                        final name = category.ctName ?? "";
                        return _buildRadioOption(idx, name);
                      }),
                      Visibility(
                        visible: _isOtherSelected,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 300, right: 16, left: 16),
                          child: TextField(
                            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                            style: TextStyle(
                              decorationThickness: 0,
                              height: 1.2,
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                            ),
                            controller: _controller,
                            maxLines: 4,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                              hintText: '직접 입력해주세요',
                              hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: const Color(0xFF595959),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(color: Colors.black),
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
            if (_isReported)
              Positioned(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xCC000000), // 알림창 배경색
                        borderRadius: BorderRadius.circular(22), // 둥근 모서리
                      ),
                      child: const Text(
                        "신고하기가 완료되었습니다!",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _submitReport,
                child: Container(
                  width: double.infinity,
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _afterBuild(BuildContext context) {
    _getCategory();
  }

  void _getCategory() async {
    final categoryResponseDTO = await ref.read(reportViewModelProvider.notifier).getCategory();
    if (categoryResponseDTO != null) {
      if (categoryResponseDTO.result == true) {
        setState(() {
          categories = categoryResponseDTO.list ?? [];
        });
      }
    }
  }

  Widget _buildRadioOption(int idx, String name) {
    // return RadioListTile(
    //   title: Text(
    //     name,
    //     style: TextStyle(
    //       fontFamily: 'Pretendard',
    //       fontSize: Responsive.getFont(context, 14),
    //       height: 1.2,
    //     ),
    //   ),
    //   activeColor: const Color(0xFFFF6192),
    //   fillColor: WidgetStateProperty.resolveWith((states) {
    //     if (!states.contains(WidgetState.selected)) {
    //       return const Color(0xFFDDDDDD); // 비선택 상태의 라디오 버튼 색상
    //     }
    //     return const Color(0xFFFF6192); // 선택된 상태의 색상
    //   }),
    //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //   value: idx,
    //   groupValue: _selectedReason,
    //   onChanged: (value) {
    //     setState(() {
    //       _selectedReason = value;
    //     });
    //   }
    // );

    return Row(
      children: [

        Radio<int>(
          activeColor: const Color(0xFFFF6192),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (!states.contains(WidgetState.selected)) {
              return const Color(0xFFDDDDDD); // 비선택 상태의 라디오 버튼 색상
            }
            return const Color(0xFFFF6192); // 선택된 상태의 색상
          }),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: idx,
          groupValue: _selectedReason,
          onChanged: (int? newValue) {
            setState(() {
              _selectedReason = newValue;
            });
          },
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
