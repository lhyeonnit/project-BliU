import 'package:BliU/data/product_data.dart';

class ExhibitionData {
  final int? etIdx;
  final String? etTitle;
  final String? etSubTitle;
  final String? etBanner;
  final int? etProductCount;
  final List<ProductData>? product;

  ExhibitionData({
    required this.etIdx,
    required this.etTitle,
    required this.etSubTitle,
    required this.etBanner,
    required this.etProductCount,
    required this.product,
  });

  // JSON to Object
  factory ExhibitionData.fromJson(Map<String, dynamic> json) {
    return ExhibitionData(
      etIdx: json['et_idx'],
      etTitle: json['et_title'],
      etSubTitle: json['et_sub_title'],
      etBanner: json['et_banner'],
      etProductCount: json['et_product_count'],
      product: (json['product'] as List<ProductData>),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'et_idx': etIdx,
      'et_title': etTitle,
      'et_sub_title': etSubTitle,
      'et_banner': etBanner,
      'et_product_count': etProductCount,
      'product': product?.map((it) => it.toJson()).toList(),
    };
  }
}