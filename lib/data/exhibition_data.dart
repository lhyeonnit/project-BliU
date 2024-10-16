import 'package:BliU/data/product_data.dart';

class ExhibitionData {
  final int? etIdx;
  final String? etTitle;
  final String? etSubTitle;
  final String? etBanner;
  final String? etDetailBanner;
  final int? etProductCount;
  final List<ProductData> product;
  final List<String>? ptImg;

  ExhibitionData({
    required this.etIdx,
    required this.etTitle,
    required this.etSubTitle,
    required this.etBanner,
    required this.etDetailBanner,
    required this.etProductCount,
    required this.product,
    required this.ptImg,
  });

  // JSON to Object
  factory ExhibitionData.fromJson(Map<String, dynamic> json) {

    List<ProductData> product = [];
    if (json['product'] != null) {
      product = List<ProductData>.from((json['product'])?.map((item) {
        return ProductData.fromJson(item as Map<String, dynamic>);
      }).toList());
    }

    List<String>? ptImg;
    if (json['pt_img'] != null) {
      ptImg = List<String>.from(json['pt_img']);
    }

    return ExhibitionData(
      etIdx: json['et_idx'],
      etTitle: json['et_title'],
      etSubTitle: json['et_sub_title'],
      etBanner: json['et_banner'],
      etDetailBanner: json['et_detail_banner'],
      etProductCount: json['et_product_count'],
      product: product,
      ptImg: ptImg,
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'et_idx': etIdx,
      'et_title': etTitle,
      'et_sub_title': etSubTitle,
      'et_banner': etBanner,
      'et_detail_banner': etDetailBanner,
      'et_product_count': etProductCount,
      'product': product.map((it) => it.toJson()).toList(),
      'pt_img': ptImg,
    };
  }
}