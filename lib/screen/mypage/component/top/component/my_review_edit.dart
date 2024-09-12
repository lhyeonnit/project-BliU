import 'dart:io';

import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class MyReviewEdit extends StatefulWidget {
  // final int rating;
  final String reviewText;
  final List<String> images;

  const MyReviewEdit({
    super.key,
    // required this.rating,
    required this.reviewText,
    required this.images,
  });

  @override
  State<MyReviewEdit> createState() => _MyReviewEditState();
}

class _MyReviewEditState extends State<MyReviewEdit> {
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  List<String> _currentImages = [];
  Future<void> _pickImages() async {

    final List<XFile>? images = await _picker.pickMultiImage(
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );
    if (images != null) {
      setState(() {
        // 현재 선택된 이미지 개수에 따라 추가될 이미지를 제한
        if (_selectedImages.length + images.length <= 4) {
          _selectedImages
              .addAll(images.map((image) => File(image.path)).toList());
        } else {
          // 남은 자리에만 이미지를 추가
          int remainingSlots = 4 - _selectedImages.length;
          _selectedImages.addAll(images
              .take(remainingSlots)
              .map((image) => File(image.path))
              .toList());
        }
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _currentImages = widget.images; // 기존 이미지를 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('리뷰쓰기'),
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
              ListView(
                children: [Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Text(
                            '상품은 어떠셨나요?',
                            style: TextStyle(
                                fontSize: Responsive.getFont(context, 16),
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 250,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/product/ic_rv_on.svg',
                                  width: 50,
                                  height: 50,
                                ),
                                SvgPicture.asset(
                                  'assets/images/product/ic_rv_on.svg',
                                  width: 50,
                                  height: 50,
                                ),
                                SvgPicture.asset(
                                  'assets/images/product/ic_rv_on.svg',
                                  width: 50,
                                  height: 50,
                                ),
                                SvgPicture.asset(
                                  'assets/images/product/ic_rv_on.svg',
                                  width: 50,
                                  height: 50,
                                ),
                                SvgPicture.asset(
                                  'assets/images/product/ic_rv_on.svg',
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                            maxLines: 9,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                              hintText: widget.reviewText,
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
                            onChanged: (value) {
                              setState(() {
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('이미지', style: TextStyle(fontSize: Responsive.getFont(context, 13)),),
                                Text('${_selectedImages.length}/4', style: TextStyle(fontSize: Responsive.getFont(context, 13), color: Color(0xFF7B7B7B)),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(6)),border: Border.all(color: Color(0xFFE7EAEF))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/images/my/btn_add_img.svg'),
                                  Text('사진선택', style: TextStyle(color: Color(0xFF707070), fontSize: Responsive.getFont(context, 14)),)
                                ],
                              ),
                            ),
                          ),
                          if (_currentImages.isNotEmpty || _selectedImages.isNotEmpty)
                            Expanded(
                              child: Container(
                                height: 100,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
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
                                            borderRadius: BorderRadius.circular(6),
                                            // 모서리를 둥글게 설정 (6)
                                            child: Image.file(
                                              _selectedImages[index],
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
                                                  _selectedImages.removeAt(index);
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/images/ic_del.svg'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    ],
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
                onTap: () {},
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
}
