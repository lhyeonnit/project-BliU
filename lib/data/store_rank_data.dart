import 'package:BliU/data/product_data.dart';

class StoreRankData {
  int? stIdx;
  String? stName;
  String? stProfile;
  String? stStyle;
  String? stStyleTxt;
  String? stAge;
  String? stAgeTxt;
  int? stMark;
  String? checkMark;
  List<ProductData>? productList;

  StoreRankData({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stStyle,
    required this.stStyleTxt,
    required this.stAge,
    required this.stAgeTxt,
    required this.stMark,
    required this.checkMark,
    required this.productList,
  });

  factory StoreRankData.fromJson(Map<String, dynamic> json) {
    final productList = List<ProductData>.from((json['product_list'])?.map((item) {
      return ProductData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return StoreRankData(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      stProfile: json['st_profile'],
      stStyle: json['st_style'],
      stStyleTxt: json['st_style_txt'],
      stAge: json['st_age'],
      stAgeTxt: json['st_age_txt'],
      stMark: json['st_mark'],
      checkMark: json['check_mark'],
      productList: productList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
      'st_style': stStyle,
      'st_style_txt': stStyleTxt,
      'st_age': stAge,
      'st_age_txt': stAgeTxt,
      'st_mark': stMark,
      'check_mark': checkMark,
      'product_list': productList,
    };
  }
}

