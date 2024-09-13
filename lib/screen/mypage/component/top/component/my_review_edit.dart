import 'dart:io';

import 'package:BliU/screen/mypage/component/top/review_write_screen.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class MyReviewEdit extends StatefulWidget {
  final Review review;

  const MyReviewEdit({
    super.key,
    required this.review,

  });

  @override
  State<MyReviewEdit> createState() => _MyReviewEditState();
}

class _MyReviewEditState extends State<MyReviewEdit> {
  bool _isRTLMode = false;
  bool _isVertical = false;

  IconData? _selectedIcon;
  late TextEditingController _reviewController;
  late double _rating;
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  List<File> _currentImages = [];
  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage(
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );

    if (images != null) {
      setState(() {
        // 현재 선택된 이미지와 새로 추가된 이미지의 개수를 합쳐 4개 이하로 제한
        int totalImagesCount = _currentImages.length + _selectedImages.length;
        if (totalImagesCount + images.length <= 4) {
          _selectedImages.addAll(images.map((image) => File(image.path)).toList());
        } else {
          int remainingSlots = 4 - totalImagesCount;
          _selectedImages.addAll(images.take(remainingSlots).map((image) => File(image.path)).toList());
        }
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _currentImages = widget.review.images; // 기존 이미지를 추가
    _reviewController = TextEditingController(text: widget.review.reviewText);
  }
  void _submitReview() {
    if (_reviewController.text.length >= 10) {
      // 리뷰 데이터 업데이트
      Review updatedReview = Review(
        store: widget.review.store,
        name: widget.review.name,
        size: widget.review.size,
        image: widget.review.image,
        reviewText: _reviewController.text,
        images: _currentImages + _selectedImages, // 기존 이미지와 새 이미지 결합
        rating: _rating,
      );

      // pop을 통해 업데이트된 리뷰 데이터를 전달
      Navigator.pop(context, updatedReview);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰는 최소 10자 이상이어야 합니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('리뷰수정'),
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
                          Directionality(
                            textDirection: _isRTLMode
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 250,
                                      margin: EdgeInsets.symmetric(vertical: 20),
                                      child: _ratingBar(1)),
                                ],
                              ),
                            ),
                          ),
                          TextField(
                            controller: _reviewController,
                            style: TextStyle(fontSize: Responsive.getFont(context, 14)),
                            maxLines: 10,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                              hintText: '최소 10자 이상 입력해주세요. \n구매하신 상품에 대한 솔직한 리뷰를 남겨주세요. :)',
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
                                Text('${_selectedImages.length+_currentImages.length}/4', style: TextStyle(fontSize: Responsive.getFont(context, 13), color: Color(0xFF7B7B7B)),),
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
                                  itemCount: _currentImages.length + _selectedImages.length,  // 기존 + 새 이미지 개수
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // 기존 이미지와 새 이미지를 구분해서 보여줍니다.
                                    File image;
                                    if (index < _currentImages.length) {
                                      image = _currentImages[index];  // 기존 이미지
                                    } else {
                                      image = _selectedImages[index - _currentImages.length];  // 새로 추가된 이미지
                                    }

                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                        border: Border.all(color: Color(0xFFE7EAEF)),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: Image.file(
                                              image,
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
                                                  // 삭제 시, 기존 이미지와 새 이미지 리스트에서 각각 제거
                                                  if (index < _currentImages.length) {
                                                    _currentImages.removeAt(index);
                                                  } else {
                                                    _selectedImages.removeAt(index - _currentImages.length);
                                                  }
                                                });
                                              },
                                              child: SvgPicture.asset('assets/images/ic_del.svg'),
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
                onTap: _submitReview,
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
  Widget _ratingBar(int mode) {
    return RatingBar.builder(
      glow: false,
      initialRating: widget.review.rating,
      minRating: 1,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: true,
      unratedColor: Color(0xFFEEEEEE),
      itemCount: 5,
      itemSize: 50.0,
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Color(0xFFFF6191),
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }
}
