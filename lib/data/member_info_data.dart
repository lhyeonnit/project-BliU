import 'package:flutter/foundation.dart';

class MemberInfoData {
  final int? mtIdx;
  final String? mtId;
  final String? mtName;
  List<String>? mctStyle;
  String? mctBirth;
  String? mctGender;
  final int? cart;
  final String? childCk;
  final int? myRevieCount;
  final int? myCouponCount;
  final int? myPoint;
  final int? mtLoginType;

  MemberInfoData({
    required this.mtIdx,
    required this.mtId,
    required this.mtName,
    required this.mctStyle,
    required this.mctBirth,
    required this.mctGender,
    required this.cart,
    required this.childCk,
    required this.myRevieCount,
    required this.myCouponCount,
    required this.myPoint,
    required this.mtLoginType,
  });

  // JSON to Object
  factory MemberInfoData.fromJson(Map<String, dynamic> json) {
    List<String> mctStyle = [];
    try {
      if (json['mct_style'] != null) {
        mctStyle = List<String>.from(json['mct_style'] as Iterable<dynamic>);
      }
    } catch (e) {
      if (kDebugMode) {
        print('memberInfoData.fromJson E - ${e.toString()}');
      }
    }
    return MemberInfoData(
      mtIdx: json['mt_idx'],
      mtId: json['mt_id'],
      mtName: json['mt_name'],
      mctStyle: mctStyle,
      mctBirth: json['mct_birth'],
      mctGender: json['mct_gender'],
      cart: json['cart'],
      childCk: json['child_ck'],
      myRevieCount: json['my_revie_count'],
      myCouponCount: json['my_coupon_count'],
      myPoint: json['my_point'],
      mtLoginType: json['mt_login_type']
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'mt_idx': mtIdx,
      'mt_id': mtId,
      'mt_name': mtName,
      'mct_style': mctStyle,
      'mct_birth': mctBirth,
      'mct_gender': mctGender,
      'cart': cart,
      'child_ck': childCk,
      'my_revie_count': myRevieCount,
      'my_coupon_count': myCouponCount,
      'my_point': myPoint,
      'mt_login_type' : mtLoginType,
    };
  }
}