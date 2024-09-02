class MemberInfoDTO {
  final int? mtIdx;
  final String? mtId;
  final String? mtName;
  final List<String>? MctStyle;
  final int? Cart;
  final String? childCk;
  final int? myRevieCount;
  final int? myCouponCount;

  MemberInfoDTO({
    required this.mtIdx,
    required this.mtId,
    required this.mtName,
    required this.MctStyle,
    required this.Cart,
    required this.childCk,
    required this.myRevieCount,
    required this.myCouponCount,
  });

  // JSON to Object
  factory MemberInfoDTO.fromJson(Map<String, dynamic> json) {
    return MemberInfoDTO(
      mtIdx: json['mt_idx'],
      mtId: json['mt_id'],
      mtName: json['mt_name'],
      MctStyle: json['mct_style'],
      Cart: json['cart'],
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
      'mct_style': MctStyle,
      'cart': Cart,
      'child_ck': childCk,
      'my_revie_count': myRevieCount,
      'my_coupon_count': myCouponCount,
    };
  }
}

class MemberInfoResponseDTO {
  final bool? result;
  final String? message;
  MemberInfoDTO? data;

  MemberInfoResponseDTO({
    required this.result,
    required this.message,
    this.data
  });

  // JSON to Object
  factory MemberInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    return MemberInfoResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as MemberInfoDTO),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson(),
    };
  }
}