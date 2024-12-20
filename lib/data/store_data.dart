import 'package:BliU/data/product_data.dart';

class StoreData {
  final int? stIdx;
  final String? stName;
  final String? stProfile;
  final String? stBackground;
  final String? stBusiness;
  final String? stHp;
  int? stLike;
  final String? stStyle;
  final String? stStyleTxt;
  final String? stAge;
  final String? stAgeTxt;
  final String? stTxt2;
  String? checkMark;
  String? downCoupon;
  int? count;
  List<ProductData> list;

  StoreData({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stBackground,
    required this.stBusiness,
    required this.stHp,
    required this.stLike,
    required this.stStyle,
    required this.stStyleTxt,
    required this.stAge,
    required this.stAgeTxt,
    required this.stTxt2,
    required this.checkMark,
    required this.downCoupon,
    required this.count,
    required this.list,
  });

  // JSON 데이터를 StoreDetailDataDTO 객체로 변환하는 factory 메서드
  factory StoreData.fromJson(Map<String, dynamic> json) {
    List<ProductData> list = [];
    if (json['list'] != null) {
      list = List<ProductData>.from((json['list'])?.map((item) {
        return ProductData.fromJson(item as Map<String, dynamic>);
      }).toList());
    }

    return StoreData(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      stProfile: json['st_profile'],
      stBackground: json['st_background'],
      stBusiness: json['st_business'],
      stHp: json['st_hp'],
      stLike: json['st_like'],
      stStyle: json['st_style'],
      stStyleTxt: json['st_style_txt'],
      stAge: json['st_age'],
      stAgeTxt: json['st_age_txt'],
      stTxt2: json['st_txt2'],
      checkMark: json['check_mark'],
      downCoupon: json['down_coupon'],
      count: json['count'],
      list: list,
    );
  }

  // StoreDetailDataDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
      'st_background': stBackground,
      'st_business': stBusiness,
      'st_hp': stHp,
      'st_like': stLike,
      'st_style': stStyle,
      'st_style_txt': stStyleTxt,
      'st_age': stAge,
      'st_age_txt': stAgeTxt,
      'st_txt2': stTxt2,
      'check_mark': checkMark,
      'down_coupon' : downCoupon,
      'count': count,
      'list': list.map((product) => product.toJson()).toList(),
    };
  }
}
