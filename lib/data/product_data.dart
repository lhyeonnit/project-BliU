import 'package:BliU/data/delivery_data.dart';
import 'package:BliU/data/product_attribute_data.dart';

class ProductData {
  final int? stIdx;
  final String? stName;
  final int? ptIdx;
  final String? ptName;
  final int? ptDelivery;
  final String? ptDeliveryNow;
  final String? ptCategory;
  final int? ptDiscountPer;
  final int? ptSellingPrice;
  final int? ptPrice;
  final String? ptImg;
  final int? ptLike;
  final int? ptReview;
  final int? ptReviewCount;
  String? likeChk;
  final String? sellStatus;
  final String? sellStatusTxt;
  final String? ptMainImg;
  final DeliveryData? deliveryInfo;
  final String? ptContent;
  final List<String>? imgArr;
  final ProductAttributeData? ptAttribute;

  ProductData({
    required this.stIdx,
    required this.stName,
    required this.ptIdx,
    required this.ptName,
    required this.ptDelivery,
    required this.ptDeliveryNow,
    required this.ptCategory,
    required this.ptDiscountPer,
    required this.ptSellingPrice,
    required this.ptPrice,
    required this.ptImg,
    required this.ptLike,
    required this.ptReview,
    required this.ptReviewCount,
    required this.likeChk,
    required this.sellStatus,
    required this.sellStatusTxt,
    required this.ptMainImg,
    required this.deliveryInfo,
    required this.ptContent,
    required this.imgArr,
    required this.ptAttribute,
  });

  // Factory method to create a ProductDTO from JSON
  factory ProductData.fromJson(Map<String, dynamic> json) {
    DeliveryData? deliveryInfo;
    if (json['delivery_info'] != null) {
      deliveryInfo = DeliveryData.fromJson(json['delivery_info']);
    }
    List<String>? imgArr;
    if (json['img_arr'] != null) {
      imgArr = List<String>.from(json['img_arr']);
    }

    ProductAttributeData? ptAttribute;
    if (json['pt_attribute'] != null) {
      ptAttribute = ProductAttributeData.fromJson(json['pt_attribute']);
    }

    return ProductData(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      ptIdx: json['pt_idx'],
      ptName: json['pt_name'],
      ptDelivery: json['pt_delivery'],
      ptDeliveryNow: json['pt_delivery_now'],
      ptCategory: json['pt_category'],
      ptDiscountPer: json['pt_discount_per'],
      ptSellingPrice: json['pt_selling_price'],
      ptPrice: json['pt_price'],
      ptImg: json['pt_img'],
      ptLike: json['pt_like'],
      ptReview: json['pt_review'],
      ptReviewCount: json['pt_review_count'],
      likeChk: json['like_chk'],
      sellStatus: json['sell_status'],
      sellStatusTxt: json['sell_status_txt'],
      ptMainImg: json['pt_main_img'],
      deliveryInfo: deliveryInfo,
      ptContent: json['pt_content'],
      imgArr: imgArr,
      ptAttribute: ptAttribute,
    );
  }

  // Method to convert a ProductDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'pt_idx': ptIdx,
      'pt_name': ptName,
      'pt_delivery_now': ptDeliveryNow,
      'pt_delivery': ptDelivery,
      'pt_category': ptCategory,
      'pt_discount_per': ptDiscountPer,
      'pt_selling_price': ptSellingPrice,
      'pt_price': ptPrice,
      'pt_img': ptImg,
      'pt_like': ptLike,
      'pt_review': ptReview,
      'pt_review_count': ptReviewCount,
      'like_chk': likeChk,
      'sell_status': sellStatus,
      'sell_status_txt': sellStatusTxt,
      'pt_main_img': ptMainImg,
      'delivery_info': deliveryInfo,
      'pt_content': ptContent,
      'img_arr': imgArr,
      'pt_attribute': ptAttribute,
    };
  }
}