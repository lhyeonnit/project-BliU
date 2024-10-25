import 'dart:io';

import 'package:BliU/screen/mypage/viewmodel/inquiry_write_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class InquiryStore extends ConsumerStatefulWidget {
  const InquiryStore({super.key});

  @override
  ConsumerState<InquiryStore> createState() => InquiryStoreState();
}

class InquiryStoreState extends ConsumerState<InquiryStore> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int _imageCnt = 0;
  final List<Widget> _addImagesWidget = [];
  final List<XFile> _fileList = [];

  bool _phoneNumVisible = false;
  bool _isAllFieldsFilled = false;

  void _checkIfAllFieldsFilled() {
    setState(() {
      if (_phoneNumVisible) {
        _isAllFieldsFilled = _titleController.text.isNotEmpty && _contentController.text.isNotEmpty && _phoneController.text.isNotEmpty;
      } else {
        _isAllFieldsFilled = _titleController.text.isNotEmpty && _contentController.text.isNotEmpty;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_checkIfAllFieldsFilled);
    _contentController.addListener(_checkIfAllFieldsFilled);
    _phoneController.addListener(_checkIfAllFieldsFilled);

    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx() ?? "";
      if (mtIdx.isEmpty) {
        setState(() {
          _phoneNumVisible = true;
        });
      }
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
        title: const Text('문의하기'),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.2,
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 동작
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
      bottomSheet: SafeArea(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                if (_isAllFieldsFilled) {
                  _qnaWrite();
                }
              },
              child: Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                decoration: BoxDecoration(
                  color: _isAllFieldsFilled ? Colors.black : const Color(0xFFDDDDDD),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    '등록',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: Responsive.getFont(context, 14),
                      color: _isAllFieldsFilled ? Colors.white : const Color(0xFF7B7B7B),
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              margin: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 문의 제목 입력
                  _buildTitleTextField(_titleController, '문의 제목 입력'),
                  // 문의 내용 입력
                  _buildContentTextField(_contentController, '문의 내용을 최소 10자 이상 입력해주세요.'),
                  // 이미지 선택 영역
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '이미지',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 14),
                            height: 1.2,
                          ),
                        ),
                        Text(
                          '$_imageCnt/4',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: Responsive.getFont(context, 13),
                            color: const Color(0xFF7B7B7B),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 이미지 선택 버튼
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // 이미지 선택 동작 추가
                            _addImage();
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: const Color(0xFFE7EAEF)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/images/my/btn_add_img.svg'),
                                Text(
                                  '사진선택',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: const Color(0xFF707070),
                                    fontSize: Responsive.getFont(context, 14),
                                    height: 1.2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(children: _addImagesWidget,),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _phoneNumVisible,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (label.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  '답변받을 연락처',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.getFont(context, 13),
                                    height: 1.2,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    '*',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.getFont(context, 13),
                                      color: const Color(0xFFFF6192),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                            style: TextStyle(
                              decorationThickness: 0,
                              height: 1.2,
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 14),
                            ),
                            controller: _phoneController,
                            obscureText: false,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                              hintText: '휴대폰 번호 입력',
                              hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14),
                                color: const Color(0xFF595959),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _addImageCheck() {
    setState(() {
      _addImagesWidget.clear();
      for (int i = 0; i < _fileList.length; i++) {
        _addImagesWidget.add(_addImageWidget(_fileList[i], i));
      }
      _imageCnt = _fileList.length;
    });
  }

  Widget _addImageWidget(XFile file, int index) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
        border: Border.all(
          color: const Color(0xFFE7EAEF),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(
              File(file.path),
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 8,
            right: 7,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _addImagesWidget.removeAt(index);
                  _fileList.removeAt(index);
                  _addImageCheck();
                });
              },
              child: SvgPicture.asset('assets/images/ic_del.svg'),
            ),
          ),
        ],
      ),
    );
  }

  void _addImage() async {
    if (_fileList.length >= 4) {
      Utils.getInstance().showSnackBar(context, "이미지는 4장까지 가능합니다.");
      return;
    }
    try {
      final ImagePicker picker = ImagePicker();
      final limitCnt = 4 - _fileList.length;
      final fileList = await picker.pickMultiImage(limit: limitCnt);
      _fileList.addAll(fileList);
      _addImageCheck();
    } catch (e) {
      if (kDebugMode) {
        print("Image Failed $e");
      }
    }
  }

  void _qnaWrite() async {
    final title = _titleController.text;
    final content = _contentController.text;
    final mtHp = _phoneController.text;
    if (title.isEmpty) {
      Utils.getInstance().showSnackBar(context, "문의 제목을 입력해 주세요.");
      return;
    }

    if (content.isEmpty) {
      Utils.getInstance().showSnackBar(context, "문의 내용을 입력해 주세요.");
      return;
    }

    if (content.length < 10) {
      Utils.getInstance().showSnackBar(context, "문의 내용은 10자 이상 입력해 주세요.");
      return;
    }

    if (_phoneNumVisible) {
      if (mtHp.isEmpty) {
        Utils.getInstance().showSnackBar(context, "휴대폰 번호를 입력해 주세요.");
        return;
      }
    }

    final List<MultipartFile> files = _fileList.map((img) => MultipartFile.fromFileSync(img.path)).toList();
    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx();
      String qnaType = '2'; // 1 회원인 경우 2 비회원인 경우
      if (mtIdx != null) {
        if (mtIdx.isNotEmpty) {
          qnaType = '1';
        }
      }

      final formData = FormData.fromMap({
        'qna_type': qnaType,
        'mt_idx': mtIdx,
        'mt_hp': mtHp,
        'qt_title': title,
        'qt_content': content,
        'seller_imgs': files,
      });

      ref.read(inquiryWriteModelProvider.notifier).qnaSeller(formData).then((resultData) {
        if (!mounted) return;
        if (resultData != null) {
          if (resultData.result == true) {
            Utils.getInstance().showSnackBar(context, "문의가 정상적으로 등록되었습니다");

            Navigator.pop(context);
          } else {
            Utils.getInstance().showSnackBar(context, resultData.message.toString());
          }
        } else {
          Utils.getInstance().showSnackBar(context, "Network Or Data Error");
        }
      });
    });
  }

  Widget _buildTitleTextField(TextEditingController controller, String hintText) {
    return TextField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      style: TextStyle(
        decorationThickness: 0,
        height: 1.2,
        fontFamily: 'Pretendard',
        fontSize: Responsive.getFont(context, 14),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 14),
          color: const Color(0xFF595959),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: Color(0xFFE1E1E1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: Color(0xFFE1E1E1)),
        ),
      ),
    );
  }

  Widget _buildContentTextField(TextEditingController controller, String hintText) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 20),
      child: TextField(
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        style: TextStyle(
          decorationThickness: 0,
          height: 1.2,
          fontFamily: 'Pretendard',
          fontSize: Responsive.getFont(context, 14),
        ),
        controller: controller,
        maxLines: 7,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 14),
            color: const Color(0xFF595959),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xFFE1E1E1)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xFFE1E1E1)),
          ),
        ),
      ),
    );
  }
}
