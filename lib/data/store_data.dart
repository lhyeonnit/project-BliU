import 'package:BliU/data/product_data.dart';

class StoreData {
  final int? stIdx;
  final String? stName;
  final String? stProfile;
  final String? stBackground;
  final int? stLike;
  final String? stStyle;
  final String? stStyleTxt;
  final String? stAge;
  final String? stAgeTxt;
  final List<ProductData>? list;

  StoreData({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stBackground,
    required this.stLike,
    required this.stStyle,
    required this.stStyleTxt,
    required this.stAge,
    required this.stAgeTxt,
    required this.list,
  });

  // JSON 데이터를 StoreDetailDataDTO 객체로 변환하는 factory 메서드
  factory StoreData.fromJson(Map<String, dynamic> json) {
    return StoreData(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      stProfile: json['st_profile'],
      stBackground: json['st_background'],
      stLike: json['st_like'],
      stStyle: json['st_style'],
      stStyleTxt: json['st_style_txt'],
      stAge: json['st_age'],
      stAgeTxt: json['st_age_txt'],
      list: (json['list'] as List).map((item) => ProductData.fromJson(item)).toList(),
    );
  }

  // StoreDetailDataDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
      'st_background': stBackground,
      'st_like': stLike,
      'st_style': stStyle,
      'st_style_txt': stStyleTxt,
      'st_age': stAge,
      'st_age_txt': stAgeTxt,
      'list': list?.map((product) => product.toJson()).toList(),
    };
  }
}
