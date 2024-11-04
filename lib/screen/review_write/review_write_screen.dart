import 'dart:io';

import 'package:BliU/data/order_detail_data.dart';
import 'package:BliU/screen/product_review_detail/product_review_detail_screen.dart';
import 'package:BliU/screen/review_write/view_model/review_write_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ReviewWriteScreen extends ConsumerStatefulWidget {
  final OrderDetailData orderDetailData;

  const ReviewWriteScreen({super.key, required this.orderDetailData});

  @override
  ConsumerState<ReviewWriteScreen> createState() => ReviewWriteScreenState();
}

class ReviewWriteScreenState extends ConsumerState<ReviewWriteScreen> {
  late double _rating;
  final int _ratingBarMode = 1;
  late TextEditingController _reviewController;
  final double _initialRating = 5.0;
  final bool _isRTLMode = false;
  final bool _isVertical = false;

  IconData? _selectedIcon;

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

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
          _selectedImages.addAll(
            images.map((image) => File(image.path)).toList()
          );
        } else {
          // 남은 자리에만 이미지를 추가
          int remainingSlots = 4 - _selectedImages.length;
          _selectedImages.addAll(
            images.take(remainingSlots).map((image) => File(image.path)).toList()
          );
        }
      });
    }
  }

  void _submitReview() async {
    if (_reviewController.text.length >= 10) {
      final pref = await SharedPreferencesManager.getInstance();
      final mtIdx = pref.getMtIdx();

      final fileList = _selectedImages;
      final List<MultipartFile> files = fileList.map((img) => MultipartFile.fromFileSync(img.path, contentType: DioMediaType("image", "jpg"))).toList();

      final formData = FormData.fromMap({
        'mt_idx': mtIdx,
        'ct_idx': widget.orderDetailData.ctIdx,
        'rt_start': _rating,
        'rt_content': _reviewController.text,
        'rt_img': files,
      });

      final responseData = await ref.read(reviewWriteViewModelProvider.notifier).reviewWrite(formData);
      if (responseData != null) {
        if (responseData['result'] == true) {
          if (!mounted) return;
          Utils.getInstance().showSnackBar(context, "등록 되었습니다");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProductReviewDetailScreen(rtIdx: (responseData['data']['rt_idx'] ?? 0)),
            ),
          );
        } else {
          if (!mounted) return;
          Utils.getInstance().showSnackBar(context, responseData['data']['message'] ?? "");
        }
      }
    } else {
      // 리뷰가 너무 짧을 때 사용자에게 알림
      Utils.getInstance().showSnackBar(context, '리뷰는 최소 10자 이상이어야 합니다.');
    }
  }

  @override
  void initState() {
    super.initState();
    _rating = _initialRating;
    _reviewController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('리뷰쓰기'),
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
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: _scrollController,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Text(
                            '상품은 어떠셨나요?',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: Responsive.getFont(context, 16),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Directionality(
                            textDirection: _isRTLMode ? TextDirection.rtl : TextDirection.ltr,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 250,
                                      margin: const EdgeInsets.symmetric(vertical: 20),
                                      child: _ratingBar(_ratingBarMode)
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextField(
                            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                            controller: _reviewController,
                            style: TextStyle(
                                decorationThickness: 0,
                                height: 1.2,
                                fontFamily: 'Pretendard',
                                fontSize: Responsive.getFont(context, 14)
                            ),
                            maxLines: 9,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                              hintText: '최소 10자 이상 입력해주세요. \n구매하신 상품에 대한 솔직한 리뷰를 남겨주세요. :)',
                              hintStyle: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: Responsive.getFont(context, 14),
                                  color: const Color(0xFF595959)
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
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '이미지',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: Responsive.getFont(context, 13),
                                    height: 1.2,
                                  ),
                                ),
                                Text(
                                  '${_selectedImages.length}/4',
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
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(color: const Color(0xFFE7EAEF))
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
                          if (_selectedImages.isNotEmpty)
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                                        border: Border.all(
                                          color: const Color(0xFFE7EAEF),
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
                                              fit: BoxFit.contain,
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
              child: GestureDetector(
                  onTap: _submitReview,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(6),),
                    ),
                    child: Center(
                      child: Text(
                        '등록',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: Responsive.getFont(context, 14),
                          color: Colors.white,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingBar(int mode) {
    return RatingBar.builder(
      glow: false,
      initialRating: _initialRating,
      minRating: 1,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: true,
      unratedColor: const Color(0xFFEEEEEE),
      itemCount: 5,
      itemSize: 50.0,
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: const Color(0xFFFF6191),
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
