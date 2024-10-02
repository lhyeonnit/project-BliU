import 'package:BliU/data/delivery_data.dart';

class StoreProductData {
  final int? ptIdx;
  final String? ptName;
  final int? ptDiscountPer;
  final int? ptSellingPrice;
  final int? ptPrice;
  final String? ptImg;
  final int? ptLike;
  final int? ptReview;
  String? likeChk;
  final String? sellStatus;
  final String? sellStatusTxt;

  StoreProductData({
    required this.ptIdx,
    required this.ptName,
    required this.ptDiscountPer,
    required this.ptSellingPrice,
    required this.ptPrice,
    required this.ptImg,
    required this.ptLike,
    required this.ptReview,
    required this.likeChk,
    required this.sellStatus,
    required this.sellStatusTxt,
  });

  // Factory method to create a ProductDTO from JSON
  factory StoreProductData.fromJson(Map<String, dynamic> json) {
    return StoreProductData(
      ptIdx: json['pt_idx'],
      ptName: json['pt_name'],
      ptDiscountPer: json['pt_discount_per'],
      ptSellingPrice: json['pt_selling_price'],
      ptPrice: json['pt_price'],
      ptImg: json['pt_img'],
      ptLike: json['pt_like'],
      ptReview: json['pt_review'],
      likeChk: json['like_chk'],
      sellStatus: json['sell_status'],
      sellStatusTxt: json['sell_status_txt'],
    );
  }

  // Method to convert a ProductDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'pt_idx': ptIdx,
      'pt_name': ptName,
      'pt_discount_per': ptDiscountPer,
      'pt_selling_price': ptSellingPrice,
      'pt_price': ptPrice,
      'pt_img': ptImg,
      'pt_like': ptLike,
      'pt_review': ptReview,
      'like_chk': likeChk,
      'sell_status': sellStatus,
      'sell_status_txt': sellStatusTxt,
    };
  }
}