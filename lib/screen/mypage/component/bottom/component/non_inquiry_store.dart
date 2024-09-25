

import 'dart:io';

import 'package:BliU/screen/mypage/viewmodel/inquiry_write_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class NonInquiryStore extends ConsumerStatefulWidget {
  const NonInquiryStore({super.key});

  @override
  _NonInquiryStoreState createState() => _NonInquiryStoreState();
}

class _NonInquiryStoreState extends ConsumerState<NonInquiryStore> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  int _imageCnt = 0;
  List<Widget> _addImagesWidget = [];
  List<XFile> _fileList = [];

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            margin: EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 문의 제목 입력
                _buildTitleTextField(_titleController, '문의 제목 입력'),

                // 문의 내용 입력
                _buildContentTextField(
                    _contentController, '문의 내용을 최소 10자 이상 입력해주세요.'),

                // 이미지 선택 영역
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '이미지',
                        style: TextStyle(
                          fontSize: Responsive.getFont(context, 14),
                        ),
                      ),
                      Text(
                        '$_imageCnt/4',
                        style: TextStyle(
                            fontSize: Responsive.getFont(context, 13),
                            color: Color(0xFF7B7B7B)),
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
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: Color(0xFFE7EAEF))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/images/my/btn_add_img.svg'),
                              Text(
                                '사진선택',
                                style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontSize: Responsive.getFont(context, 14)),
                              )
                            ],
                          ),
                        ),
                      ),

                      //추가함 이미지들
                       Row(
                          children: _addImagesWidget,
                        ),
                    ],
                  ),
                ),
                _buildTextField('답변받을 연락처', _phoneController, '휴대폰 번호 입력',
                    keyboardType: TextInputType.phone),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: Responsive.getHeight(context, 48),
              margin: EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  _qnaWrite(ref);
                },
                child: Center(
                  child: Text(
                    '등록',
                    style: TextStyle(
                      fontSize: Responsive.getFont(context, 14),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
        border: Border.all(
          color: Color(0xFFE7EAEF),
        ),
      ),
      child: Stack(
        children: [
            ClipRRect(
              borderRadius:
              BorderRadius.circular(6),
              child: Image.file(
                File(file.path),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
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
              child: SvgPicture.asset(
                  'assets/images/ic_del.svg'),
            ),
          ),
        ],
      ),
    );
  }

  void _addImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      _fileList = await picker.pickMultiImage(limit: 4);
      _addImageCheck();
    } catch (e) {
      print("Image Failed $e");
    }
  }

  void _qnaWrite(WidgetRef ref) async {
    final title = _titleController.text;
    final content = _contentController.text;
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
    // TODO 비회원 처리 필요
    final List<MultipartFile> files =
        _fileList.map((img) => MultipartFile.fromFileSync(img.path)).toList();
    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx();
      String qnaType = '2'; // 1 회원인 경우 2 비회원인 경우
      String mtHp = ''; // TODO 비회원 경우 입력
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
      ref
          .read(inquiryWriteModelProvider.notifier)
          .qnaSeller(formData)
          .then((resultData) {
        if (resultData != null) {
          Utils.getInstance()
              .showSnackBar(context, resultData.message.toString());
          if (resultData.result == true) {
            Navigator.pop(context);
          }
        } else {
          Utils.getInstance().showSnackBar(context, "Network Or Data Error");
        }
      });
    });
  }

  Widget _buildTitleTextField(
      TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: Responsive.getFont(context, 14),
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: Responsive.getFont(context, 14),
            color: Color(0xFF595959)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: Color(0xFFE1E1E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: Color(0xFFE1E1E1)),
        ),
      ),
    );
  }

  Widget _buildContentTextField(
      TextEditingController controller, String hintText) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      child: TextField(
        controller: controller,
        maxLines: 7,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: Responsive.getFont(context, 14),
              color: Color(0xFF595959)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xFFE1E1E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xFFE1E1E1)),
          ),
        ),
      ),
    );
  }
  Widget _buildTextField(String label, TextEditingController controller,
      String hintText,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (label.isNotEmpty)
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.getFont(context, 13))),
                Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text('*',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.getFont(context, 13),
                            color: Color(0xFFFF6192)))),
              ],
            ),
          ),
          if (label.isNotEmpty)
            TextField(
              style: TextStyle(
                fontSize: Responsive.getFont(context, 14),
              ),
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: Responsive.getFont(context, 14),
                    color: Color(0xFF595959)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFE1E1E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
