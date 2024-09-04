class MemberInfoData {
  final int? mtIdx;
  final String? mtId;
  final String? mtName;
  final List<String>? mctStyle;
  final int? cart;
  final String? childCk;
  final int? myRevieCount;
  final int? myCouponCount;

  MemberInfoData({
    required this.mtIdx,
    required this.mtId,
    required this.mtName,
    required this.mctStyle,
    required this.cart,
    required this.childCk,
    required this.myRevieCount,
    required this.myCouponCount,
  });

  // JSON to Object
  factory MemberInfoData.fromJson(Map<String, dynamic> json) {
    return MemberInfoData(
      mtIdx: json['mt_idx'],
      mtId: json['mt_id'],
      mtName: json['mt_name'],
      mctStyle: List<String>.from(json['mct_style']),
      cart: json['cart'],
      childCk: json['child_ck'],
      myRevieCount: json['my_revie_count'],
      myCouponCount: json['my_coupon_count'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'mt_idx': mtIdx,
      'mt_id': mtId,
      'mt_name': mtName,
      'mct_style': mctStyle,
      'cart': cart,
      'child_ck': childCk,
      'my_revie_count': myRevieCount,
      'my_coupon_count': myCouponCount,
    };
  }
}