// import 'dart:io';
//
// import 'package:BliU/screen/mypage/component/top/component/my_review_detail.dart';
// import 'package:BliU/utils/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ReviewWriteScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> orders;
//
//   const ReviewWriteScreen({
//     super.key,
//     required this.orders,
//   });
//
//   @override
//   State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
// }
//
// class Review {
//   final String store; // 스토어 이름
//   final String name; // 상품 이름
//   final String size;
//   final String image;
//   final String reviewText; // 리뷰 텍스트
//   final List<File> images; // 이미지 파일 리스트
//   final double rating;
//
//   Review({
//     required this.store,
//     required this.name,
//     required this.size,
//     required this.image,
//     required this.reviewText,
//     required this.images,
//     required this.rating,
//   });
// }
//
// class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
//   late final _ratingController;
//   late double _rating;
//   int _ratingBarMode = 1;
//   double _initialRating = 5.0;
//   bool _isRTLMode = false;
//   bool _isVertical = false;
//
//   IconData? _selectedIcon;
//
//   List<File> _selectedImages = [];
//   final ImagePicker _picker = ImagePicker();
//   final ScrollController _scrollController = ScrollController();
//   String _reviewText = '';
//
//   Future<void> _pickImages() async {
//     final List<XFile>? images = await _picker.pickMultiImage(
//       maxWidth: 400,
//       maxHeight: 400,
//       imageQuality: 80,
//     );
//     if (images != null) {
//       setState(() {
//         // 현재 선택된 이미지 개수에 따라 추가될 이미지를 제한
//         if (_selectedImages.length + images.length <= 4) {
//           _selectedImages
//               .addAll(images.map((image) => File(image.path)).toList());
//         } else {
//           // 남은 자리에만 이미지를 추가
//           int remainingSlots = 4 - _selectedImages.length;
//           _selectedImages.addAll(images
//               .take(remainingSlots)
//               .map((image) => File(image.path))
//               .toList());
//         }
//       });
//     }
//   }
//
//   void _submitReview(int orderIndex) {
//     if (_reviewText.length >= 10) {
//       // orders에서 필요한 정보를 꺼내서 사용
//       Map<String, dynamic> selectedOrder = widget.orders[orderIndex];
//       String store = selectedOrder['items'][0]['store'] ?? "";
//       String name = selectedOrder['items'][0]['name'] ?? "";
//       String size = selectedOrder['items'][0]['size'] ?? "";
//       String image = selectedOrder['items'][0]['image'] ?? "";
//       Review review = Review(
//         store: store,
//         name: name,
//         size: size,
//         image: image,
//         reviewText: _reviewText,
//         images: _selectedImages,
//         rating: _rating,
//       );
//
//       // 리뷰 데이터를 전달하며 MyReviewScreen으로 이동
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MyReviewDetail(
//             review: review,
//           ),
//         ),
//       );
//     } else {
//       // 리뷰가 너무 짧을 때 사용자에게 알림
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('리뷰는 최소 10자 이상이어야 합니다.')),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _ratingController = TextEditingController(text: '5.0');
//     _rating = _initialRating;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         backgroundColor: Colors.white,
//         title: const Text('리뷰쓰기'),
//         titleTextStyle: TextStyle(
//           fontFamily: 'Pretendard',
//           fontSize: Responsive.getFont(context, 18),
//           fontWeight: FontWeight.w600,
//           color: Colors.black,
//           height: 1.2,
//         ),
//         leading: IconButton(
//           icon: SvgPicture.asset("assets/images/store/ic_back.svg"),
//           onPressed: () {
//             Navigator.pop(context); // 뒤로가기 동작
//           },
//         ),
//         titleSpacing: -1.0,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0), // 하단 구분선의 높이 설정
//           child: Container(
//             color: const Color(0xFFF4F4F4), // 하단 구분선 색상
//             height: 1.0, // 구분선의 두께 설정
//             child: Container(
//               height: 1.0, // 그림자 부분의 높이
//               decoration: const BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0xFFF4F4F4),
//                     blurRadius: 6.0,
//                     spreadRadius: 1.0,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           ListView(
//             controller: _scrollController,
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 16),
//                     padding: EdgeInsets.only(top: 50),
//                     child: Column(
//                       children: [
//                         Text(
//                           '상품은 어떠셨나요?',
//                           style: TextStyle(
//                             fontFamily: 'Pretendard',
//                             fontSize: Responsive.getFont(context, 16),
//                             fontWeight: FontWeight.bold,
//                             height: 1.2,
//                           ),
//                         ),
//                         Directionality(
//                           textDirection: _isRTLMode
//                               ? TextDirection.rtl
//                               : TextDirection.ltr,
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: <Widget>[
//                                 Container(
//                                     width: 250,
//                                     margin: EdgeInsets.symmetric(vertical: 20),
//                                     child: _ratingBar(_ratingBarMode)),
//                               ],
//                             ),
//                           ),
//                         ),
//                         TextField(
//                           style: TextStyle(
//                               fontFamily: 'Pretendard',
//                               fontSize: Responsive.getFont(context, 14)),
//                           maxLines: 9,
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 14, horizontal: 15),
//                             hintText:
//                                 '최소 10자 이상 입력해주세요. \n구매하신 상품에 대한 솔직한 리뷰를 남겨주세요. :)',
//                             hintStyle: TextStyle(
//                                 fontFamily: 'Pretendard',
//                                 fontSize: Responsive.getFont(context, 14),
//                                 color: Color(0xFF595959)),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(6)),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(6)),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               _reviewText = value;
//                             });
//                           },
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(bottom: 10, top: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '이미지',
//                                 style: TextStyle(
//                                   fontFamily: 'Pretendard',
//                                   fontSize: Responsive.getFont(context, 13),
//                                   height: 1.2,
//                                 ),
//                               ),
//                               Text(
//                                 '${_selectedImages.length}/4',
//                                 style: TextStyle(
//                                   fontFamily: 'Pretendard',
//                                   fontSize: Responsive.getFont(context, 13),
//                                   color: Color(0xFF7B7B7B),
//                                   height: 1.2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(left: 16),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: _pickImages,
//                           child: Container(
//                             width: 100,
//                             height: 100,
//                             margin: const EdgeInsets.only(right: 10),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: const BorderRadius.all(Radius.circular(6)),
//                                 border: Border.all(color: const Color(0xFFE7EAEF))
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset('assets/images/my/btn_add_img.svg'),
//                                 Text(
//                                   '사진선택',
//                                   style: TextStyle(
//                                     fontFamily: 'Pretendard',
//                                     color: const Color(0xFF707070),
//                                     fontSize: Responsive.getFont(context, 14),
//                                     height: 1.2,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         if (_selectedImages.isNotEmpty)
//                           Expanded(
//                             child: Container(
//                               height: 100,
//                               child: ListView.builder(
//                                 controller: _scrollController,
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: _selectedImages.length,
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     margin: EdgeInsets.only(right: 10),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(6),
//                                       ),
//                                       border: Border.all(
//                                         color: Color(0xFFE7EAEF),
//                                       ),
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(6),
//                                           // 모서리를 둥글게 설정 (6)
//                                           child: Image.file(
//                                             _selectedImages[index],
//                                             width: 100,
//                                             height: 100,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                         Positioned(
//                                           top: 8,
//                                           right: 7,
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 _selectedImages.removeAt(index);
//                                               });
//                                             },
//                                             child: SvgPicture.asset('assets/images/ic_del.svg'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               width: double.infinity,
//               height: Responsive.getHeight(context, 48),
//               margin: EdgeInsets.only(right: 16.0, left: 16, top: 9, bottom: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(6),
//                 ),
//               ),
//               child: GestureDetector(
//                 onTap: () => _submitReview(0),
//                 child: Center(
//                   child: Text(
//                     '등록',
//                     style: TextStyle(
//                       fontFamily: 'Pretendard',
//                       fontSize: Responsive.getFont(context, 14),
//                       color: Colors.white,
//                       height: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _ratingBar(int mode) {
//     return RatingBar.builder(
//       glow: false,
//       initialRating: _initialRating,
//       minRating: 1,
//       direction: _isVertical ? Axis.vertical : Axis.horizontal,
//       allowHalfRating: true,
//       unratedColor: Color(0xFFEEEEEE),
//       itemCount: 5,
//       itemSize: 50.0,
//       itemBuilder: (context, _) => Icon(
//         _selectedIcon ?? Icons.star,
//         color: Color(0xFFFF6191),
//       ),
//       onRatingUpdate: (rating) {
//         setState(() {
//           _rating = rating;
//         });
//       },
//       updateOnDrag: true,
//     );
//   }
// }
