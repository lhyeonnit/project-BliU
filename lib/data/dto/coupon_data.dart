class CouponDTO {
  final String? couponUsealbe;
  final int? couponIdx;
  final String? couponName;
  final String? couponDiscount;
  final int? couponPrice;
  final int? couponMinPrice;
  final int? couponMaxPrice;
  final String? couponEnd;

  CouponDTO({
    required this.couponUsealbe,
    required this.couponIdx,
    required this.couponName,
    required this.couponDiscount,
    required this.couponPrice,
    required this.couponMinPrice,
    required this.couponMaxPrice,
    required this.couponEnd,
  });

  // JSON to Object
  factory CouponDTO.fromJson(Map<String, dynamic> json) {
    return CouponDTO(
      couponUsealbe: json['coupon_usealbe'],
      couponIdx: json['coupon_idx'],
      couponName: json['coupon_name'],
      couponDiscount: json['coupon_discount'],
      couponPrice: json['coupon_price'],
      couponMinPrice: json['coupon_min_price'],
      couponMaxPrice: json['coupon_max_price'],
      couponEnd: json['coupon_end'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'coupon_usealbe': couponUsealbe,
      'coupon_idx': couponIdx,
      'coupon_name': couponName,
      'coupon_discount': couponDiscount,
      'coupon_price': couponPrice,
      'coupon_min_price': couponMinPrice,
      'coupon_max_price': couponMaxPrice,
      'coupon_end': couponEnd,

    };
  }
}

class CouponResponseDTO {
  final bool? result;
  final String? message;
  final List<CouponDTO>? data;

  CouponResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory CouponResponseDTO.fromJson(Map<String, dynamic> json) {
    return CouponResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as List<CouponDTO>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.map((it) => it.toJson()).toList(),
    };
  }
}